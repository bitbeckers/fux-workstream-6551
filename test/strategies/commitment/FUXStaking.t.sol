// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { Setup } from "../../Setup.t.sol";
import { FUXStaking } from "../../../src/WERK/strategies/commitment/FUXStaking.sol";

import "forge-std/src/console.sol";

import { CallFailed } from "../../../src/WERK/libraries/Errors.sol";

import { ICommit } from "../../../src/WERK/interfaces/ICommit.sol";

contract FuxStakingTest is Setup {
    FUXStaking public _fuxStaking;

    function setUp() public {
        super.setup();

        bytes memory _initializationParams = abi.encode(workstreamAccount);
        _fuxStaking = FUXStaking(getClone(address(fuxStaking)));

        FUXStaking(_fuxStaking).setUp(_initializationParams);
    }

    function testCanGiveFux() public {
        vm.expectRevert();
        _fuxStaking.giveFUX(alice, address(_fuxStaking), 100);

        // Alice
        vm.startPrank(alice);

        // Alice can't stake without FUX
        vm.expectRevert();
        _fuxStaking.giveFUX(alice, address(_fuxStaking), 100);

        fux.mint(alice, alice);

        // Alice can't stake without allowing the workstream to take FUX
        vm.expectRevert();
        _fuxStaking.giveFUX(alice, address(_fuxStaking), 50);

        // Alice can stake FUX
        fux.setApprovalForAll(address(_fuxStaking), true);
        _fuxStaking.giveFUX(alice, address(_fuxStaking), 50);

        // Alice can't stake for Bob
        vm.expectRevert();
        _fuxStaking.giveFUX(bob, address(_fuxStaking), 100);

        vm.stopPrank();

        // Bob
        vm.startPrank(bob);
        // Bob can't stake for Alice
        vm.expectRevert();
        _fuxStaking.giveFUX(alice, address(_fuxStaking), 100);

        vm.stopPrank();

        assertEq(fux.balanceOf(alice, fux.FUX_TOKEN_ID()), 50);
        assertEq(fux.balanceOf(bob, fux.FUX_TOKEN_ID()), 0);
        assertEq(_fuxStaking.fuxStaked(alice), 50);
        assertEq(_fuxStaking.fuxStaked(bob), 0);
    }

    function testCanTakeFux() public {
        vm.expectRevert();
        _fuxStaking.takeFUX(alice, address(_fuxStaking), 100);

        // Alice
        vm.startPrank(alice);

        fux.mint(alice, alice);

        // Alice can't stake FUX without staking
        assertEq(_fuxStaking.fuxStaked(alice), 0);

        vm.expectRevert();
        _fuxStaking.takeFUX(alice, address(_fuxStaking), 50);

        // Alice deposits FUX
        fux.setApprovalForAll(address(_fuxStaking), true);
        _fuxStaking.giveFUX(alice, address(_fuxStaking), 100);

        assertEq(_fuxStaking.fuxStaked(alice), 100);

        // Alice withdraws half her FUX
        _fuxStaking.takeFUX(alice, address(_fuxStaking), 50);

        assertEq(_fuxStaking.fuxStaked(alice), 50);

        vm.stopPrank();

        assertEq(fux.balanceOf(alice, fux.FUX_TOKEN_ID()), 50);
        assertEq(_fuxStaking.fuxStaked(alice), 50);
    }

    function testCanCommit() public {
        // Alice
        vm.startPrank(alice);

        fux.mint(alice, alice);

        // Alice can commit FUX
        fux.setApprovalForAll(address(_fuxStaking), true);
        _fuxStaking.commit(alice, address(_fuxStaking), fux.FUX_TOKEN_ID(), 50);

        vm.stopPrank();

        assertEq(fux.balanceOf(alice, fux.FUX_TOKEN_ID()), 50);
        assertEq(_fuxStaking.fuxStaked(alice), 50);
    }

    function testCanRevoke() public {
        // Alice
        vm.startPrank(alice);

        fux.mint(alice, alice);

        // Alice can commit FUX
        fux.setApprovalForAll(address(_fuxStaking), true);

        vm.expectEmit();

        // We emit the event we expect to see.
        emit ICommit.UserCommitted(address(_fuxStaking), alice, address(fux), fux.FUX_TOKEN_ID(), 50);
        _fuxStaking.commit(alice, address(_fuxStaking), fux.FUX_TOKEN_ID(), 50);

        // Alice can revoke FUX
        emit ICommit.UserWithdrawn(address(_fuxStaking), alice, address(fux), fux.FUX_TOKEN_ID(), 50);
        _fuxStaking.revoke(alice, address(_fuxStaking), fux.FUX_TOKEN_ID(), 50);

        vm.stopPrank();

        assertEq(fux.balanceOf(alice, fux.FUX_TOKEN_ID()), 100);
        assertEq(_fuxStaking.fuxStaked(alice), 0);
    }
}
