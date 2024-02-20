// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IWERKStrategy } from "./IWERKStrategy.sol";

/// @title IEvaluate
/// @dev This interface extends IWERKStrategy and provides methods for submitting evaluations and updating their status.
interface IEvaluate is IWERKStrategy {
    /// @notice This enum represents the possible statuses of an evaluation.
    enum EvaluationStatus {
        CLOSED,
        OPEN,
        COMPLETED
    }

    /// @notice This event is emitted when an evaluation is submitted.
    /// @param user The address of the user who submitted the evaluation.
    /// @param evaluationData The data of the submitted evaluation.
    event EvaluationSubmitted(address user, bytes evaluationData);

    /// @notice This event is emitted when the status of an evaluation is updated.
    /// @param status The new status of the evaluation.
    event EvaluationStatusUpdated(EvaluationStatus status);

    /// @notice This error is emitted when a submit operation fails.
    error SubmitFailed();

    /// @notice This error is emitted when an operation to update the evaluation status fails.
    error UpdatingEvaluationStatusFailed();

    /// @notice Submits an evaluation.
    /// @dev This function MUST emit the EvaluationSubmitted event.
    /// @param evaluationData The data of the evaluation to submit.
    function submit(bytes memory evaluationData) external;

    /// @notice Updates the status of an evaluation.
    /// @dev This function MUST emit the EvaluationStatusUpdated event.
    /// @param _status The new status of the evaluation.
    function updateEvaluationStatus(EvaluationStatus _status) external;

    /// @notice Gets the current status of an evaluation.
    /// @return status The current status of the evaluation.
    function getEvaluationStatus() external view returns (EvaluationStatus status);
}
