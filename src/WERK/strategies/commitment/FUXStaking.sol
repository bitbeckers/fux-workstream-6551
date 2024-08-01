// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { ICommit } from "../../interfaces/ICommit.sol";
import { IFUXable } from "../../../FUX/interfaces/IFUXable.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import { ERC1155HolderUpgradeable } from
    "@openzeppelin/contracts-upgradeable/token/ERC1155/utils/ERC1155HolderUpgradeable.sol";
import { ERC1155ReceiverUpgradeable } from
    "@openzeppelin/contracts-upgradeable/token/ERC1155/utils/ERC1155ReceiverUpgradeable.sol";
import { ERC165Checker } from "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";

import { UnsupportedWorkstream } from "../../libraries/Errors.sol";
import { Commitment } from "../../libraries/Structs.sol";
import { StrategyTypes } from "../../libraries/Enums.sol";

import { IERC165 } from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import { IWERKStrategy } from "../../interfaces/IWERKStrategy.sol";

/// @title FUXStaking
/// @dev This contract allows users to stake FUX tokens.
contract FUXStaking is ICommit, IFUXable, ERC1155HolderUpgradeable, OwnableUpgradeable {
    /// @dev The address of the FUX token contract.
    address public immutable fuxContract;
    /// @dev A mapping to keep track of the amount of FUX tokens staked by each user.
    mapping(address => uint256) public fuxStaked;

    /// @notice Initializes the contract with the address of the FUX token contract.
    /// @param _fuxContract The address of the FUX token contract.
    constructor(address _fuxContract) {
        fuxContract = _fuxContract;

        _disableInitializers();
    }

    /// @inheritdoc IWERKStrategy
    function setUp(bytes memory _initializationParams) public virtual initializer {
        (address _owner) = abi.decode(_initializationParams, (address));

        __ERC1155Holder_init();
        __Ownable_init();
    }

    /// @notice Allows a user to stake FUX tokens.
    /// @dev Wrapper for the giveFUX function.
    /// @param user The address of the user.
    /// @param tokenAmount The amount of FUX tokens to stake.
    /// @inheritdoc ICommit
    function commit(
        address user,
        address, /* tokenAddress */
        uint256, /* tokenId */
        uint256 tokenAmount
    )
        external
        payable
    {
        FUXStaking.giveFUX(user, address(this), tokenAmount);
    }

    /// @notice Allows a user to unstake FUX tokens.
    /// @dev Wrapper for the takeFUX function.
    /// @param user The address of the user.
    /// @param tokenAmount The amount of FUX tokens to unstake.
    /// @inheritdoc ICommit
    function revoke(
        address user,
        address, /* tokenAddress */
        uint256, /* tokenId */
        uint256 tokenAmount
    )
        external
        payable
    {
        FUXStaking.takeFUX(user, address(this), tokenAmount);
    }

    /// @notice Allows a user to stake FUX tokens.
    /// @dev The function transfers the specified amount of FUX tokens from the user to the contract.
    /// @param user The address of the user.
    /// @param workstream The address of the workstream.
    /// @param fuxGiven The amount of FUX tokens to stake.
    /// @inheritdoc IFUXable
    function giveFUX(address user, address workstream, uint256 fuxGiven) public override {
        if (workstream != address(this)) revert UnsupportedWorkstream();

        IFUXable(fuxContract).giveFUX(user, workstream, fuxGiven);

        fuxStaked[user] += fuxGiven;

        emit UserCommitted(workstream, user, fuxContract, 1, fuxGiven);
    }

    /// @notice Allows a user to unstake FUX tokens.
    /// @dev The function transfers the specified amount of FUX tokens from the contract back to the user.
    /// @param user The address of the user.
    /// @param workstream The address of the workstream.
    /// @param fuxTaken The amount of FUX tokens to unstake.
    /// @inheritdoc IFUXable
    function takeFUX(address user, address workstream, uint256 fuxTaken) public override {
        if (workstream != address(this)) revert UnsupportedWorkstream();

        IFUXable(fuxContract).takeFUX(user, workstream, fuxTaken);

        fuxStaked[user] -= fuxTaken;

        emit UserWithdrawn(workstream, user, fuxContract, 1, fuxTaken);
    }

    /// @inheritdoc ICommit
    function getCommitments(address user) external view override returns (Commitment[] memory commitments) {
        commitments = new Commitment[](1);
        commitments[0] = Commitment(user, fuxContract, 0, fuxStaked[user]);
        return commitments;
    }

    /// @inheritdoc IWERKStrategy
    function getStrategyType() external pure override returns (StrategyTypes strategyType) {
        strategyType = StrategyTypes.Commit;
    }

    /// @notice Checks interface compatibility.
    /// @inheritdoc IERC165
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC1155ReceiverUpgradeable, IERC165)
        returns (bool)
    {
        return interfaceId == type(IFUXable).interfaceId || interfaceId == type(ICommit).interfaceId
            || super.supportsInterface(interfaceId);
    }
}
