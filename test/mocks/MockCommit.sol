// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { ICommit } from "../../src/WERK/interfaces/ICommit.sol";
import { StrategyTypes } from "../../src/WERK/libraries/Enums.sol";
import { Commitment } from "../../src/WERK/libraries/Structs.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract MockCommit is ICommit, OwnableUpgradeable {
    function setUp(bytes memory _initializationParams) external initializer {
        (address _owner) = abi.decode(_initializationParams, (address));

        __Ownable_init();
        transferOwnership(_owner);
    }

    function getStrategyType() external view returns (StrategyTypes strategyType) {
        return StrategyTypes.Commit;
    }

    function commit(address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount) external payable {
        emit UserCommitted(user, user, tokenAddress, tokenId, tokenAmount);
    }

    function revoke(address user, address tokenAddress, uint256 tokenId, uint256 tokenAmount) external payable {
        emit UserWithdrawn(user, user, tokenAddress, tokenId, tokenAmount);
    }

    function getCommitments(address user) external view returns (Commitment[] memory commitments) {
        Commitment memory commitment = Commitment(user, address(0), 0, 0);

        commitments[0] = commitment;
    }

    function supportsInterface(bytes4 interfaceId) external view returns (bool) {
        return interfaceId == type(ICommit).interfaceId;
    }
}
