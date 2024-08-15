// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import { IWERK } from "./interfaces/IWERK.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import { CallFailed, NotAllowedOrApproved } from "./libraries/Errors.sol";
import { WorkstreamStatus, WerkInfo } from "./libraries/Structs.sol";

/// @title WERKImplementation
/// @dev This contract implements the WERK interface and allows the owner to coordinate, commit, evaluate, fund, and
/// distribute work.
contract WERKImplementation is IWERK, OwnableUpgradeable {
    /// @dev The address of the commitment strategy.
    address internal commitmentStrategy;
    /// @dev The address of the coordination strategy.
    address internal coordinationStrategy;
    /// @dev The address of the evaluation strategy.
    address internal evaluationStrategy;
    /// @dev The address of the funding strategy.
    address internal fundingStrategy;
    /// @dev The address of the payout strategy.
    address internal payoutStrategy;
    /// @dev The status of the workstream.
    WorkstreamStatus internal status;

    /// @dev Disables the initializers as this contract will be cloned per instance.
    constructor() {
        _disableInitializers();
    }

    /// @notice Sets up the contract.
    /// @dev This function is called only once, during the contract deployment.
    /// @param _initializationParams The initialization parameters, encoded as bytes. These parameters are decoded into
    /// the owner address and the addresses of the five strategies.
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

        __Ownable_init();
    }

    /// @notice Can only be called by the contract owner and if the workstream status is active. If the coordination
    /// strategy is not set, the function reverts.
    /// @inheritdoc IWERK
    function coordinate(bytes memory coordinationCallData) external override onlyOwner {
        if (status != WorkstreamStatus.Active) revert WorkstreamNotActive();
        if (coordinationStrategy == address(0)) revert NotAllowedOrApproved();

        (bool success, bytes memory returnData) = coordinationStrategy.call(coordinationCallData);

        if (!success) revert CallFailed(returnData);
    }

    /// @notice  Can only be called by the contract owner and if the workstream status is active. If the commitment
    /// strategy is not set, the function reverts.
    /// @inheritdoc IWERK
    function commit(bytes memory commitmentCallData) external override onlyOwner {
        if (status != WorkstreamStatus.Active) revert WorkstreamNotActive();
        if (commitmentStrategy == address(0)) revert NotAllowedOrApproved();

        (bool success, bytes memory returnData) = commitmentStrategy.call(commitmentCallData);

        if (!success) revert CallFailed(returnData);
    }

    /// @notice Can only be called by the contract owner and if the workstream status is active. If the evaluation
    /// strategy is not set, the function reverts.
    /// @inheritdoc IWERK
    function evaluate(bytes memory evaluationCallData) external override onlyOwner {
        if (status != WorkstreamStatus.Active) revert WorkstreamNotActive();
        if (evaluationStrategy == address(0)) revert NotAllowedOrApproved();

        (bool success, bytes memory returnData) = evaluationStrategy.call(evaluationCallData);

        if (!success) revert CallFailed(returnData);
    }

    /// @notice Can only be called by the contract owner and if the workstream status is active. If the funding strategy
    /// is not set, the function reverts.
    /// @inheritdoc IWERK
    function fund(bytes memory fundingCallData) external override onlyOwner {
        if (status != WorkstreamStatus.Active) revert WorkstreamNotActive();
        if (fundingStrategy == address(0)) revert NotAllowedOrApproved();

        (bool success, bytes memory returnData) = fundingStrategy.call(fundingCallData);

        if (!success) revert CallFailed(returnData);
    }

    /// @notice Can only be called by the contract owner and if the workstream status is active. If the payout strategy
    /// is not set, the function reverts.
    /// @inheritdoc IWERK
    function distribute(bytes memory distributionCallData) external override onlyOwner {
        if (status != WorkstreamStatus.Active) revert WorkstreamNotActive();
        if (payoutStrategy == address(0)) revert NotAllowedOrApproved();

        (bool success, bytes memory returnData) = payoutStrategy.call(distributionCallData);

        if (!success) revert CallFailed(returnData);
    }

    /// @notice  Can only be called by the contract owner. This function is potentially unsafe as it can call any
    /// contract including malicious ones.
    /// @inheritdoc IWERK
    function unsafeExecute(bytes memory _callData, address _target) external onlyOwner {
        (bool success, bytes memory returnData) = _target.call(_callData);

        if (!success) revert CallFailed(returnData);
    }

    // WERK

    /// @inheritdoc IWERK
    function getWerkInfo() external view returns (WerkInfo memory werkInfo) {
        werkInfo = WerkInfo({
            owner: owner(),
            coordinationStrategy: coordinationStrategy,
            commitmentStrategy: commitmentStrategy,
            evaluationStrategy: evaluationStrategy,
            fundingStrategy: fundingStrategy,
            payoutStrategy: payoutStrategy,
            status: status
        });
    }

    /// @notice  Can only be called by the contract owner.
    /// @inheritdoc IWERK
    function updateWorkstreamStatus(WorkstreamStatus _status) external override onlyOwner {
        status = _status;
        emit WorkstreamStatusUpdated(msg.sender, owner(), _status);
    }
}
