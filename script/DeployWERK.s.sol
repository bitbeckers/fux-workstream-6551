// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.8.23 <0.9.0;

import { FUXStaking } from "../src/WERK/strategies/commitment/FUXStaking.sol";
import { AllowListCoordination } from "../src/WERK/strategies/coordination/AllowListCoordination.sol";
import { SimplePeerEvaluation } from "../src/WERK/strategies/evaluate/SimplePeerEvaluation.sol";
import { DirectDeposit } from "../src/WERK/strategies/funding/DirectDeposit.sol";

import { WERKImplementation } from "../src/WERK/WERKImplementation.sol";
import { WERKFactory } from "../src/WERK/WERKFactory.sol";
import { WERKNFT } from "../src/WERK/WERKNFT.sol";

import { StrategyRegistry } from "../src/WERK/StrategyRegistry.sol";
import { IStrategyRegistry } from "../src/WERK/interfaces/IStrategyRegistry.sol";

import { BaseScript } from "./Base.s.sol";

/// @dev See the Solidity Scripting tutorial: https://book.getfoundry.sh/tutorials/solidity-scripting
contract DeployWERK is BaseScript {
    function run() public broadcast {
        bytes32 _salt = keccak256("v0.7");

        address strategyRegistry = 0xfbe4f1fbaA08d68B677e3928C05F50d0450A0B4a;

        // WERK implementation
        WERKImplementation werkImplementation = new WERKImplementation{ salt: _salt }();

        // WERK factory
        WERKFactory werkFactory =
            new WERKFactory{ salt: _salt }(broadcaster, address(werkImplementation), strategyRegistry);

        // WERK NFT
        new WERKNFT{ salt: _salt }(broadcaster, address(werkFactory));
    }
}
