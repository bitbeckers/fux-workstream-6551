// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IEvaluate } from "../../src/WERK/interfaces/IEvaluate.sol";
import { StrategyTypes } from "../../src/WERK/libraries/Enums.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract MockEvaluate is IEvaluate, OwnableUpgradeable {
    EvaluationStatus public status;

    function setUp(bytes memory _initializationParams) external initializer {
        (address _owner) = abi.decode(_initializationParams, (address));

        __Ownable_init();
    }

    function getStrategyType() external view returns (StrategyTypes strategyType) {
        return StrategyTypes.Evaluate;
    }

    function submit(bytes memory evaluationData) external {
        emit EvaluationSubmitted(msg.sender, evaluationData);
    }

    function updateEvaluationStatus(EvaluationStatus _status) external {
        emit EvaluationStatusUpdated(_status);
    }

    function getEvaluationStatus() external view returns (EvaluationStatus) {
        return status;
    }

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return interfaceId == type(IEvaluate).interfaceId;
    }
}
