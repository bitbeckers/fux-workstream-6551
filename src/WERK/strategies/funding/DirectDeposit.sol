// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IFund } from "../../interfaces/IFund.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import { InsufficientFunds, UnsupportedToken, CallFailed } from "../../libraries/Errors.sol";
import { AcceptedToken } from "../../libraries/Structs.sol";

contract DirectDeposit is IFund, OwnableUpgradeable {
    mapping(address tokenAddress => mapping(uint256 tokenId => bool isAccepted)) public acceptedTokens;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function setUp(bytes memory _initializationParams) public virtual initializer {
        (address _workstreamAccount) = abi.decode(_initializationParams, (address));

        __Ownable_init(_workstreamAccount);
    }

    function setAcceptedTokens(AcceptedToken[] memory _acceptedTokens, bool accepted) external override onlyOwner {
        for (uint256 i = 0; i < _acceptedTokens.length; i++) {
            acceptedTokens[_acceptedTokens[i].tokenAddress][_acceptedTokens[i].tokenId] = accepted;
        }

        emit AcceptedTokensUpdated(_acceptedTokens, accepted);
    }

    function deposit(
        address user,
        address tokenAddress,
        uint256 tokenId,
        uint256 tokenAmount
    )
        external
        payable
        override
    {
        if (!acceptedTokens[tokenAddress][tokenId]) revert UnsupportedToken();

        if (tokenAddress == address(0)) {
            if (msg.value > 0) {
                if (msg.value != tokenAmount) revert InsufficientFunds();
                (bool success,) = owner().call{ value: msg.value }("");

                if (!success) revert CallFailed();
            } else {
                revert InsufficientFunds();
            }
        } else {
            // Handle ERC20 token
            IERC20(tokenAddress).transferFrom(user, owner(), tokenAmount);
        }

        emit FundsDeposited(user, tokenAddress, tokenId, tokenAmount);
    }

    function withdraw(
        address user,
        address tokenAddress,
        uint256 tokenId,
        uint256 tokenAmount
    )
        external
        payable
        override
        onlyOwner
    {
        // TODO improve handling so it supports both native, ERC20 and ERC1155
        if (tokenAddress == address(0)) {
            payable(user).transfer(tokenAmount);
        } else {
            // Handle ERC20 token
            IERC20(tokenAddress).transferFrom(address(this), user, tokenAmount);
        }

        emit FundsWithdrawn(user, tokenAddress, tokenId, tokenAmount);
    }

    function isAcceptedToken(address tokenAddress, uint256 tokenId) external view override returns (bool) {
        return acceptedTokens[tokenAddress][tokenId];
    }
}
