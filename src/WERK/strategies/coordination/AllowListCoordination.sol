// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { ICoordinate } from "../../interfaces/ICoordinate.sol";

import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import { NotApprovedOrOwner } from "../../libraries/Errors.sol";

import { StrategyTypes } from "../../libraries/Enums.sol";

import { IWERKStrategy } from "../../interfaces/IWERKStrategy.sol";
import { IERC165 } from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

contract AllowListCoordination is ICoordinate, OwnableUpgradeable {
    mapping(address user => bool isCoordinator) public coordinators;
    mapping(address user => bool isContributor) public contributors;

    event ContributorsAdded(address[] contributors, bytes data);
    event ContributorsRemoved(address[] contributors, bytes data);

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /// @inheritdoc IWERKStrategy
    function setUp(bytes memory _initializationParams) public virtual initializer {
        (address _owner) = abi.decode(_initializationParams, (address));

        coordinators[_owner] = true;
        __Ownable_init(_owner);
    }

    /// @notice Adds contributors to the allow list. This method is specific to the AllowListCoordination strategy
    /// @dev Can only be called by the contract owner or a coordinator.
    /// @param _contributors The addresses of the contributors to add.
    /// @param data The data to include in the event.
    function addContributors(address[] memory _contributors, bytes memory data) external onlyCoordinatorOrOwner {
        for (uint256 i = 0; i < _contributors.length; i++) {
            contributors[_contributors[i]] = true;
        }
        emit ContributorsAdded(_contributors, data);
    }

    /// @notice Removes contributors from the allow list. This method is specific to the AllowListCoordination strategy
    /// @dev Can only be called by the contract owner or a coordinator.
    /// @param _contributors The addresses of the contributors to remove.
    /// @param data The data to include in the event.
    function removeContributors(address[] memory _contributors, bytes memory data) external onlyCoordinatorOrOwner {
        for (uint256 i = 0; i < _contributors.length; i++) {
            contributors[_contributors[i]] = false;
        }
        emit ContributorsRemoved(_contributors, data);
    }

    /// @inheritdoc ICoordinate
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

    /// @inheritdoc ICoordinate
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

    /// @notice Checks if an address is a contributor.
    /// @param _contributor The address to check.
    function isContributor(address _contributor) external view returns (bool isTrue) {
        isTrue = contributors[_contributor];
    }

    /// @inheritdoc ICoordinate
    function isCoordinator(address _coordinator) external view returns (bool isTrue) {
        isTrue = coordinators[_coordinator];
    }

    /// @inheritdoc IWERKStrategy
    function getStrategyType() external pure returns (StrategyTypes) {
        return StrategyTypes.Commit;
    }

    /// @inheritdoc IERC165
    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return interfaceId == type(ICoordinate).interfaceId;
    }

    modifier onlyCoordinatorOrOwner() {
        if (!coordinators[msg.sender] && owner() != msg.sender) revert NotApprovedOrOwner();
        _;
    }
}
