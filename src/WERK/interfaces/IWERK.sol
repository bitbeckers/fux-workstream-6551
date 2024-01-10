// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IStrategyRegistry } from "./IStrategyRegistry.sol";
import { ICoordinate } from "./ICoordinate.sol";
import { ICommit } from "./ICommit.sol";
import { IDistribute } from "./IDistribute.sol";
import { IEvaluate } from "./IEvaluate.sol";
import { IFund } from "./IFund.sol";

interface IWERK is ICoordinate, ICommit, IEvaluate, IDistribute, IFund {
    enum WorkstreamStatus {
        Pending,
        Active,
        Paused,
        Cancelled,
        Completed
    }

    struct WerkInfo {
        address owner;
        address coordinationStrategy;
        address commitmentStrategy;
        address evaluationStrategy;
        address fundingStrategy;
        address payoutStrategy;
        WorkstreamStatus status;
    }

    event WorkstreamCreated(address owner, address instance, uint256 tokenId);
    event WorkstreamStatusUpdated(address operator, address user, WorkstreamStatus status);

    error WorkstreamNotActive();
    error UpdatingWorkstreamStatusFailed();

    function getWerkInfo() external view returns (WerkInfo memory);

    function updateWorkstreamStatus(WorkstreamStatus status) external;
}
