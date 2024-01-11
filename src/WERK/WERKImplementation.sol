// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import { IWERK } from "./interfaces/IWERK.sol";
import { ICommit } from "./interfaces/ICommit.sol";
import { IDistribute } from "./interfaces/IDistribute.sol";
import { IEvaluate } from "./interfaces/IEvaluate.sol";
import { IFund } from "./interfaces/IFund.sol";
import { ICoordinate } from "./interfaces/ICoordinate.sol";
import { IStrategyRegistry } from "./interfaces/IStrategyRegistry.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import { AcceptedToken, Commitment } from "./libraries/Structs.sol";
import { DelegateCallFailed } from "./libraries/Errors.sol";

contract WERKImplementation is IWERK, OwnableUpgradeable {
    address internal commitmentStrategy;
    address internal coordinationStrategy;
    address internal evaluationStrategy;
    address internal fundingStrategy;
    address internal payoutStrategy;
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
    // address _payoutStrategy
    // )
    function setUp(bytes memory _initializationParams) public virtual initializer {
        (
            address _owner,
            address _commitmentStrategy,
            address _coordinationStrategy,
            address _evaluationStrategy,
            address _fundingStrategy,
            address _payoutStrategy
        ) = abi.decode(_initializationParams, (address, address, address, address, address, address));

        commitmentStrategy = _commitmentStrategy;
        coordinationStrategy = _coordinationStrategy;
        evaluationStrategy = _evaluationStrategy;
        fundingStrategy = _fundingStrategy;
        payoutStrategy = _payoutStrategy;

        __Ownable_init(_owner);
    }

    // Coordinate

    function addContributors(address[] memory _contributors, bytes memory data) external override {
        (bool success,) = coordinationStrategy.delegatecall(
            abi.encodeWithSignature("addContributors(address[],bytes)", _contributors, data)
        );

        if (!success) revert DelegateCallFailed();
    }

    function removeContributors(address[] memory _contributors, bytes memory data) external override {
        (bool success,) = coordinationStrategy.delegatecall(
            abi.encodeWithSignature("removeContributors(address[],bytes)", _contributors, data)
        );

        if (!success) revert DelegateCallFailed();
    }

    function addCoordinators(address[] memory _coordinators, bytes memory data) external override {
        (bool success,) = coordinationStrategy.delegatecall(
            abi.encodeWithSignature("addCoordinators(address[],bytes)", _coordinators, data)
        );

        if (!success) revert DelegateCallFailed();
    }

    function removeCoordinators(address[] memory _coordinators, bytes memory data) external override {
        (bool success,) = coordinationStrategy.delegatecall(
            abi.encodeWithSignature("removeCoordinators(address[],bytes)", _coordinators, data)
        );

        if (!success) revert DelegateCallFailed();
    }

    function isContributor(address _contributor) external view override returns (bool) {
        return ICoordinate(coordinationStrategy).isContributor(_contributor);
    }

    function isCoordinator(address _coordinator) external view override returns (bool) {
        return ICoordinate(coordinationStrategy).isCoordinator(_coordinator);
    }

    // Commit

    function commit(address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount) external payable {
        (bool success,) = commitmentStrategy.delegatecall(
            abi.encodeWithSignature("commit(address,address,uint256,uint256)", user, tokenAddress, tokenId, tokenAmount)
        );

        if (!success) revert DelegateCallFailed();
    }

    function revoke(address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount) external payable {
        (bool success,) = commitmentStrategy.delegatecall(
            abi.encodeWithSignature("revoke(address,address,uint256,uint256)", user, tokenAddress, tokenId, tokenAmount)
        );

        if (!success) revert DelegateCallFailed();
    }

    function getCommitments(address user) external view override returns (Commitment[] memory) {
        return ICommit(commitmentStrategy).getCommitments(user);
    }

    // Fund

    function deposit(address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount) external payable {
        (bool success,) = fundingStrategy.delegatecall(
            abi.encodeWithSignature(
                "deposit(address,address,uint256,uint256)", user, tokenAddress, tokenId, tokenAmount
            )
        );

        if (!success) revert DelegateCallFailed();
    }

    function withdraw(
        address user,
        address tokenAddress,
        uint256 tokenId,
        uint256 tokenAmount
    )
        external
        payable
        onlyOwner
    {
        (bool success,) = fundingStrategy.delegatecall(
            abi.encodeWithSignature(
                "withdraw(address,address,uint256,uint256)", user, tokenAddress, tokenId, tokenAmount
            )
        );

        if (!success) revert DelegateCallFailed();
    }

    function isAcceptedToken(address tokenAddress, uint256 tokenId) external view override returns (bool isAccepted) {
        return IFund(fundingStrategy).isAcceptedToken(tokenAddress, tokenId);
    }

    function setAcceptedTokens(AcceptedToken[] memory _acceptedTokens, bool accepted) external override onlyOwner {
        (bool success,) = fundingStrategy.delegatecall(
            abi.encodeWithSignature("setAcceptedTokens((address,uint256)[],bool)", _acceptedTokens, accepted)
        );

        if (!success) revert DelegateCallFailed();
    }

    // Evaluate

    function submit(bytes memory evaluationData) external override {
        (bool success,) = evaluationStrategy.delegatecall(abi.encodeWithSignature("submit(bytes)", evaluationData));

        if (!success) revert DelegateCallFailed();
    }

    function updateEvaluationStatus(EvaluationStatus _status) external override {
        (bool success,) =
            evaluationStrategy.delegatecall(abi.encodeWithSignature("updateEvaluationStatus(uint8)", _status));

        if (!success) revert DelegateCallFailed();
    }

    function getEvaluationStatus() external view override returns (EvaluationStatus) {
        return IEvaluate(evaluationStrategy).getEvaluationStatus();
    }

    // Distribute

    function distribute(bytes memory payoutData) external payable override onlyOwner {
        (bool success,) = payoutStrategy.delegatecall(abi.encodeWithSignature("distribute(bytes)", payoutData));

        if (!success) revert DelegateCallFailed();
    }

    // WERK

    function getWerkInfo() external view returns (WerkInfo memory werk) {
        return WerkInfo({
            owner: owner(),
            coordinationStrategy: coordinationStrategy,
            commitmentStrategy: commitmentStrategy,
            evaluationStrategy: evaluationStrategy,
            fundingStrategy: fundingStrategy,
            payoutStrategy: payoutStrategy,
            status: status
        });
    }

    function updateWorkstreamStatus(WorkstreamStatus _status) external override onlyOwner {
        status = _status;
        emit WorkstreamStatusUpdated(msg.sender, owner(), _status);
    }
}
