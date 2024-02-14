// SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.23;

import { IWERK } from "./interfaces/IWERK.sol";
import { IStrategyRegistry } from "./interfaces/IStrategyRegistry.sol";
import { IWERKStrategy } from "./interfaces/IWERKStrategy.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import { StrategyTypes } from "./libraries/Enums.sol";

import { AcceptedToken, Commitment } from "./libraries/Structs.sol";
import { CallFailed, NotAllowedOrApproved } from "./libraries/Errors.sol";

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

    // TODO validations on strategy types and supported interfaces
    function coordinate(bytes memory coordinationCallData) external override onlyOwner {
        if (status != WorkstreamStatus.Active) revert WorkstreamNotActive();
        if (coordinationStrategy == address(0)) revert NotAllowedOrApproved();

        (bool success, bytes memory returnData) = coordinationStrategy.call(coordinationCallData);

        if (!success) revert CallFailed(returnData);
    }

    function commit(bytes memory commitmentCallData) external override onlyOwner {
        if (status != WorkstreamStatus.Active) revert WorkstreamNotActive();
        if (commitmentStrategy == address(0)) revert NotAllowedOrApproved();

        (bool success, bytes memory returnData) = commitmentStrategy.call(commitmentCallData);

        if (!success) revert CallFailed(returnData);
    }

    function evaluate(bytes memory evaluationCallData) external override onlyOwner {
        if (status != WorkstreamStatus.Active) revert WorkstreamNotActive();
        if (evaluationStrategy == address(0)) revert NotAllowedOrApproved();

        (bool success, bytes memory returnData) = evaluationStrategy.call(evaluationCallData);

        if (!success) revert CallFailed(returnData);
    }

    function fund(bytes memory fundingCallData) external override onlyOwner {
        if (status != WorkstreamStatus.Active) revert WorkstreamNotActive();
        if (fundingStrategy == address(0)) revert NotAllowedOrApproved();

        (bool success, bytes memory returnData) = fundingStrategy.call(fundingCallData);

        if (!success) revert CallFailed(returnData);
    }

    function distribute(bytes memory distributionCallData) external override onlyOwner {
        if (status != WorkstreamStatus.Active) revert WorkstreamNotActive();
        if (payoutStrategy == address(0)) revert NotAllowedOrApproved();

        (bool success, bytes memory returnData) = payoutStrategy.call(distributionCallData);

        if (!success) revert CallFailed(returnData);
    }

    function unsafeExecute(bytes memory _callData, address _target) external onlyOwner {
        (bool success, bytes memory returnData) = _target.call(_callData);

        if (!success) revert CallFailed(returnData);
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
