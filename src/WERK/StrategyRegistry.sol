// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IStrategyRegistry } from "./interfaces/IStrategyRegistry.sol";

contract StrategyRegistry is IStrategyRegistry, Ownable {
    mapping(bytes32 strategyId => StrategyInfo strategy) public strategies;

    // solhint-disable-next-line no-empty-blocks
    constructor(address owner) Ownable(owner) { }

    function createStrategy(
        StrategyTypes strategyType,
        address implementation,
        bool isActive
    )
        external
        onlyOwner
        returns (bytes32 strategyId)
    {
        bytes32 salt = keccak256(abi.encodePacked(strategyType, implementation));

        if (strategies[salt].implementation != address(0)) {
            return salt;
        }

        strategies[salt] = StrategyInfo(strategyType, salt, implementation, isActive);

        emit StrategyCreated(strategyType, salt, implementation, isActive);

        return salt;
    }

    function updateStrategy(bytes32 strategyId, bool isActive) external onlyOwner {
        strategies[strategyId].isActive = isActive;

        emit StrategyUpdated(strategyId, isActive);
    }

    function getStrategy(bytes32 strategyId) external view returns (StrategyInfo memory strategyInfo) {
        return strategies[strategyId];
    }
}
