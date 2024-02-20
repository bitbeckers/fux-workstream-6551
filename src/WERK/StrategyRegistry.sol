// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IStrategyRegistry } from "./interfaces/IStrategyRegistry.sol";

import { StrategyTypes } from "./libraries/Enums.sol";

/// @title StrategyRegistry
/// @dev This contract allows the owner to create and update strategies.
contract StrategyRegistry is IStrategyRegistry, Ownable {
    /// @dev Maps strategy IDs to their information.
    mapping(bytes32 => StrategyInfo) public strategies;

    /// @notice Creates a new instance of StrategyRegistry.
    /// @param owner The initial owner of the contract.
    constructor(address owner) Ownable(owner) { }

    /// @notice Can only be called by the contract owner.
    /// @inheritdoc IStrategyRegistry
    function createStrategy(
        StrategyTypes strategyType,
        address implementation,
        bool isActive
    )
        external
        onlyOwner
        returns (bytes32 strategyId)
    {
        strategyId = keccak256(abi.encodePacked(strategyType, implementation));

        if (strategies[strategyId].implementation != address(0)) {
            return strategyId;
        }

        strategies[strategyId] = StrategyInfo(strategyType, strategyId, implementation, isActive);

        emit StrategyCreated(strategyType, strategyId, implementation, isActive);
    }

    /// @notice Can only be called by the contract owner.
    /// @inheritdoc IStrategyRegistry
    function updateStrategy(bytes32 strategyId, bool isActive) external onlyOwner {
        strategies[strategyId].isActive = isActive;

        emit StrategyUpdated(strategyId, isActive);
    }

    /// @inheritdoc IStrategyRegistry
    function getStrategy(bytes32 strategyId) external view returns (StrategyInfo memory strategyInfo) {
        return strategies[strategyId];
    }
}
