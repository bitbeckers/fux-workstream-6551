// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IWERKStrategy } from "./IWERKStrategy.sol";

interface ICoordinate is IWERKStrategy {
    event CoordinatorsAdded(address[] coordinators, bytes data);
    event CoordinatorsRemoved(address[] coordinators, bytes data);

    function isCoordinator(address _coordinator) external view returns (bool);

    function addCoordinators(address[] memory _coordinators, bytes memory data) external;

    function removeCoordinators(address[] memory _coordinators, bytes memory data) external;
}
