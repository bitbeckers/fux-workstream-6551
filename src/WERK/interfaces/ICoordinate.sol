// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface ICoordinate {
    event ContributorsAdded(address[] contributors, bytes data);
    event ContributorsRemoved(address[] contributor, bytes data);

    event CoordinatorsAdded(address[] coordinators, bytes data);
    event CoordinatorsRemoved(address[] coordinators, bytes data);

    function isContributor(address _contributor) external view returns (bool);
    function isCoordinator(address _coordinator) external view returns (bool);

    function addContributors(address[] memory _contributors, bytes memory data) external;

    function removeContributors(address[] memory _contributors, bytes memory data) external;

    function addCoordinators(address[] memory _coordinators, bytes memory data) external;

    function removeCoordinators(address[] memory _coordinators, bytes memory data) external;
}
