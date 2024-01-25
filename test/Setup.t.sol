// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { PRBTest } from "@prb/test/src/PRBTest.sol";
import { StdCheats } from "forge-std/src/StdCheats.sol";

import { FUX } from "../src/FUX/FUX.sol";
import { FUXStaking } from "../src/WERK/strategies/commitment/FUXStaking.sol";
import { AllowListCoordination } from "../src/WERK/strategies/coordination/AllowListCoordination.sol";
import { SimplePeerEvaluation } from "../src/WERK/strategies/evaluate/SimplePeerEvaluation.sol";
import { DirectDeposit } from "../src/WERK/strategies/funding/DirectDeposit.sol";
import { SimpleDistribution } from "../src/WERK/strategies/payouts/SimpleDistribution.sol";

import { StrategyRegistry } from "../src/WERK/StrategyRegistry.sol";
import { WERKImplementation } from "../src/WERK/WERKImplementation.sol";

import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";

contract Setup is PRBTest, StdCheats {
    address public workstreamAccount = makeAddr("workstreamAccount");
    address public owner = makeAddr("owner");
    address public alice = makeAddr("alice");
    address public bob = makeAddr("bob");
    FUX public fux;

    WERKImplementation public werkImplementation;

    FUXStaking public fuxStaking;
    AllowListCoordination public allowListCoordination;
    SimplePeerEvaluation public simplePeerEvaluation;
    DirectDeposit public directDeposit;
    SimpleDistribution public simpleDistribution;

    StrategyRegistry public strategyRegistry;

    // solhint-disable-next-line no-empty-blocks
    constructor() { }

    function setup() internal virtual {
        fux = new FUX(owner);
        fuxStaking = new FUXStaking(address(fux));
        strategyRegistry = new StrategyRegistry(owner);

        allowListCoordination = new AllowListCoordination();
        simplePeerEvaluation = new SimplePeerEvaluation();
        directDeposit = new DirectDeposit();
        simpleDistribution = new SimpleDistribution();
        werkImplementation = new WERKImplementation();
    }

    function getClone(address implementation) internal returns (address clone) {
        clone = Clones.clone(implementation);
    }
}
