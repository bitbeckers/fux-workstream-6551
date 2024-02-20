// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

/// @notice Enum to easily identify the type of the accepted token stored.
enum TokenType {
    NATIVE,
    ERC20,
    ERC721,
    ERC1155
}

/// @notice Enum to easily identify the type of strategy configured in a workstream.
enum StrategyTypes {
    Coordinate,
    Commit,
    Fund,
    Evaluate,
    Payout
}

/// @notice This enum represents the possible statuses of a workstream.
enum WorkstreamStatus {
    Pending,
    Active,
    Paused,
    Cancelled,
    Completed
}
