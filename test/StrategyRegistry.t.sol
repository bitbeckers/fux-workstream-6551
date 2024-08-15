// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { Setup } from "./Setup.t.sol";
import { StrategyRegistry } from "../src/WERK/StrategyRegistry.sol";

import { IStrategyRegistry } from "../src/WERK/interfaces/IStrategyRegistry.sol";

import { StrategyTypes } from "../src/WERK/libraries/Enums.sol";

contract StrategyRegistryTest is Setup {
    function setUp() public {
        super.setup();
    }

    function testCanCreateStrategy() public {
        StrategyTypes strategyType = StrategyTypes.Commit;
        address implementation = address(fuxStaking);
        bool isActive = true;

        vm.expectRevert();
        strategyRegistry.createStrategy(strategyType, implementation, isActive);

        vm.prank(owner);
        bytes32 strategyId = strategyRegistry.createStrategy(strategyType, implementation, isActive);

        StrategyRegistry.StrategyInfo memory strategyInfo = strategyRegistry.getStrategy(strategyId);

        assertEq(uint8(strategyInfo.strategyType), uint8(strategyType));
        assertEq(strategyInfo.implementation, implementation);
        assertEq(strategyInfo.isActive, isActive);
        assertEq(strategyInfo.strategyId, strategyId);
    }

    function testCanUpdateStrategy() public {
        StrategyTypes strategyType = StrategyTypes.Commit;
        address implementation = address(fuxStaking);
        bool isActive = true;

        vm.prank(owner);
        bytes32 strategyId = strategyRegistry.createStrategy(strategyType, implementation, isActive);

        StrategyRegistry.StrategyInfo memory strategyInfo = strategyRegistry.getStrategy(strategyId);

        assertEq(strategyInfo.isActive, isActive);

        vm.expectRevert();
        strategyRegistry.updateStrategy(strategyId, false);

        vm.prank(owner);
        strategyRegistry.updateStrategy(strategyId, false);

        strategyInfo = strategyRegistry.getStrategy(strategyId);

        assertEq(strategyInfo.isActive, false);
    }
}
