// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.23 <0.9.0;

import { Foo } from "../src/Foo.sol";
import { FUX } from "../src/FUX/FUX.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract Deploy is BaseScript {
    function run() public broadcast {
        bytes32 salt = "12345";
        FUX fux = new FUX({ salt: salt });
    }
}
