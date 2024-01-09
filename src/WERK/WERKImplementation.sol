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
    address public immutable strategyRegistry;
    bytes32 internal commitmentStrategyId;
    bytes32 internal fundingStrategyId;
    bytes32 internal evaluationStrategyId;
    bytes32 internal coordinationStrategyId;
    WorkstreamStatus internal status;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor(address _strategyRegistry) {
        strategyRegistry = _strategyRegistry;
        _disableInitializers();
    }

    // _initializationParams = abi.encode(
    // address _owner,
    // bytes32 _coordinationStrategyId,
    // bytes32 _commitmentStrategyId,
    // bytes32 _evaluationStrategyId,
    // bytes32 _fundingStrategyId,
    // )
    function setUp(bytes memory _initializationParams) public virtual initializer {
        (
            address _owner,
            bytes32 _coordinationStrategyId,
            bytes32 _commitmentStrategyId,
            bytes32 _evaluationStrategyId,
            bytes32 _fundingStrategyId
        ) = abi.decode(_initializationParams, (address, bytes32, bytes32, bytes32, bytes32));

        if (!IStrategyRegistry(strategyRegistry).isStrategy(_coordinationStrategyId)) {
            revert StrategyDoesNotExist();
        }

        if (!IStrategyRegistry(strategyRegistry).isStrategy(_commitmentStrategyId)) {
            revert StrategyDoesNotExist();
        }

        if (!IStrategyRegistry(strategyRegistry).isStrategy(_evaluationStrategyId)) {
            revert StrategyDoesNotExist();
        }

        if (!IStrategyRegistry(strategyRegistry).isStrategy(_fundingStrategyId)) {
            revert StrategyDoesNotExist();
        }

        commitmentStrategyId = _commitmentStrategyId;
        coordinationStrategyId = _coordinationStrategyId;
        evaluationStrategyId = _evaluationStrategyId;
        fundingStrategyId = _fundingStrategyId;

        __Ownable_init(_owner);
    }

    // Coordinate

    function addContributors(address[] memory _contributors, bytes memory data) external override {
        ICoordinate(IStrategyRegistry(strategyRegistry).getStrategy(coordinationStrategyId).implementation)
            .addContributors(_contributors, data);
    }

    function removeContributors(address[] memory _contributors, bytes memory data) external override {
        ICoordinate(IStrategyRegistry(strategyRegistry).getStrategy(coordinationStrategyId).implementation)
            .removeContributors(_contributors, data);
    }

    function addCoordinators(address[] memory _coordinators, bytes memory data) external override {
        ICoordinate(IStrategyRegistry(strategyRegistry).getStrategy(coordinationStrategyId).implementation)
            .addCoordinators(_coordinators, data);
    }

    function removeCoordinators(address[] memory _coordinators, bytes memory data) external override {
        ICoordinate(IStrategyRegistry(strategyRegistry).getStrategy(coordinationStrategyId).implementation)
            .removeCoordinators(_coordinators, data);
    }

    function isContributor(address _contributor) external view override returns (bool) {
        return ICoordinate(IStrategyRegistry(strategyRegistry).getStrategy(coordinationStrategyId).implementation)
            .isContributor(_contributor);
    }

    function isCoordinator(address _coordinator) external view override returns (bool) {
        return ICoordinate(IStrategyRegistry(strategyRegistry).getStrategy(coordinationStrategyId).implementation)
            .isCoordinator(_coordinator);
    }

    // Commit

    function commit(address user, address tokenAddress, uint256 tokenAmount) external payable override {
        ICommit(IStrategyRegistry(strategyRegistry).getStrategy(commitmentStrategyId).implementation).commit(
            user, tokenAddress, tokenAmount
        );
    }

    function revoke(address user, address tokenAddress, uint256 tokenAmount) external payable override {
        ICommit(IStrategyRegistry(strategyRegistry).getStrategy(commitmentStrategyId).implementation).revoke(
            user, tokenAddress, tokenAmount
        );
    }

    // Fund

    function deposit(address user, address tokenAddress, uint256 tokenAmount) external payable override {
        IFund(IStrategyRegistry(strategyRegistry).getStrategy(fundingStrategyId).implementation).deposit(
            user, tokenAddress, tokenAmount
        );
    }

    function withdraw(address user, address tokenAddress, uint256 tokenAmount) external payable override {
        IFund(IStrategyRegistry(strategyRegistry).getStrategy(fundingStrategyId).implementation).withdraw(
            user, tokenAddress, tokenAmount
        );
    }

    // Evaluate

    function submit(bytes memory evaluationData) external override {
        IEvaluate(IStrategyRegistry(strategyRegistry).getStrategy(evaluationStrategyId).implementation).submit(
            evaluationData
        );
    }

    function updateEvaluationStatus(EvaluationStatus _status) external override {
        IEvaluate(IStrategyRegistry(strategyRegistry).getStrategy(evaluationStrategyId).implementation)
            .updateEvaluationStatus(_status);
    }

    function getEvaluationStatus() external view override returns (EvaluationStatus) {
        return IEvaluate(IStrategyRegistry(strategyRegistry).getStrategy(evaluationStrategyId).implementation)
            .getEvaluationStatus();
    }

    // WERK

    function getWerkInfo() external view returns (WerkInfo memory werk) {
        return WerkInfo({
            owner: owner(),
            coordinationStrategyId: coordinationStrategyId,
            commitmentStrategyId: commitmentStrategyId,
            evaluationStrategyId: evaluationStrategyId,
            fundingStrategyId: fundingStrategyId,
            status: status
        });
    }

    function updateWorkstreamStatus(WorkstreamStatus _status) external override onlyOwner {
        status = _status;
        emit WorkstreamStatusUpdated(msg.sender, owner(), _status);
    }
}
