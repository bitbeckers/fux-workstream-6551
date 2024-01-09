// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import { IWERK } from "./interfaces/IWERK.sol";
import { ICommit } from "./interfaces/ICommit.sol";
import { IEvaluate } from "./interfaces/IEvaluate.sol";
import { IFund } from "./interfaces/IFund.sol";
import { ICoordinate } from "./interfaces/ICoordinate.sol";
import { IStrategyRegistry } from "./interfaces/IStrategyRegistry.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract WERKImplementation is IWERK, OwnableUpgradeable {
    address internal commitmentStrategy;
    address internal coordinationStrategy;
    address internal evaluationStrategy;
    address internal fundingStrategy;
    WorkstreamStatus internal status;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    // _initializationParams = abi.encode(
    // address _owner,
    // address _commitmentStrategy,
    // address _coordinationStrategy,
    // address _evaluationStrategy,
    // address _fundingStrategy,
    // )
    function setUp(bytes memory _initializationParams) public virtual initializer {
        (
            address _owner,
            address _commitmentStrategy,
            address _coordinationStrategy,
            address _evaluationStrategy,
            address _fundingStrategy
        ) = abi.decode(_initializationParams, (address, address, address, address, address));

        commitmentStrategy = _commitmentStrategy;
        coordinationStrategy = _coordinationStrategy;
        evaluationStrategy = _evaluationStrategy;
        fundingStrategy = _fundingStrategy;

        __Ownable_init(_owner);
    }

    // Coordinate

    function addContributors(address[] memory _contributors, bytes memory data) external override {
        ICoordinate(coordinationStrategy).addContributors(_contributors, data);
    }

    function removeContributors(address[] memory _contributors, bytes memory data) external override {
        ICoordinate(coordinationStrategy).removeContributors(_contributors, data);
    }

    function addCoordinators(address[] memory _coordinators, bytes memory data) external override {
        ICoordinate(coordinationStrategy).addCoordinators(_coordinators, data);
    }

    function removeCoordinators(address[] memory _coordinators, bytes memory data) external override {
        ICoordinate(coordinationStrategy).removeCoordinators(_coordinators, data);
    }

    function isContributor(address _contributor) external view override returns (bool) {
        return ICoordinate(coordinationStrategy).isContributor(_contributor);
    }

    function isCoordinator(address _coordinator) external view override returns (bool) {
        return ICoordinate(coordinationStrategy).isCoordinator(_coordinator);
    }

    // Commit

    function commit(address user, address tokenAddress, uint256 tokenAmount) external payable override {
        ICommit(commitmentStrategy).commit(user, tokenAddress, tokenAmount);
    }

    function revoke(address user, address tokenAddress, uint256 tokenAmount) external payable override {
        ICommit(commitmentStrategy).revoke(user, tokenAddress, tokenAmount);
    }

    // Fund

    function deposit(address user, address tokenAddress, uint256 tokenAmount) external payable override {
        IFund(fundingStrategy).deposit(user, tokenAddress, tokenAmount);
    }

    function withdraw(address user, address tokenAddress, uint256 tokenAmount) external payable override {
        IFund(fundingStrategy).withdraw(user, tokenAddress, tokenAmount);
    }

    // Evaluate

    function submit(bytes memory evaluationData) external override {
        IEvaluate(evaluationStrategy).submit(evaluationData);
    }

    function updateEvaluationStatus(EvaluationStatus _status) external override {
        IEvaluate(evaluationStrategy).updateEvaluationStatus(_status);
    }

    function getEvaluationStatus() external view override returns (EvaluationStatus) {
        return IEvaluate(evaluationStrategy).getEvaluationStatus();
    }

    // WERK

    function getWerkInfo() external view returns (WerkInfo memory werk) {
        return WerkInfo({
            owner: owner(),
            coordinationStrategy: coordinationStrategy,
            commitmentStrategy: commitmentStrategy,
            evaluationStrategy: evaluationStrategy,
            fundingStrategy: fundingStrategy,
            status: status
        });
    }

    function updateWorkstreamStatus(WorkstreamStatus _status) external override onlyOwner {
        status = _status;
        emit WorkstreamStatusUpdated(msg.sender, owner(), _status);
    }
}
