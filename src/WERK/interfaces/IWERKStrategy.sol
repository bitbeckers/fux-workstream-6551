// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { StrategyTypes } from "../libraries/Enums.sol";
import { IERC165 } from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

interface IWERKStrategy is IERC165 {
    function setUp(bytes memory _initializationParams) external;

    function getStrategyType() external view returns (StrategyTypes strategyType);
}
