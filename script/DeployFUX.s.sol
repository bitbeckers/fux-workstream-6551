// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.23 <0.9.0;

import { FUX } from "../src/FUX/FUX.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract DeployFUX is BaseScript {
    function run() public broadcast {
        bytes32 _salt = keccak256("v0.2");
        new FUX{ salt: _salt }(broadcaster);
    }
}
