// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { Commitment } from "../libraries/Structs.sol";

interface ICommit {
    event UserCommitted(address workstream, address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount);

    event UserWithdrawn(address workstream, address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount);

    function commit(address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount) external payable;

    function revoke(address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount) external payable;

    function getCommitments(address user) external view returns (Commitment[] memory);
}
