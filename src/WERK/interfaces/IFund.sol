// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IFund {
    event FundsDeposited(address user, address tokenAddress, uint256 tokenAmount);

    event FundsWithdrawn(address user, address tokenAddress, uint256 tokenAmount);

    error DepositFailed();
    error WithdrawalFailed();

    function deposit(address user, address tokenAddress, uint256 tokenAmount) external payable;

    function withdraw(address user, address tokenAddress, uint256 tokenAmount) external payable;
}
