// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IDistribute } from "../../interfaces/IDistribute.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import { InsufficientFunds } from "../../libraries/Errors.sol";

contract SimpleDistribution is IDistribute, OwnableUpgradeable {
    address internal treasury;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    function setUp(bytes memory _initializationParams) public virtual initializer {
        (address _workstreamAccount, address _treasury) = abi.decode(_initializationParams, (address, address));

        treasury = _treasury;
        __Ownable_init(_workstreamAccount);
    }

    function distribute(bytes memory payoutData) external payable onlyOwner {
        (address[] memory recipients, address[] memory tokens, uint256[] memory amounts) =
            abi.decode(payoutData, (address[], address[], uint256[]));

        for (uint256 i = 0; i < recipients.length; i++) {
            address recipient = recipients[i];
            address tokenAddress = tokens[i];
            uint256 tokenAmount = amounts[i];

            (
                address(uint160(treasury)).delegatecall(
                    abi.encodeWithSignature("withdraw(address,address,uint256)", recipient, tokenAddress, tokenAmount)
                )
            );
        }

        emit Distributed(msg.sender, payoutData);
    }
}
