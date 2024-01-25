// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { Setup } from "../../Setup.t.sol";
import { DirectDeposit } from "../../../src/WERK/strategies/funding/DirectDeposit.sol";

import "forge-std/src/console.sol";

import { CallFailed, UnsupportedToken } from "../../../src/WERK/libraries/Errors.sol";

import { IFund } from "../../../src/WERK/interfaces/IFund.sol";
import { AcceptedToken } from "../../../src/WERK/libraries/Structs.sol";

contract DirectDepositTest is Setup {
    DirectDeposit public _directDeposit;

    function setUp() public {
        super.setup();

        bytes memory _initializationParams = abi.encode(workstreamAccount);
        _directDeposit = DirectDeposit(getClone(address(directDeposit)));
        _directDeposit.setUp(_initializationParams);

        vm.deal(workstreamAccount, 10 ether);
    }

    function testCanUpdateAcceptedTokens() public {
        AcceptedToken[] memory _acceptedTokens = new AcceptedToken[](1);
        _acceptedTokens[0] = AcceptedToken(address(0), 0);

        vm.prank(workstreamAccount);
        _directDeposit.setAcceptedTokens(_acceptedTokens, true);

        assertTrue(_directDeposit.acceptedTokens(address(0), 0));

        vm.prank(workstreamAccount);
        _directDeposit.setAcceptedTokens(_acceptedTokens, false);

        assertFalse(_directDeposit.acceptedTokens(address(0), 0));
    }

    function testCanDeposit() public {
        address _user = alice;
        address _tokenAddress = address(0);
        uint256 _tokenId = 0;
        uint256 _tokenAmount = 1 ether;

        uint256 _startBalance = address(workstreamAccount).balance;

        vm.deal(_user, _tokenAmount);

        assertFalse(_directDeposit.acceptedTokens(_tokenAddress, _tokenId));

        AcceptedToken[] memory _acceptedTokens = new AcceptedToken[](1);
        _acceptedTokens[0] = AcceptedToken(_tokenAddress, _tokenId);

        // Can't deposit unsupported token
        vm.expectRevert(UnsupportedToken.selector);
        _directDeposit.deposit{ value: _tokenAmount }(_user, _tokenAddress, _tokenId, _tokenAmount);

        // Only admin can update accepted tokens
        vm.expectRevert();
        _directDeposit.setAcceptedTokens(_acceptedTokens, true);

        vm.prank(workstreamAccount);
        _directDeposit.setAcceptedTokens(_acceptedTokens, true);

        // Can't deposit without sending value
        vm.expectRevert();
        _directDeposit.deposit(_user, _tokenAddress, _tokenId, _tokenAmount);

        vm.prank(_user);
        _directDeposit.deposit{ value: _tokenAmount }(_user, _tokenAddress, _tokenId, _tokenAmount);

        assertEq(address(workstreamAccount).balance, _startBalance + _tokenAmount);
    }

    function testCanWithdraw() public {
        address _user = workstreamAccount;
        address _tokenAddress = address(0);
        uint256 _tokenId = 0;
        uint256 _tokenAmount = 1 ether;

        assertFalse(_directDeposit.acceptedTokens(_tokenAddress, _tokenId));

        AcceptedToken[] memory _acceptedTokens = new AcceptedToken[](1);
        _acceptedTokens[0] = AcceptedToken(_tokenAddress, _tokenId);

        // Set accepted tokens
        vm.startPrank(workstreamAccount);
        _directDeposit.setAcceptedTokens(_acceptedTokens, true);

        _directDeposit.deposit{ value: _tokenAmount }(_user, _tokenAddress, _tokenId, _tokenAmount);

        vm.stopPrank();

        assertEq(address(workstreamAccount).balance, _tokenAmount);

        // Only owner can withdraw
        vm.prank(alice);
        vm.expectRevert();
        _directDeposit.withdraw(alice, _tokenAddress, _tokenId, _tokenAmount);

        vm.prank(workstreamAccount);
        _directDeposit.withdraw(_user, _tokenAddress, _tokenId, _tokenAmount);

        assertEq(address(workstreamAccount).balance, 0);
    }
}
