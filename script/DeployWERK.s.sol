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
        bytes32 _salt = keccak256("v0.3");

        address strategyRegistry = 0x241dDad60f6dEde983f67c496FfAdD9a1cBf3f2f;
        bytes32 fuxStakingId = 0x664b14947c4acefa12daff80395d2208043e7b616975fc8f20d23a0204cc2b25;
        bytes32 allowListId = 0x7e0bb5d32b56c645d0ec518278dbdd455ba9cb0aef4b5f5e1b948c3c8cc8bdf6;
        bytes32 peerEvaluationId = 0x90b92fef49f68b1f2508955e08ad8fcb052175afa2289b5883fc6660ce83c4f7;
        bytes32 directDepositId = 0x554cdef72cf81a028dcca12b19667df6bee27e545aa7effb7639a14449b6652a;
        bytes32 simpleDistributionId = 0x28c0b3171d84a169a6516177f2a53929989d6278df8aacb2ad15c5ed6defa847;

        // WERK implementation
        WERKImplementation werkImplementation = new WERKImplementation{ salt: _salt }();

        // WERK factory
        WERKFactory werkFactory =
            new WERKFactory{ salt: _salt }(broadcaster, address(werkImplementation), strategyRegistry);

        // WERK NFT
        WERKNFT werkNFT = new WERKNFT{ salt: _salt }(broadcaster, address(werkFactory));

        werkNFT.mintWorkstream(
            broadcaster,
            "FIRST MINT",
            fuxStakingId,
            allowListId,
            peerEvaluationId,
            directDepositId,
            simpleDistributionId
        );
    }
}
