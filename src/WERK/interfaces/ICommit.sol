// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface ICommit {
    event UserCommitted(address workstream, address user, address tokenAddress, uint256 tokenAmount);

    event UserWithdrawn(address workstream, address user, address tokenAddress, uint256 tokenAmount);

    function commit(address user, address tokenAddress, uint256 tokenAmount) external payable;

    function revoke(address user, address tokenAddress, uint256 tokenAmount) external payable;
}
