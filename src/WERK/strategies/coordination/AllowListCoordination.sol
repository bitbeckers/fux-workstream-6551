// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { ICoordinate } from "../../interfaces/ICoordinate.sol";

import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract AllowListCoordination is ICoordinate, OwnableUpgradeable {
    mapping(address user => bool isCoordinator) public coordinators;
    mapping(address user => bool isContributor) public contributors;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function setUp(bytes memory _initializationParams) public virtual initializer {
        (address _workstreamAccount) = abi.decode(_initializationParams, (address));

        coordinators[_workstreamAccount] = true;
        __Ownable_init(_workstreamAccount);
    }

    function addContributors(address[] memory _contributors, bytes memory data) external override onlyCoordinator {
        for (uint256 i = 0; i < _contributors.length; i++) {
            contributors[_contributors[i]] = true;
        }
        emit ContributorsAdded(_contributors, data);
    }

    function removeContributors(address[] memory _contributors, bytes memory data) external override onlyCoordinator {
        for (uint256 i = 0; i < _contributors.length; i++) {
            contributors[_contributors[i]] = false;
        }
        emit ContributorsRemoved(_contributors, data);
    }

    function addCoordinators(address[] memory _coordinators, bytes memory data) external override onlyCoordinator {
        for (uint256 i = 0; i < _coordinators.length; i++) {
            coordinators[_coordinators[i]] = true;
        }
        emit CoordinatorsAdded(_coordinators, data);
    }

    function removeCoordinators(address[] memory _coordinators, bytes memory data) external override onlyCoordinator {
        for (uint256 i = 0; i < _coordinators.length; i++) {
            coordinators[_coordinators[i]] = false;
        }
        emit CoordinatorsRemoved(_coordinators, data);
    }

    function isContributor(address _contributor) external view override returns (bool) {
        return contributors[_contributor];
    }

    function isCoordinator(address _coordinator) external view override returns (bool) {
        return coordinators[_coordinator];
    }

    modifier onlyCoordinator() {
        if (!coordinators[msg.sender]) revert NotAllowedOrApproved();
        _;
    }
}
