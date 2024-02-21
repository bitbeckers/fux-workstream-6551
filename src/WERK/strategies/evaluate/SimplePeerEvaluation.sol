// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IEvaluate } from "../../interfaces/IEvaluate.sol";

import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import { StrategyTypes } from "../../libraries/Enums.sol";
import { IWERKStrategy } from "../../interfaces/IWERKStrategy.sol";
import { IERC165 } from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

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

    /// @inheritdoc IWERKStrategy
    function setUp(bytes memory _initializationParams) public virtual initializer {
        (address _owner) = abi.decode(_initializationParams, (address));

        __Ownable_init();
    }

    /// @notice The SimplePeerEvaluation strategy expect an array of addresses and an array of uint256 ratings.
    /// the length of the two arrays must be the same and the total of the ratings must be 100.
    /// To encode the data, use abi.encode([address1,..., addressN], [rating1,..., ratingN]).
    /// The function reverts if the user tries to evaluate themselves.
    /// @inheritdoc IEvaluate
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

    /// @inheritdoc IEvaluate
    function updateEvaluationStatus(EvaluationStatus _status) external onlyOwner {
        evaluationStatus = _status;
        emit EvaluationStatusUpdated(_status);
    }

    /// @inheritdoc IEvaluate
    function getEvaluationStatus() external view returns (EvaluationStatus status) {
        status = evaluationStatus;
    }

    /// @notice This function is specific to the SimplePeerEvaluation strategy and returns the evaluation data of a user
    function getEvaluationData(address _user) external view returns (bytes memory data) {
        data = evaluationData[_user];
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

    /// @inheritdoc IWERKStrategy
    function getStrategyType() external pure returns (StrategyTypes strategyType) {
        strategyType = StrategyTypes.Evaluate;
    }

    /// @inheritdoc IERC165
    function supportsInterface(bytes4 interfaceId) public pure returns (bool supported) {
        supported = interfaceId == type(IEvaluate).interfaceId;
    }
}
