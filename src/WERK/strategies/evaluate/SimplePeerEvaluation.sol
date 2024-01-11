// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IEvaluate } from "../../interfaces/IEvaluate.sol";

import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract SimplePeerEvaluation is IEvaluate, OwnableUpgradeable {
    EvaluationStatus public evaluationStatus;
    mapping(address user => bytes evaluationData) public evaluationData;

    error LengthMismatch();
    error NoSelfEvaluation();
    error InvalidTotals();

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function setUp(bytes memory _initializationParams) public virtual initializer {
        (address _workstreamAccount) = abi.decode(_initializationParams, (address));

        __Ownable_init(_workstreamAccount);
    }

    function submit(bytes memory _evaluationData) external {
        (address[] memory _contributors, uint256[] memory _ratings) =
            abi.decode(_evaluationData, (address[], uint256[]));

        if (_contributors.length != _ratings.length) revert LengthMismatch();

        // No self evaluation
        uint256 size = _contributors.length;
        for (uint256 i = 0; i < size;) {
            if (_contributors[i] == msg.sender) revert NoSelfEvaluation();
            unchecked {
                ++i;
            }
        }

        // Expect the total ratings to be 100
        uint256 total = _getTotal(_ratings);
        if (total != 100) revert InvalidTotals();

        evaluationData[msg.sender] = _evaluationData;

        emit EvaluationSubmitted(msg.sender, _evaluationData);
    }

    function updateEvaluationStatus(EvaluationStatus _status) external onlyOwner() {
        evaluationStatus = _status;
        emit EvaluationStatusUpdated(_status);
    }

    function getEvaluationStatus() external view returns (EvaluationStatus) {
        return evaluationStatus;
    }

    function getEvaluationData(address _user) external view returns (bytes memory) {
        return evaluationData[_user];
    }

    /**
     * UTILITY FUNCTIONS
     */

    /**
     * @dev Calculates the total value of an array of uint256 values
     * @param values An array of uint256 values
     * @return total The total value of the array
     */
    function _getTotal(uint256[] memory values) internal pure returns (uint256 total) {
        uint256 len = values.length;
        for (uint256 i = 0; i < len;) {
            total += values[i];
            unchecked {
                ++i;
            }
        }
    }
}
