// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { Setup } from "../../Setup.t.sol";
import { SimpleDistribution } from "../../../src/WERK/strategies/payouts/SimpleDistribution.sol";
import { DirectDeposit } from "../../../src/WERK/strategies/funding/DirectDeposit.sol";

import "forge-std/src/console.sol";

import { CallFailed, UnsupportedToken } from "../../../src/WERK/libraries/Errors.sol";

import { IDistribute } from "../../../src/WERK/interfaces/IDistribute.sol";
import { AcceptedToken } from "../../../src/WERK/libraries/Structs.sol";
import { TokenType } from "../../../src/WERK/libraries/Enums.sol";

import { MockExecutableCall } from "../../mocks/MockExecutableCall.sol";

contract SimpleDistributionTest is Setup {
    DirectDeposit public _directDeposit;
    SimpleDistribution public _simpleDistribution;

    MockExecutableCall public _mockExecutableCall;

    function setUp() public {
        super.setup();

        _mockExecutableCall = new MockExecutableCall();

        bytes memory _initializationParams = abi.encode(owner, address(_mockExecutableCall));

        _simpleDistribution = SimpleDistribution(getClone(address(simpleDistribution)));
        vm.prank(owner);
        _simpleDistribution.setUp(_initializationParams);

        vm.deal(owner, 10 ether);
    }

    function testCanDistribute() public {
        assertEq(address(_mockExecutableCall).balance, 0 ether);

        vm.deal(address(_mockExecutableCall), 10 ether);

        assertEq(address(alice).balance, 0 ether);
        assertEq(address(bob).balance, 0 ether);

        address[] memory _recipients = new address[](2);
        _recipients[0] = alice;
        _recipients[1] = bob;

        address[] memory _tokens = new address[](2);
        _tokens[0] = address(0);
        _tokens[1] = address(0);

        uint256[] memory _tokenIds = new uint256[](2);
        _tokenIds[0] = 0;
        _tokenIds[1] = 0;

        uint256[] memory _amounts = new uint256[](2);
        _amounts[0] = 7 ether;
        _amounts[1] = 3 ether;

        bytes memory _distributionData = abi.encode(_recipients, _tokens, _tokenIds, _amounts);

        AcceptedToken[] memory _acceptedTokens = new AcceptedToken[](1);
        _acceptedTokens[0] = AcceptedToken(TokenType.NATIVE, address(0), 0);

        vm.prank(owner);
        _simpleDistribution.distribute(_distributionData);

        assertEq(address(alice).balance, 7 ether);
        assertEq(address(bob).balance, 3 ether);
    }
}
