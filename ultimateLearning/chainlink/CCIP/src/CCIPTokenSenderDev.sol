// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IRouterClient} from "@chainlink/contracts@1.3.0/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts@1.3.0/src/v0.8/ccip/libraries/Client.sol";
import {IERC20} from "@chainlink/contracts@1.3.0/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/IERC20.sol";
import {SafeERC20} from "@chainlink/contracts@1.3.0/src/v0.8/vendor/openzeppelin-solidity/v4.8.3/contracts/token/ERC20/utils/SafeERC20.sol";
import {Ownable} from "@openzeppelin/contracts@5.2.0/access/Ownable.sol";

// Read 'CCIPTokenSender Smart Contract Implementation' section in the README.md file for more details

/**
 * THIS IS AN EXAMPLE CONTRACT THAT USES HARDCODED VALUES FOR CLARITY.
 * THIS IS AN EXAMPLE CONTRACT THAT USES UN-AUDITED CODE.
 * DO NOT USE THIS CODE IN PRODUCTION.
 */
contract CCIPTokenSender is Ownable {
    using SafeERC20 for IERC20;

    error CCIPTokenSender__InsufficientBalance(
        IERC20 token,
        uint256 currentBalance,
        uint256 requiredAmount
    );
    error CCIPTokenSender__NothingToWithdraw();

    // https://docs.chain.link/ccip/supported-networks/v1_2_0/testnet#ethereum-testnet-sepolia
    IRouterClient private constant CCIP_ROUTER =
        IRouterClient(0x0BF3dE8c5D3e8A2B34D2BEeB17ABfCeBaf363A59);
    // https://docs.chain.link/resources/link-token-contracts#ethereum-testnet-sepolia
    IERC20 private constant LINK_TOKEN =
        IERC20(0x779877A7B0D9E8603169DdbD7836e478b4624789);
    // https://developers.circle.com/stablecoins/docs/usdc-on-test-networks

    event USDCTransferred(
        bytes32 messageId,
        uint64 indexed destinationChainSelector,
        address indexed receiver,
        uint256 amount,
        uint256 ccipFee
    );

    constructor() Ownable(msg.sender) {}

    function transferTokens(
        address _receiver,
        uint256 _amount,
        uint64 _destinationChainSelector,
        address _tokenAddress
    ) external returns (bytes32 messageId) {
        if (_amount > IERC20(_tokenAddress).balanceOf(msg.sender)) {
            revert CCIPTokenSender__InsufficientBalance(
                IERC20(_tokenAddress),
                IERC20(_tokenAddress).balanceOf(msg.sender),
                _amount
            );
        }
        Client.EVMTokenAmount[]
            memory tokenAmounts = new Client.EVMTokenAmount[](1);
        Client.EVMTokenAmount memory tokenAmount = Client.EVMTokenAmount({
            token: address(_tokenAddress),
            amount: _amount
        });
        tokenAmounts[0] = tokenAmount;

        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(_receiver),
            data: "",
            tokenAmounts: tokenAmounts,
            extraArgs: Client._argsToBytes(
                Client.EVMExtraArgsV1({gasLimit: 0})
            ),
            feeToken: address(LINK_TOKEN)
        });

        uint256 ccipFee = CCIP_ROUTER.getFee(
            _destinationChainSelector,
            message
        );

        if (ccipFee > LINK_TOKEN.balanceOf(address(this))) {
            revert CCIPTokenSender__InsufficientBalance(
                LINK_TOKEN,
                LINK_TOKEN.balanceOf(address(this)),
                ccipFee
            );
        }

        LINK_TOKEN.approve(address(CCIP_ROUTER), ccipFee);

        IERC20(_tokenAddress).safeTransferFrom(
            msg.sender,
            address(this),
            _amount
        );
        IERC20(_tokenAddress).approve(address(CCIP_ROUTER), _amount);

        // Send CCIP Message
        messageId = CCIP_ROUTER.ccipSend(_destinationChainSelector, message);

        emit USDCTransferred(
            messageId,
            _destinationChainSelector,
            _receiver,
            _amount,
            ccipFee
        );
    }

    function withdrawToken(
        address _beneficiary,
        address _tokenAddress
    ) public onlyOwner {
        uint256 amount = IERC20(_tokenAddress).balanceOf(address(this));
        if (amount == 0) revert CCIPTokenSender__NothingToWithdraw();
        IERC20(_tokenAddress).transfer(_beneficiary, amount);
    }
}
