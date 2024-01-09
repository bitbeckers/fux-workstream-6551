// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IFund } from "../../interfaces/IFund.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract DirectDeposit is IFund, OwnableUpgradeable {
    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function setUp(bytes memory _initializationParams) public virtual initializer {
        (address _workstreamAccount) = abi.decode(_initializationParams, (address));

        __Ownable_init(_workstreamAccount);
    }

    function deposit(address user, address tokenAddress, uint256 tokenAmount) external payable override {
        address recipient = owner();
        if (tokenAddress == address(0)) {
            if (msg.value > 0) {
                if (msg.value != tokenAmount) revert InsufficientFunds();
                (bool success,) = recipient.call{ value: msg.value }("");
                if (!success) revert DepositFailed();
            } else {
                revert InsufficientFunds();
            }
        } else {
            // Handle ERC20 token
            IERC20(tokenAddress).transferFrom(user, recipient, tokenAmount);
        }
    }

    function withdraw(address user, address tokenAddress, uint256 tokenAmount) external payable override onlyOwner {
        address recipient = owner();
        if (tokenAddress == address(0)) {
            if (msg.value != tokenAmount) revert InsufficientFunds();
            (bool success,) = user.call{ value: msg.value }("");
            if (!success) revert DepositFailed();
        } else {
            // Handle ERC20 token
            IERC20(tokenAddress).transferFrom(recipient, user, tokenAmount);
        }
    }
}
