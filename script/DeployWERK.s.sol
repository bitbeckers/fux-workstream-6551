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
        bytes32 _salt = keccak256("v0.1");

        address strategyRegistry = 0x77e247f195B8f6AC09a539a5C7BbA3d2F2Fb7A69;
        bytes32 fuxStakingId = 0x0d09c51f0ac855a550097f2abe1c934de3df38af069520dda15896da57f6a020;
        bytes32 allowListId = 0x9c0e67f07f162fb2133457cbca5e25019fbfb5cbfaf73be587a144142f3903cc;
        bytes32 peerEvaluationId = 0x2ee31ef770153b087502dc18352b1ac2decbf47b92cc6dbdd4c3c20b4acff0bb;
        bytes32 directDepositId = 0x4dbbc26cc497c0ec31a0629e36db0c955c7c956cc206114c2f09f02dbb9846ca;

        // WERK implementation
        WERKImplementation werkImplementation = new WERKImplementation{ salt: _salt }();

        // WERK factory
        WERKFactory werkFactory = new WERKFactory{ salt: _salt }(broadcaster);
        werkFactory.setImplementation(address(werkImplementation));
        werkFactory.setStrategyRegistry(strategyRegistry);

        // WERK NFT
        WERKNFT werkNFT = new WERKNFT{ salt: _salt }(broadcaster, address(werkFactory));

        werkNFT.mintWorkstream(broadcaster, "FIRST MINT", fuxStakingId, allowListId, peerEvaluationId, directDepositId);
    }
}
