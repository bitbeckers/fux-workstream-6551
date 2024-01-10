// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IFund } from "../../interfaces/IFund.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import { InsufficientFunds } from "../../libraries/Errors.sol";

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
        if (tokenAddress == address(0)) {
            if (msg.value > 0) {
                if (msg.value != tokenAmount) revert InsufficientFunds();
            } else {
                revert InsufficientFunds();
            }
        } else {
            // Handle ERC20 token
            IERC20(tokenAddress).transferFrom(user, address(this), tokenAmount);
        }
    }

    function withdraw(address user, address tokenAddress, uint256 tokenAmount) external payable override onlyOwner {
        if (tokenAddress == address(0)) {
            if (address(this).balance < tokenAmount) revert InsufficientFunds();
            (bool success,) = user.call{ value: tokenAmount }("");
            if (!success) revert WithdrawalFailed();
        } else {
            // Handle ERC20 token
            IERC20(tokenAddress).transferFrom(address(this), user, tokenAmount);
        }
    }
}
