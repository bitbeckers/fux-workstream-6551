// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { ICoordinate } from "../../interfaces/ICoordinate.sol";

import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import { NotApprovedOrOwner } from "../../libraries/Errors.sol";

import { StrategyTypes } from "../../libraries/Enums.sol";

contract AllowListCoordination is ICoordinate, OwnableUpgradeable {
    mapping(address user => bool isCoordinator) public coordinators;
    mapping(address user => bool isContributor) public contributors;

    event ContributorsAdded(address[] contributors, bytes data);
    event ContributorsRemoved(address[] contributors, bytes data);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function setUp(bytes memory _initializationParams) public virtual initializer {
        (address _owner) = abi.decode(_initializationParams, (address));

        coordinators[_owner] = true;
        __Ownable_init(_owner);
    }

    function addContributors(address[] memory _contributors, bytes memory data) external onlyCoordinatorOrOwner {
        for (uint256 i = 0; i < _contributors.length; i++) {
            contributors[_contributors[i]] = true;
        }
        emit ContributorsAdded(_contributors, data);
    }

    function removeContributors(address[] memory _contributors, bytes memory data) external onlyCoordinatorOrOwner {
        for (uint256 i = 0; i < _contributors.length; i++) {
            contributors[_contributors[i]] = false;
        }
        emit ContributorsRemoved(_contributors, data);
    }

    function addCoordinators(
        address[] memory _coordinators,
        bytes memory data
    )
        external
        override
        onlyCoordinatorOrOwner
    {
        for (uint256 i = 0; i < _coordinators.length; i++) {
            coordinators[_coordinators[i]] = true;
        }
        emit CoordinatorsAdded(_coordinators, data);
    }

    function removeCoordinators(
        address[] memory _coordinators,
        bytes memory data
    )
        external
        override
        onlyCoordinatorOrOwner
    {
        for (uint256 i = 0; i < _coordinators.length; i++) {
            coordinators[_coordinators[i]] = false;
        }
        emit CoordinatorsRemoved(_coordinators, data);
    }

    function isContributor(address _contributor) external view returns (bool) {
        return contributors[_contributor];
    }

    function isCoordinator(address _coordinator) external view returns (bool) {
        return coordinators[_coordinator];
    }

    function getStrategyType() external pure returns (StrategyTypes) {
        return StrategyTypes.Commit;
    }

    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return interfaceId == type(ICoordinate).interfaceId;
    }

    modifier onlyCoordinatorOrOwner() {
        if (!coordinators[msg.sender] && owner() != msg.sender) revert NotApprovedOrOwner();
        _;
    }
}
