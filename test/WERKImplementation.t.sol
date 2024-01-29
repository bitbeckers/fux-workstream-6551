// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { Setup } from "./Setup.t.sol";
import { StrategyRegistry } from "../src/WERK/StrategyRegistry.sol";

import { IStrategyRegistry } from "../src/WERK/interfaces/IStrategyRegistry.sol";
import { ICommit } from "../src/WERK/interfaces/ICommit.sol";
import { ICoordinate } from "../src/WERK/interfaces/ICoordinate.sol";
import { IEvaluate } from "../src/WERK/interfaces/IEvaluate.sol";
import { IFund } from "../src/WERK/interfaces/IFund.sol";
import { IDistribute } from "../src/WERK/interfaces/IDistribute.sol";
import { WERKImplementation } from "../src/WERK/WERKImplementation.sol";
import { IWERK } from "../src/WERK/interfaces/IWERK.sol";

import { SimplePeerEvaluation } from "../src/WERK/strategies/evaluate/SimplePeerEvaluation.sol";
import { AllowListCoordination } from "../src/WERK/strategies/coordination/AllowListCoordination.sol";

contract WERKImplementationTest is Setup {
    WERKImplementation public _werkImplementation;

    ICommit public _commitmentStrategy;
    ICoordinate public _coordinationStrategy;
    IEvaluate public _evaluationStrategy;
    IFund public _fundingStrategy;
    IDistribute public _payoutStrategy;

    function setUp() public {
        super.setup();
        address treasury = makeAddr("treasury");

        _werkImplementation = WERKImplementation(getClone(address(werkImplementation)));

        bytes memory _initializationParams = abi.encode(address(_werkImplementation));
        _commitmentStrategy = ICommit(getClone(address(fuxStaking)));
        _commitmentStrategy.setUp(_initializationParams);

        _coordinationStrategy = ICoordinate(getClone(address(allowListCoordination)));
        _coordinationStrategy.setUp(_initializationParams);

        _evaluationStrategy = IEvaluate(getClone(address(simplePeerEvaluation)));
        _evaluationStrategy.setUp(_initializationParams);

        _initializationParams = abi.encode(address(_werkImplementation), treasury);

        _fundingStrategy = IFund(getClone(address(directDeposit)));
        _fundingStrategy.setUp(_initializationParams);

        _payoutStrategy = IDistribute(getClone(address(simpleDistribution)));
        _payoutStrategy.setUp(_initializationParams);
    }

    function testCanInitializeWithStrategies() public {
        bytes memory _initializationParams = abi.encode(
            owner,
            address(_commitmentStrategy),
            address(_coordinationStrategy),
            address(_evaluationStrategy),
            address(_fundingStrategy),
            address(_payoutStrategy)
        );

        _werkImplementation.setUp(_initializationParams);

        assertEq(_werkImplementation.owner(), owner);

        vm.prank(owner);
        vm.expectRevert();
        _werkImplementation.setUp(_initializationParams);

        IWERK.WerkInfo memory werkInfo = _werkImplementation.getWerkInfo();

        assertEq(werkInfo.commitmentStrategy, address(_commitmentStrategy));
        assertEq(werkInfo.coordinationStrategy, address(_coordinationStrategy));
        assertEq(werkInfo.evaluationStrategy, address(_evaluationStrategy));
        assertEq(werkInfo.fundingStrategy, address(_fundingStrategy));
        assertEq(werkInfo.payoutStrategy, address(_payoutStrategy));
    }

    function testCanInitializeWithPartialStrategies() public {
        bytes memory _initializationParams = abi.encode(
            owner,
            address(_commitmentStrategy),
            address(0),
            address(_evaluationStrategy),
            address(_fundingStrategy),
            address(_payoutStrategy)
        );

        _werkImplementation.setUp(_initializationParams);

        assertEq(_werkImplementation.owner(), owner);

        vm.prank(owner);
        vm.expectRevert();
        _werkImplementation.setUp(_initializationParams);

        IWERK.WerkInfo memory werkInfo = _werkImplementation.getWerkInfo();

        assertEq(werkInfo.commitmentStrategy, address(_commitmentStrategy));
        assertEq(werkInfo.coordinationStrategy, address(0));
        assertEq(werkInfo.evaluationStrategy, address(_evaluationStrategy));
        assertEq(werkInfo.fundingStrategy, address(_fundingStrategy));
        assertEq(werkInfo.payoutStrategy, address(_payoutStrategy));
    }

    function testCannotExecuteOnInactiveWorkstream() public {
        initWorkstream();

        vm.startPrank(owner);
        vm.expectRevert(IWERK.WorkstreamNotActive.selector);
        _werkImplementation.coordinate("");

        vm.expectRevert(IWERK.WorkstreamNotActive.selector);
        _werkImplementation.commit("");

        vm.expectRevert(IWERK.WorkstreamNotActive.selector);
        _werkImplementation.evaluate("");

        vm.expectRevert(IWERK.WorkstreamNotActive.selector);
        _werkImplementation.fund("");

        vm.expectRevert(IWERK.WorkstreamNotActive.selector);
        _werkImplementation.distribute("");

        vm.stopPrank();
    }

    function testCanExecuteOwnerCoordinateCall() public {
        initActiveWorkstream();

        assertEq(_werkImplementation.owner(), owner);
        address[] memory _coordinators = new address[](2);
        _coordinators[0] = alice;
        _coordinators[1] = bob;

        bytes memory callData =
            abi.encodeWithSelector(AllowListCoordination.addCoordinators.selector, _coordinators, true);

        vm.prank(anon);
        vm.expectRevert();
        _werkImplementation.coordinate(callData);

        vm.expectEmit();

        // event CoordinatorsAdded(address[] coordinators, bytes data);
        emit ICoordinate.CoordinatorsAdded(_coordinators, "");
        vm.prank(owner);
        _werkImplementation.coordinate(callData);
    }

    function initWorkstream() internal {
        bytes memory _initializationParams = abi.encode(
            owner,
            address(_commitmentStrategy),
            address(_coordinationStrategy),
            address(_evaluationStrategy),
            address(_fundingStrategy),
            address(_payoutStrategy)
        );

        _werkImplementation.setUp(_initializationParams);
    }

    function initActiveWorkstream() internal {
        initWorkstream();

        vm.prank(owner);
        _werkImplementation.updateWorkstreamStatus(IWERK.WorkstreamStatus.Active);
    }
}
