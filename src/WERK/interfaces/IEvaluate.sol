// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IWERKStrategy } from "./IWERKStrategy.sol";

interface IEvaluate is IWERKStrategy {
    enum EvaluationStatus {
        CLOSED,
        OPEN,
        COMPLETED
    }

    event EvaluationSubmitted(address user, bytes evaluationData);

    event EvaluationStatusUpdated(EvaluationStatus status);

    error SubmitFailed();
    error UpdatingEvaluationStatusFailed();

    function submit(bytes memory evaluationData) external;

    function updateEvaluationStatus(EvaluationStatus _status) external;

    function getEvaluationStatus() external view returns (EvaluationStatus);
}
