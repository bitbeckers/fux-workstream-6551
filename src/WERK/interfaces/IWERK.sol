// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IStrategyRegistry } from "./IStrategyRegistry.sol";
import { ICoordinate } from "./ICoordinate.sol";
import { ICommit } from "./ICommit.sol";
import { IDistribute } from "./IDistribute.sol";
import { IEvaluate } from "./IEvaluate.sol";
import { IFund } from "./IFund.sol";

interface IWERK {
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

    struct WorkstreamPointer {
        string name;
        string uri;
    }

    event WorkstreamCreated(address owner, address instance, uint256 tokenId);
    event WorkstreamStatusUpdated(address operator, address user, WorkstreamStatus status);

    error WorkstreamNotActive();
    error UpdatingWorkstreamStatusFailed();

    function getWerkInfo() external view returns (WerkInfo memory);

    function updateWorkstreamStatus(WorkstreamStatus status) external;

    function coordinate(bytes memory coordinationCallData) external;

    function commit(bytes memory commitmentCallData) external;

    function evaluate(bytes memory evaluationCallData) external;

    function fund(bytes memory fundingCallData) external;

    function distribute(bytes memory distributionCallData) external;
}
