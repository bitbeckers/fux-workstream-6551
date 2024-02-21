// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { StrategyTypes } from "../libraries/Enums.sol";
import { IERC165 } from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

/**
 * @title IWERKStrategy
 * @dev Interface for the WERK strategy contract.
 */
interface IWERKStrategy is IERC165 {
    /// @notice Sets up the strategy. Required parameters can change per strategy.
    function setUp(bytes memory _initializationParams) external;

    /// @notice Returns the strategy type.
    function getStrategyType() external view returns (StrategyTypes strategyType);
}
