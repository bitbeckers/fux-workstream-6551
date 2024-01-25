// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { AcceptedToken } from "../libraries/Structs.sol";

/// @title IFund
/// @dev This is a generic interface for a fund management strategy.
interface IFund {
    /// @notice This event is emitted when the accepted tokens are updated.
    /// @param acceptedTokens The array of accepted tokens.
    /// @param accepted A boolean indicating whether the tokens are accepted.
    event AcceptedTokensUpdated(AcceptedToken[] acceptedTokens, bool accepted);

    /// @notice This event is emitted when funds are deposited.
    /// @param user The address of the user depositing the funds.
    /// @param tokenAddress The address of the token being deposited.
    /// @param tokenId The ID of the token being deposited.
    /// @param tokenAmount The amount of tokens being deposited.
    event FundsDeposited(address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount);

    /// @notice This event is emitted when funds are withdrawn.
    /// @param user The address of the user withdrawing the funds.
    /// @param tokenAddress The address of the token being withdrawn.
    /// @param tokenId The ID of the token being withdrawn.
    /// @param tokenAmount The amount of tokens being withdrawn.
    event FundsWithdrawn(address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount);

    /// @notice This error is emitted when a deposit fails.
    error DepositFailed();

    /// @notice This error is emitted when a withdrawal fails.
    error WithdrawalFailed();

    /// @notice Deposits tokens into the fund.
    /// @param user The address of the user depositing the tokens.
    /// @param tokenAddress The address of the token being deposited.
    /// @param tokenId The ID of the token being deposited.
    /// @param tokenAmount The amount of tokens to deposit.
    function deposit(address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount) external payable;

    /// @notice Withdraws tokens from the fund.
    /// @param user The address of the user withdrawing the tokens.
    /// @param tokenAddress The address of the token being withdrawn.
    /// @param tokenId The ID of the token being withdrawn.
    /// @param tokenAmount The amount of tokens to withdraw.
    function withdraw(address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount) external payable;

    /// @notice Checks if a token is accepted by the fund.
    /// @param tokenAddress The address of the token. Zero address if native token.
    /// @param tokenId The ID of the token. Zero if native token.
    /// @return isAccepted A boolean indicating whether the token is accepted.
    function isAcceptedToken(address tokenAddress, uint256 tokenId) external view returns (bool isAccepted);

    /// @notice Sets the accepted tokens for the fund.
    /// @param _acceptedTokens The array of accepted tokens.
    /// @param accepted A boolean indicating whether the tokens should be accepted.
    function setAcceptedTokens(AcceptedToken[] memory _acceptedTokens, bool accepted) external;
}
