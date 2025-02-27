# Understanding `staticcall` and `extcall` in Vyper 📞

## Introduction 🌐
In Vyper, interacting with other contracts is a fundamental capability for building complex decentralized applications. The language provides specialized keywords to control how these external interactions occur, with `staticcall` and `extcall` being two important mechanisms. These keywords help developers specify the exact behavior of cross-contract calls, providing both security and flexibility.

## The Basics of Contract Calls in Vyper 🔍
Before diving into the specific keywords, it's important to understand that in Ethereum (and EVM-compatible blockchains), a contract can call functions in other contracts in several ways:

1. **Regular Calls**: Can modify state and send ETH
2. **Static Calls**: Read-only calls that cannot modify state
3. **Delegate Calls**: Calls that execute external code in the context of the calling contract

## `staticcall`: Safe Read-Only Interactions ✨

### What is `staticcall`? 
`staticcall` is a low-level interface keyword in Vyper that enforces read-only operations when interacting with external contracts. It ensures that the called function cannot:
- Modify the state of any contract
- Create new contracts
- Send ETH
- Call non-view/non-pure functions
- Execute self-destruct

### When to Use `staticcall`
- When you only need to read data from another contract
- When you want to ensure that the called function cannot make state changes
- For security-critical operations where you need guaranteed read-only behavior

### Example Implementation 📝

```vyper
# @version 0.3.7

interface TokenBalance:
    def balanceOf(account: address) -> uint256: view

token_contract: public(address)

@external
def __init__(_token: address):
    self.token_contract = _token

@external
@view
def get_balance(account: address) -> uint256:
    # Using staticcall to ensure read-only operation
    return TokenBalance(self.token_contract).balanceOf(account)
    # The above implicitly uses staticcall since it's calling a view function

@external
@view
def get_balance_explicit(account: address) -> uint256:
    # Explicit staticcall usage - same effect as above but more explicit
    response: Bytes[32] = raw_call(
        self.token_contract,
        _abi_encode(account, method_id=method_id("balanceOf(address)")),
        max_outsize=32,
        is_static_call=True  # This enforces staticcall
    )
    return convert(_abi_decode(response, (uint256)), uint256)
```

### Gas Considerations ⛽
- `staticcall` operations typically use less gas than regular calls
- They're cheaper because the EVM knows these calls won't modify state

### Limitations ❌
- Cannot modify any state
- Cannot send ETH
- Cannot emit events from the called contract
- Will revert if the called function attempts any state changes

## `extcall`: Dynamic External Calls 🔄

### What is `extcall`?
`extcall` (or external call) is the more general form of contract interaction in Vyper. Unlike `staticcall`, it allows state modifications. This is typically used through Vyper's standard interface calling mechanism or with `raw_call` when `is_static_call` is set to `False` (which is the default).

### When to Use `extcall`
- When you need to modify the state of another contract
- When sending ETH to another contract
- When you need to call functions that write data or emit events

### Example Implementation 📝

```vyper
# @version 0.3.7

interface Token:
    def transfer(recipient: address, amount: uint256) -> bool: nonpayable
    def balanceOf(account: address) -> uint256: view

token_contract: public(address)

@external
def __init__(_token: address):
    self.token_contract = _token

@external
def transfer_tokens(recipient: address, amount: uint256) -> bool:
    # Regular external call (extcall) that can modify state
    return Token(self.token_contract).transfer(recipient, amount)

@external
def transfer_tokens_raw(recipient: address, amount: uint256) -> bool:
    # Explicit extcall using raw_call
    response: Bytes[32] = raw_call(
        self.token_contract,
        _abi_encode(recipient, amount, method_id=method_id("transfer(address,uint256)")),
        max_outsize=32,
        is_static_call=False  # This is an extcall (default behavior)
    )
    return convert(_abi_decode(response, (bool)), bool)
```

### Safety Considerations ⚠️
- `extcall` operations can modify state, so they require careful consideration
- They can potentially lead to reentrancy vulnerabilities if not properly guarded
- Always follow the Checks-Effects-Interactions pattern

## Comparison Between `staticcall` and `extcall` 📊

| Feature | `staticcall` | `extcall` |
|---------|------------|----------|
| State Modification | ❌ Not Allowed | ✅ Allowed |
| Sending ETH | ❌ Not Allowed | ✅ Allowed |
| Gas Usage | Lower | Higher |
| Security Risk | Lower | Higher |
| Use Case | Reading data | Modifying data |
| Reentrancy Risk | None | Potential |
| Emissions of Events | ❌ Not Allowed | ✅ Allowed |

## Implementation with `raw_call` 🧩

Vyper provides a low-level `raw_call` function that gives explicit control over how external calls are made:

```vyper
@external
def example_calls():
    # Static call example
    static_result: Bytes[100] = raw_call(
        target_contract,
        call_data,
        max_outsize=100,
        is_static_call=True,  # This makes it a staticcall
        revert_on_failure=True
    )
    
    # External call example
    ext_result: Bytes[100] = raw_call(
        target_contract,
        call_data,
        max_outsize=100,
        is_static_call=False,  # This makes it an extcall (default)
        value=amount_to_send,  # Can send ETH with extcall
        revert_on_failure=True
    )
```

## Best Practices ⭐

1. **Use `staticcall` When Possible**: If you only need to read data, always prefer `staticcall`
2. **Implement Reentrancy Guards**: When using `extcall`, protect against reentrancy attacks
3. **Handle Errors**: Always include proper error handling for both call types
4. **Check Return Values**: Validate the returned data from both call types
5. **Use Interfaces**: Define proper interfaces for contracts you're calling
6. **Gas Limits**: Set appropriate gas limits, especially for `extcall`
7. **Audit Interactions**: Have all cross-contract interactions audited for security

## Common Mistakes to Avoid ❗

1. **Misusing `staticcall`**: Attempting to modify state through a `staticcall`
2. **Ignoring Return Values**: Not checking if calls succeeded
3. **Reentrancy Vulnerabilities**: Not protecting `extcall` operations from reentrancy
4. **Insufficient Gas**: Not providing enough gas for the external operation
5. **Hardcoded Addresses**: Using hardcoded contract addresses instead of configurable parameters

## Advanced Usage: Combining with Low-Level Functions 🔧

```vyper
# @version 0.3.7

@external
def advanced_example(contract_addr: address, function_selector: bytes4, arg: uint256) -> uint256:
    # Create the call data with a function selector and argument
    call_data: Bytes[36] = concat(
        function_selector,
        convert(arg, bytes32)
    )
    
    # Make a static call
    result: Bytes[32] = raw_call(
        contract_addr,
        call_data,
        max_outsize=32,
        is_static_call=True
    )
    
    # Decode and return the result
    return convert(result, uint256)
```

## Real-World Applications 🌍

1. **DeFi Applications**: Reading token balances and allowances safely
2. **Price Oracles**: Fetching price data from oracle contracts
3. **Governance Systems**: Reading voting power without state changes
4. **Cross-Contract Communication**: Safely interacting with protocol components
5. **Multi-Step Transactions**: Checking conditions before making state changes