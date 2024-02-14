// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { Commitment } from "../libraries/Structs.sol";
import { IWERKStrategy } from "./IWERKStrategy.sol";

/// @title ICommit
/// @dev This is a generic interface for a commitment strategy.
interface ICommit is IWERKStrategy {
    /// @notice This event is emitted when a user commits tokens.
    /// @param workstream The address of the workstream.
    /// @param user The address of the user.
    /// @param tokenAddress The address of the token. Zero address if native token.
    /// @param tokenId The ID of the token. Zero if native token.
    /// @param tokenAmount The amount of tokens committed.
    event UserCommitted(address workstream, address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount);

    /// @notice This event is emitted when a user withdraws tokens.
    /// @param workstream The address of the workstream.
    /// @param user The address of the user.
    /// @param tokenAddress The address of the token. Zero address if native token.
    /// @param tokenId The ID of the token. Zero if native token.
    /// @param tokenAmount The amount of tokens withdrawn.
    event UserWithdrawn(address workstream, address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount);

    /// @notice Commits tokens on behalf of a user.
    /// @dev This function MUST emit the UserCommitted event.
    /// @param user The address of the user.
    /// @param tokenAddress The address of the token. Zero address if native token.
    /// @param tokenId The ID of the token. Zero if native token.
    /// @param tokenAmount The amount of tokens to commit.
    function commit(address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount) external payable;

    /// @notice Revokes a commitment on behalf of a user.
    /// @dev This function MUST emit the UserWithdrawn event.
    /// @param user The address of the user.
    /// @param tokenAddress The address of the token. Zero address if native token.
    /// @param tokenId The ID of the token. Zero if native token.
    /// @param tokenAmount The amount of tokens to revoke.
    function revoke(address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount) external payable;

    /// @notice Returns the commitments of a user.
    /// @param user The address of the user.
    /// @return commitments array of Commitment structs representing the user's commitments.
    function getCommitments(address user) external view returns (Commitment[] memory commitments);
}
