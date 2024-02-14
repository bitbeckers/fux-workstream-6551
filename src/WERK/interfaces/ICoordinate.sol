// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IWERKStrategy } from "./IWERKStrategy.sol";

/// @title ICoordinate
/// @dev This interface extends IWERKStrategy and provides methods for managing coordinators.
interface ICoordinate is IWERKStrategy {
    /// @notice This event is emitted when coordinators are added.
    /// @param coordinators The addresses of the coordinators added.
    /// @param data Additional data associated with the addition.
    event CoordinatorsAdded(address[] coordinators, bytes data);

    /// @notice This event is emitted when coordinators are removed.
    /// @param coordinators The addresses of the coordinators removed.
    /// @param data Additional data associated with the removal.
    event CoordinatorsRemoved(address[] coordinators, bytes data);

    /// @notice Checks if an address is a coordinator.
    /// @param _coordinator The address to check.
    /// @return A boolean indicating whether the address is a coordinator.
    function isCoordinator(address _coordinator) external view returns (bool);

    /// @notice Adds coordinators.
    /// @param _coordinators The addresses of the coordinators to add.
    /// @param data Additional data associated with the addition.
    /// @dev This function MUST emit CoordinatorsAdded.
    function addCoordinators(address[] memory _coordinators, bytes memory data) external;

    /// @notice Removes coordinators.
    /// @param _coordinators The addresses of the coordinators to remove.
    /// @param data Additional data associated with the removal.
    /// @dev This function MUST emit CoordinatorsRemoved.
    function removeCoordinators(address[] memory _coordinators, bytes memory data) external;
}
