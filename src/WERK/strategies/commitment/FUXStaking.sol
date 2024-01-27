// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { ICommit } from "../../interfaces/ICommit.sol";
import { IFUXable } from "../../../FUX/interfaces/IFUXable.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

import { ERC1155HolderUpgradeable } from
    "@openzeppelin/contracts-upgradeable/token/ERC1155/utils/ERC1155HolderUpgradeable.sol";
import { ERC165Checker } from "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";

import { CallFailed, UnsupportedToken, UnsupportedWorkstream } from "../../libraries/Errors.sol";
import { Commitment } from "../../libraries/Structs.sol";

contract FUXStaking is ICommit, IFUXable, ERC1155HolderUpgradeable, OwnableUpgradeable {
    address public immutable FUX_CONTRACT;
    mapping(address user => uint256 fuxStaked) public fuxStaked;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor(address _fuxContract) {
        FUX_CONTRACT = _fuxContract;

        _disableInitializers();
    }

    function setUp(bytes memory _initializationParams) public virtual initializer {
        (address _owner) = abi.decode(_initializationParams, (address));

        __ERC1155Holder_init();
        __Ownable_init(_owner);
    }

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

    function giveFUX(address user, address workstream, uint256 fuxGiven) public override isFuxable(FUX_CONTRACT) {
        if (workstream != address(this)) revert UnsupportedWorkstream();

        IFUXable(FUX_CONTRACT).giveFUX(user, workstream, fuxGiven);

        fuxStaked[user] += fuxGiven;

        emit UserCommitted(workstream, user, FUX_CONTRACT, 1, fuxGiven);
    }

    function takeFUX(address user, address workstream, uint256 fuxTaken) public override isFuxable(FUX_CONTRACT) {
        if (workstream != address(this)) revert UnsupportedWorkstream();

        IFUXable(FUX_CONTRACT).takeFUX(user, workstream, fuxTaken);

        fuxStaked[user] -= fuxTaken;

        emit UserWithdrawn(workstream, user, FUX_CONTRACT, 1, fuxTaken);
    }

    function getCommitments(address user) external view override returns (Commitment[] memory) {
        Commitment[] memory commitments = new Commitment[](1);
        commitments[0] = Commitment(user, FUX_CONTRACT, 0, fuxStaked[user]);
        return commitments;
    }

    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return interfaceId == type(IFUXable).interfaceId || super.supportsInterface(interfaceId);
    }

    modifier isFuxable(address _contract) {
        require(ERC165Checker.supportsInterface(_contract, type(IFUXable).interfaceId), "FUX: Not FUXable");
        _;
    }
}
