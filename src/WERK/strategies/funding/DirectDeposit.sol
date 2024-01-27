// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IFund } from "../../interfaces/IFund.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import { InsufficientFunds, UnsupportedToken, CallFailed } from "../../libraries/Errors.sol";
import { AcceptedToken } from "../../libraries/Structs.sol";

import { IERC6551Executable } from "../../interfaces/IERC6551Executable.sol";

contract DirectDeposit is IFund, OwnableUpgradeable {
    address public treasury;
    mapping(address tokenAddress => mapping(uint256 tokenId => bool isAccepted)) public acceptedTokens;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function setUp(bytes memory _initializationParams) public virtual initializer {
        (address _owner, address _treasury) = abi.decode(_initializationParams, (address, address));

        treasury = _treasury;
        __Ownable_init(_owner);
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
                (bool success,) = treasury.call{ value: msg.value }("");

                if (!success) revert CallFailed();
            } else {
                revert InsufficientFunds();
            }
        } else {
            // Handle ERC20 token
            IERC20(tokenAddress).transferFrom(user, treasury, tokenAmount);
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
            IERC6551Executable(treasury).execute(user, tokenAmount, "", 0);
        } else {
            // TODO repalce with IERC6551 Executable transferFrom call on treasuryc (workstreamAccount)
            // Handle ERC20 token
            IERC20(tokenAddress).transferFrom(treasury, user, tokenAmount);
        }

        emit FundsWithdrawn(user, tokenAddress, tokenId, tokenAmount);
    }

    function isAcceptedToken(address tokenAddress, uint256 tokenId) external view override returns (bool) {
        return acceptedTokens[tokenAddress][tokenId];
    }
}
