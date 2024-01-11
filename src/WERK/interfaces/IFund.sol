// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { AcceptedToken } from "../libraries/Structs.sol";

interface IFund {
    event AcceptedTokensUpdated(AcceptedToken[] acceptedTokens, bool accepted);
    event FundsDeposited(address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount);

    event FundsWithdrawn(address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount);

    error DepositFailed();
    error WithdrawalFailed();

    function deposit(address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount) external payable;

    function withdraw(address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount) external payable;

    function isAcceptedToken(address tokenAddress, uint256 tokenId) external view returns (bool isAccepted);

    function setAcceptedTokens(AcceptedToken[] memory _acceptedTokens, bool accepted) external;
}
