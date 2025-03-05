# pragma version 0.4.0

"""
@ license: MIT
@ author: Bolo101


This smart contract implements a crowdfunding mechanism with minimum USD threshold.
It uses Chainlink price feeds to convert ETH to USD in real-time.
Key features:
- Accepts ETH contributions through the fund() function
- Enforces a minimum contribution amount ($5 USD)
- Converts between ETH and USD using Chainlink oracle
- Includes withdraw functionality (not yet implemented)
"""

interface AggregatorV3Interface:
    def decimals() -> uint8: view
    def description() -> String[1000]: view
    def version() -> uint256: view
    def latestAnswer() -> int256: view


MINIMUM_USD: constant(uint256) = as_wei_value(5, "ether")
PRICE_FEED : public(immutable(AggregatorV3Interface))
OWNER: public(immutable(address))

#Storage variables
funders: public(DynArray[address, 1000])
funders_to_amount: public(HashMap[address, uint256])

# Keep track of people who funded us
# keep track of amount sent




#Sepolia ETH/USD : 0x694AA1769357215DE4FAC081bf1f309aDC325306
@deploy
def __init__(price_feed_address: address):
    #Need to add 10*18 zeros to match eth_amount_in_usd precision. Can do by converting as ether using convert to add those zeros
    PRICE_FEED = AggregatorV3Interface(price_feed_address)
    OWNER = msg.sender

@external
@payable
def fund():
    """
    Allows users to send money to this contract
    Have a minimum $ amount send
    """
    usd_value_of_eth: uint256 = self._get_eth_to_usd_rate(msg.value)
    assert usd_value_of_eth >= MINIMUM_USD, "Not a valid amount of ETH"
    self.funders.append(msg.sender)
    self.funders_to_amount[msg.sender] += msg.value


@external
def withdraw():
    """
    Take the money out of the contract
    """
    assert msg.sender == OWNER, "Not the contract owner"
    send(OWNER, self.balance)
    for funder: address in self.funders: #Mapping must be reseted manually using for loop
        self.funders_to_amount[funder] = 0
    self.funders = [] #Reset funders record at every withdraw function call
    

@internal
@view
def _get_eth_to_usd_rate(eth_amount : uint256) -> uint256:
    """
    Amount sent to us in ETH is enough to buy us a coffee ?
    """
    price : int256 = staticcall PRICE_FEED.latestAnswer()
    # Multiply by 10**10 to adjust the price feed's 8 decimal places to match Ethereum's 18 decimal places standard
    # This scaling ensures accurate conversion between ETH and USD values
    eth_price: uint256 = convert(price, uint256) * (10 ** 10)

    # Calculate the USD value of the provided ETH amount
    # ETH amount (in wei) * ETH/USD price (scaled to 18 decimals) / 10^18
    # Division by 10^18 normalizes the result after multiplying two 18-decimal values
    # Result is USD value with proper decimal precision
    eth_amount_in_usd: uint256 = (eth_amount * eth_price) // (1 * (10 ** 18))
    return eth_amount_in_usd

@external
@view
def get_eth_to_usd_rate(eth_amount: uint256) -> uint256:
    return self._get_eth_to_usd_rate(eth_amount)
