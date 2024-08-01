// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { MockExecutable } from "./MockExecutable.sol";

contract MockExecutableCall is MockExecutable {
    function execute(
        address to,
        uint256 value,
        bytes calldata data,
        uint8 operation
    )
        external
        payable
        virtual
        override
        returns (bytes memory)
    {
        (to, value, data, operation);
        if (operation != 0) revert MockExecutableError();

        (bool success,) = to.call{ value: value }(data);

        if (!success) revert("MockExecutableCall: call failed");
        return "";
    }
}
