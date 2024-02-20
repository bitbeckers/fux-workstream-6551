// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { WorkstreamStatus } from "../libraries/Enums.sol";
import { WerkInfo } from "../libraries/Structs.sol";

/// @title IWERK
/// @dev This interface provides methods for managing workstreams.
interface IWERK {
    /// @notice This struct provides the name and external data of a workstream.
    struct WorkstreamPointer {
        string name;
        string uri;
    }

    /// @notice This event is emitted when a workstream is created.
    /// @param owner The owner of the workstream.
    /// @param instance The instance of the workstream.
    /// @param tokenId The token ID of the workstream.
    event WorkstreamCreated(address owner, address instance, uint256 tokenId);

    /// @notice This event is emitted when the status of a workstream is updated.
    /// @param operator The operator who updated the status.
    /// @param user The user who updated the status.
    /// @param status The new status of the workstream.
    event WorkstreamStatusUpdated(address operator, address user, WorkstreamStatus status);

    /// @notice This error is emitted when a workstream is not active.
    error WorkstreamNotActive();

    /// @notice This error is emitted when updating the status of a workstream fails.
    error UpdatingWorkstreamStatusFailed();

    /// @notice Gets the information of a workstream.
    /// @dev This function returns a WerkInfo struct that contains the owner address, the addresses of the configured
    /// strategies, and the workstream status.
    /// @return werkInfo information of the workstream.
    function getWerkInfo() external view returns (WerkInfo memory werkInfo);

    /// @notice This function updates the status of the workstream and emits
    /// a WorkstreamStatusUpdated event.
    /// @param status The new status of the workstream.
    function updateWorkstreamStatus(WorkstreamStatus status) external;

    /// @notice Calls the coordination strategy.
    /// @param coordinationCallData The call data for the coordination.
    function coordinate(bytes memory coordinationCallData) external;

    /// @notice Commits to a workstream.
    /// @param commitmentCallData The call data for the commitment.
    function commit(bytes memory commitmentCallData) external;

    /// @notice Evaluates a workstream.
    /// @param evaluationCallData The call data for the evaluation.
    function evaluate(bytes memory evaluationCallData) external;

    /// @notice Funds a workstream.
    /// @param fundingCallData The call data for the funding.
    function fund(bytes memory fundingCallData) external;

    /// @notice Distributes the funds of a workstream.
    /// @param distributionCallData The call data for the distribution.
    function distribute(bytes memory distributionCallData) external;

    /// @notice Executes a call in an unsafe manner.
    /// @param _callData The call data for the execution.
    /// @param _target The target of the execution.
    function unsafeExecute(bytes memory _callData, address _target) external;
}
