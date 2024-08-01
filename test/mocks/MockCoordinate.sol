// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { ICoordinate } from "../../src/WERK/interfaces/ICoordinate.sol";
import { StrategyTypes } from "../../src/WERK/libraries/Enums.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract MockCoordinate is ICoordinate, OwnableUpgradeable {
    function setUp(bytes memory _initializationParams) external initializer {
        (address _owner) = abi.decode(_initializationParams, (address));

        __Ownable_init();
    }

    function getStrategyType() external view returns (StrategyTypes strategyType) {
        return StrategyTypes.Coordinate;
    }

    function isCoordinator(address /* _coordinator */ ) external view returns (bool) {
        return true;
    }

    function addCoordinators(address[] memory _coordinators, bytes memory data) external {
        emit CoordinatorsAdded(_coordinators, data);
    }

    function removeCoordinators(address[] memory _coordinators, bytes memory data) external {
        emit CoordinatorsRemoved(_coordinators, data);
    }

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return interfaceId == type(ICoordinate).interfaceId;
    }
}
