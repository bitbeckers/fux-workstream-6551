// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

import { TokenType, WorkstreamStatus } from "./Enums.sol";

/// @notice Struct declaring the accepted token types in a workstream.
struct AcceptedToken {
    TokenType tokenType;
    address tokenAddress;
    uint256 tokenId;
}

/// @notice Struct declaring the commitment of a user to a workstream.
struct Commitment {
    address user;
    address tokenAddress;
    uint256 tokenId;
    uint256 tokenAmount;
}

/// @notice This struct represents the status and configuration of a workstream.
struct WerkInfo {
    address owner;
    address coordinationStrategy;
    address commitmentStrategy;
    address evaluationStrategy;
    address fundingStrategy;
    address payoutStrategy;
    WorkstreamStatus status;
}
