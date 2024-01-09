// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IStrategyRegistry } from "./IStrategyRegistry.sol";
import { ICoordinate } from "./ICoordinate.sol";
import { ICommit } from "./ICommit.sol";
import { IEvaluate } from "./IEvaluate.sol";
import { IFund } from "./IFund.sol";

interface IWERK is ICoordinate, ICommit, IEvaluate, IFund {
    enum WorkstreamStatus {
        Pending,
        Active,
        Paused,
        Cancelled,
        Completed
    }

    struct WerkInfo {
        address owner;
        bytes32 coordinationStrategyId;
        bytes32 commitmentStrategyId;
        bytes32 evaluationStrategyId;
        bytes32 fundingStrategyId;
        WorkstreamStatus status;
    }

    event WorkstreamCreated(address owner, address instance, uint256 tokenId);
    event WorkstreamStatusUpdated(address operator, address user, WorkstreamStatus status);

    error WorkstreamNotActive();
    error UpdatingWorkstreamStatusFailed();

    function getWerkInfo() external view returns (WerkInfo memory);

    function updateWorkstreamStatus(WorkstreamStatus status) external;
}
