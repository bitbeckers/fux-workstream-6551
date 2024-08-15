// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IERC6551Executable } from "../../src/WERK/interfaces/IERC6551Executable.sol";

contract MockExecutable is IERC6551Executable {
    event Received();
    event Fallback();

    error MockExecutableError();

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
        return "";
    }

    /**
     * @notice Called whenever this account received Ether
     *
     * @dev Can be overriden via Overridable
     */
    receive() external payable {
        emit Received();
    }

    /**
     * @notice Called whenever the calldata function selector does not match a defined function
     *
     * @dev Can be overriden via Overridable
     */
    fallback() external payable {
        emit Fallback();
    }
}
