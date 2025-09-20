// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

contract LogEmitter {
    event Log(address indexed msgSender);

    function emitLog() public {
        emit Log(msg.sender);
    }
}
