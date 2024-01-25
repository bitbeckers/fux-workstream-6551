// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { Setup } from "../../Setup.t.sol";
import { SimplePeerEvaluation } from "../../../src/WERK/strategies/evaluate/SimplePeerEvaluation.sol";

import "forge-std/src/console.sol";

import { CallFailed } from "../../../src/WERK/libraries/Errors.sol";

import { IEvaluate } from "../../../src/WERK/interfaces/IEvaluate.sol";

contract SimplePeerEvaluationTest is Setup {
    address public evaluator = makeAddr("evaluator");

    SimplePeerEvaluation public _simplePeerEvaluation;

    function setUp() public {
        super.setup();

        bytes memory _initializationParams = abi.encode(workstreamAccount);
        _simplePeerEvaluation = SimplePeerEvaluation(getClone(address(simplePeerEvaluation)));

        SimplePeerEvaluation(_simplePeerEvaluation).setUp(_initializationParams);
    }

    function testCanSubmitPeerEvaluation() public {
        address[] memory _contributors = new address[](2);
        _contributors[0] = alice;
        _contributors[1] = bob;

        uint256[] memory _ratings = new uint256[](2);
        _ratings[0] = 70;
        _ratings[1] = 30;

        bytes memory _evaluationData = abi.encode(_contributors, _ratings);

        vm.startPrank(evaluator);
        vm.expectEmit();

        emit IEvaluate.EvaluationSubmitted(evaluator, _evaluationData);
        _simplePeerEvaluation.submit(_evaluationData);

        vm.stopPrank();
    }

    function testCannotSelfEvaluate() public {
        address[] memory _contributors = new address[](2);
        _contributors[0] = alice;
        _contributors[1] = bob;

        uint256[] memory _ratings = new uint256[](2);
        _ratings[0] = 70;
        _ratings[1] = 30;

        bytes memory _evaluationData = abi.encode(_contributors, _ratings);

        vm.startPrank(alice);
        vm.expectRevert();

        _simplePeerEvaluation.submit(_evaluationData);

        vm.stopPrank();
    }

    function testRatingsNeedsToBe100() public {
        address[] memory _contributors = new address[](2);
        _contributors[0] = alice;
        _contributors[1] = bob;

        uint256[] memory _ratings = new uint256[](2);
        _ratings[0] = 70;
        _ratings[1] = 40;

        bytes memory _evaluationData = abi.encode(_contributors, _ratings);

        vm.startPrank(evaluator);
        vm.expectRevert();

        _simplePeerEvaluation.submit(_evaluationData);

        vm.stopPrank();
    }

    function testEvaluationStatus() public {
        assertEq(uint8(_simplePeerEvaluation.getEvaluationStatus()), uint8(IEvaluate.EvaluationStatus.CLOSED));

        vm.startPrank(workstreamAccount);
        vm.expectEmit();

        emit IEvaluate.EvaluationStatusUpdated(IEvaluate.EvaluationStatus.OPEN);
        _simplePeerEvaluation.updateEvaluationStatus(IEvaluate.EvaluationStatus.OPEN);

        vm.stopPrank();

        assertEq(uint8(_simplePeerEvaluation.getEvaluationStatus()), uint8(IEvaluate.EvaluationStatus.OPEN));
    }
}
