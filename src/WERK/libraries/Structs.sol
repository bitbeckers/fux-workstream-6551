// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

struct AcceptedToken {
    address tokenAddress;
    uint256 tokenId;
}

struct Commitment {
    address user;
    address tokenAddress;
    uint256 tokenId;
    uint256 tokenAmount;
}
