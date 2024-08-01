// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { StrategyTypes } from "../libraries/Enums.sol";

interface IStrategyRegistry {
    struct StrategyInfo {
        StrategyTypes strategyType;
        bytes32 strategyId;
        address implementation;
        bool isActive;
    }

    /**
     * @dev The registry MUST emit the StrategyCreated event upon successful strategy creation.
     */
    event StrategyCreated(StrategyTypes strategyType, bytes32 strategyId, address implementation, bool isActive);

    /**
     * @dev The registry MUST emit the StrategyUpdated event upon successful strategy update.
     */
    event StrategyUpdated(bytes32 strategyId, bool isActive);

    /**
     * @dev The registry MUST revert with StrategyCreationFailed error if the create2 operation fails.
     */
    error StrategyCreationFailed();

    /**
     * @dev The registry MUST revert with StrategyDoesNotExist error if the strategy does not exist.
     */
    error StrategyDoesNotExist();

    /**
     * @dev Stores the strategy information in the registry.
     *
     * If the strategy has already been created, returns the strategy ID without error.
     *
     * Emits StrategyCreated event.
     *
     * @param strategyType The type of the strategy.
     * @param implementation The address of the strategy implementation.
     * @param isActive Whether the strategy is active.
     * @return strategyId The ID of the created strategy.
     */
    function createStrategy(
        StrategyTypes strategyType,
        address implementation,
        bool isActive
    )
        external
        returns (bytes32 strategyId);

    /**
     * @dev Updates the strategy status.
     *
     * Emits StrategyUpdated event.
     *
     * @param strategyId The ID of the strategy to update.
     * @param isActive Whether the strategy is active.
     */
    function updateStrategy(bytes32 strategyId, bool isActive) external;

    /**
     * @dev Returns the strategy information from the registry.
     *
     * @param strategyId The ID of the strategy to get.
     * @return strategyInfo The strategy information
     */
    function getStrategy(bytes32 strategyId) external view returns (StrategyInfo memory strategyInfo);
}
