// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { Setup } from "../../Setup.t.sol";
import { AllowListCoordination } from "../../../src/WERK/strategies/coordination/AllowListCoordination.sol";

import "forge-std/src/console.sol";

import { CallFailed } from "../../../src/WERK/libraries/Errors.sol";

contract AllowListCoordinationTest is Setup {
    AllowListCoordination public _allowListCoordination;

    function setUp() public {
        super.setup();

        bytes memory _initializationParams = abi.encode(workstreamAccount);
        _allowListCoordination = AllowListCoordination(getClone(address(allowListCoordination)));

        vm.prank(owner);
        AllowListCoordination(_allowListCoordination).setUp(_initializationParams);
    }

    function testWorkstreamAccountIsCoordinator() public {
        assertEq(_allowListCoordination.coordinators(workstreamAccount), true);
    }

    function testCanAddContributors() public {
        address[] memory _contributors = new address[](1);
        _contributors[0] = alice;

        vm.expectRevert();
        _allowListCoordination.addContributors(_contributors, "");

        // Alice
        vm.startPrank(alice);

        // Alice can't add contributors
        vm.expectRevert();
        _allowListCoordination.addContributors(_contributors, "");

        vm.stopPrank();

        // Workstream account
        vm.startPrank(workstreamAccount);

        // Workstream account can add contributors
        _allowListCoordination.addContributors(_contributors, "");

        // Alice is a contributor
        assertEq(_allowListCoordination.contributors(alice), true);

        vm.stopPrank();
    }

    function testCanRemoveContributors() public {
        address[] memory _contributors = new address[](1);
        _contributors[0] = alice;

        vm.expectRevert();
        _allowListCoordination.removeContributors(_contributors, "");

        // Alice
        vm.startPrank(alice);

        // Alice can't remove contributors
        vm.expectRevert();
        _allowListCoordination.removeContributors(_contributors, "");

        vm.stopPrank();

        // Workstream account
        vm.startPrank(workstreamAccount);

        // Workstream account can remove contributors
        _allowListCoordination.removeContributors(_contributors, "");

        // Alice is not a contributor
        assertEq(_allowListCoordination.contributors(alice), false);

        vm.stopPrank();
    }

    function testCanAddCoordinators() public {
        address[] memory _coordinators = new address[](1);
        _coordinators[0] = alice;

        vm.expectRevert();
        _allowListCoordination.addCoordinators(_coordinators, "");

        // Alice
        vm.startPrank(alice);

        // Alice can't add coordinators
        vm.expectRevert();
        _allowListCoordination.addCoordinators(_coordinators, "");

        vm.stopPrank();

        // Workstream account
        vm.startPrank(workstreamAccount);

        // Workstream account can add coordinators
        _allowListCoordination.addCoordinators(_coordinators, "");

        // Alice is a coordinator
        assertEq(_allowListCoordination.coordinators(alice), true);

        vm.stopPrank();
    }

    function testCanRemoveCoordinators() public {
        address[] memory _coordinators = new address[](1);
        _coordinators[0] = alice;

        vm.expectRevert();
        _allowListCoordination.removeCoordinators(_coordinators, "");

        // Alice
        vm.startPrank(alice);

        // Alice can't remove coordinators
        vm.expectRevert();
        _allowListCoordination.removeCoordinators(_coordinators, "");

        vm.stopPrank();

        // Workstream account
        vm.startPrank(workstreamAccount);

        // Workstream account can remove coordinators
        _allowListCoordination.removeCoordinators(_coordinators, "");

        // Alice is not a coordinator
        assertEq(_allowListCoordination.coordinators(alice), false);

        vm.stopPrank();
    }
}
