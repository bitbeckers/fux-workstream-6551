// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { Setup } from "../../Setup.t.sol";
import { SimpleDistribution } from "../../../src/WERK/strategies/payouts/SimpleDistribution.sol";
import { DirectDeposit } from "../../../src/WERK/strategies/funding/DirectDeposit.sol";

import "forge-std/src/console.sol";

import { CallFailed, UnsupportedToken } from "../../../src/WERK/libraries/Errors.sol";

import { IDistribute } from "../../../src/WERK/interfaces/IDistribute.sol";
import { AcceptedToken } from "../../../src/WERK/libraries/Structs.sol";

contract SimpleDistributionTest is Setup {
    DirectDeposit public _directDeposit;
    SimpleDistribution public _simpleDistribution;

    function setUp() public {
        super.setup();

        bytes memory _initializationParams = abi.encode(workstreamAccount);

        _directDeposit = DirectDeposit(getClone(address(directDeposit)));
        _directDeposit.setUp(_initializationParams);

        _initializationParams = abi.encode(workstreamAccount, address(_directDeposit));
        _simpleDistribution = SimpleDistribution(getClone(address(simpleDistribution)));
        _simpleDistribution.setUp(_initializationParams);

        vm.deal(workstreamAccount, 10 ether);
    }

    function testCanDistribute() public {
        vm.startPrank(workstreamAccount);

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
        _amounts[0] = 1 ether;
        _amounts[1] = 1 ether;

        bytes memory _distributionData = abi.encode(_recipients, _tokens, _tokenIds, _amounts);

        AcceptedToken[] memory _acceptedTokens = new AcceptedToken[](1);
        _acceptedTokens[0] = AcceptedToken(address(0), 0);

        _directDeposit.setAcceptedTokens(_acceptedTokens, true);
        _directDeposit.deposit{ value: 3 ether }(workstreamAccount, address(0), 0, 3 ether);

        assertEq(address(_directDeposit).balance, 3 ether);

        _simpleDistribution.distribute(_distributionData);

        vm.stopPrank();

        assertEq(address(alice).balance, 1 ether);
        assertEq(address(bob).balance, 1 ether);
    }
}
