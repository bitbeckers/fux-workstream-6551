// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IDistribute } from "../../interfaces/IDistribute.sol";
import { IERC20 } from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import { DelegateCallFailed } from "../../libraries/Errors.sol";

import { IERC6551Executable } from "../../interfaces/IERC6551Executable.sol";

import { StrategyTypes } from "../../libraries/Enums.sol";
import { IWERKStrategy } from "../../interfaces/IWERKStrategy.sol";
import { IERC165 } from "@openzeppelin/contracts/utils/introspection/IERC165.sol";

/// @title SimpleDistribution
/// @dev This contract allows users to distribute tokens to multiple recipients.
contract SimpleDistribution is IDistribute, OwnableUpgradeable {
    address internal treasury;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor() {
        _disableInitializers();
    }

    /// @inheritdoc IWERKStrategy
    function setUp(bytes memory _initializationParams) public virtual initializer {
        (address _owner, address _treasury) = abi.decode(_initializationParams, (address, address));

        treasury = _treasury;
        __Ownable_init(_owner);
    }

    /// @notice Distributes tokens to multiple recipients. The function expects an array of addresses, an array of token
    /// addresses, an array of token IDs, and an array of token amounts. The function reverts if the length of the
    /// arrays
    /// is not the same.
    /// @inheritdoc IDistribute
    function distribute(bytes memory payoutData) external payable onlyOwner {
        (address[] memory recipients, address[] memory tokens, uint256[] memory tokenIds, uint256[] memory amounts) =
            abi.decode(payoutData, (address[], address[], uint256[], uint256[]));

        for (uint256 i = 0; i < recipients.length; i++) {
            address recipient = recipients[i];
            address tokenAddress = tokens[i];
            uint256 tokenId = tokenIds[i];
            uint256 tokenAmount = amounts[i];

            // TODO improve handling so it supports both native, ERC20 and ERC1155
            if (tokenAddress == address(0)) {
                IERC6551Executable(treasury).execute(recipient, tokenAmount, "", 0);
            } else {
                // TODO repalce with IERC6551 Executable transferFrom call on treasuryc (workstreamAccount)
                // Handle ERC20 token
                IERC20(tokenAddress).transferFrom(treasury, recipient, tokenAmount);
            }
        }

        emit Distributed(msg.sender, payoutData);
    }

    /// @inheritdoc IWERKStrategy
    function getStrategyType() external pure returns (StrategyTypes) {
        return StrategyTypes.Payout;
    }

    /// @inheritdoc IERC165
    function supportsInterface(bytes4 interfaceId) public pure returns (bool) {
        return interfaceId == type(IDistribute).interfaceId;
    }
}
