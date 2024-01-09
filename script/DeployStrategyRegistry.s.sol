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
contract DeployStrategyRegistry is BaseScript {
    function run() public broadcast {
        bytes32 _salt = keccak256("v0.3");

        // Strategies
        FUXStaking fuxStaking = new FUXStaking{ salt: _salt }();
        AllowListCoordination allowListCoordination = new AllowListCoordination{ salt: _salt }();
        SimplePeerEvaluation simplePeerEvaluation = new SimplePeerEvaluation{ salt: _salt }();
        DirectDeposit directDeposit = new DirectDeposit{ salt: _salt }();

        // Strategy Registry
        StrategyRegistry strategyRegistry = new StrategyRegistry{ salt: _salt }(broadcaster);

        // Strategy Registry: Create Strategies
        bytes32 fuxStakingId =
            strategyRegistry.createStrategy(IStrategyRegistry.StrategyTypes.Commit, address(fuxStaking), true);

        bytes32 allowListId = strategyRegistry.createStrategy(
            IStrategyRegistry.StrategyTypes.Coordinate, address(allowListCoordination), true
        );

        bytes32 peerEvaluationId = strategyRegistry.createStrategy(
            IStrategyRegistry.StrategyTypes.Evaluate, address(simplePeerEvaluation), true
        );

        bytes32 directDepositId =
            strategyRegistry.createStrategy(IStrategyRegistry.StrategyTypes.Fund, address(directDeposit), true);
    }
}