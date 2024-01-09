// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IStrategyRegistry {
    enum StrategyTypes {
        Coordinate,
        Commit,
        Fund,
        Evaluate
    }

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

    event StrategyUpdated(bytes32 strategyId, bool isActive);

    /**
     * @dev The registry MUST revert with StrategyCreationFailed error if the create2 operation fails.
     */
    error StrategyCreationFailed();

    error StrategyDoesNotExist();

    /**
     * @dev Stores the strategy information in the registry.
     *
     * If strategy has already been created, returns the strategy ID without error.
     *
     * Emits StrategyCreated event.
     *
     * @return strategyId The ID of the strategy in the registry
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
     */
    function updateStrategy(bytes32 strategyId, bool isActive) external;

    /**
     * @dev Returns the strategy information from the registry.
     *
     * @return strategyInfo The strategy information
     */
    function getStrategy(bytes32 strategyId) external view returns (StrategyInfo memory strategyInfo);
}
