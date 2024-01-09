// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { ICommit } from "../../interfaces/ICommit.sol";
import { IFUXable } from "../../../FUX/interfaces/IFUXable.sol";
import { OwnableUpgradeable } from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import { ERC1155HolderUpgradeable } from
    "@openzeppelin/contracts-upgradeable/token/ERC1155/utils/ERC1155HolderUpgradeable.sol";
import { ERC165Checker } from "@openzeppelin/contracts/utils/introspection/ERC165Checker.sol";

contract FUXStaking is ICommit, IFUXable, ERC1155HolderUpgradeable, OwnableUpgradeable {
    address public immutable fuxContract;

    /// @custom:oz-upgrades-unsafe-allow constructor
    constructor(address _fux) {
        fuxContract = _fux;
        _disableInitializers();
    }

    function setUp(bytes memory _initializationParams) public virtual initializer {
        (address _workstreamAccount) = abi.decode(_initializationParams, (address));

        __ERC1155Holder_init();
        __Ownable_init(_workstreamAccount);
    }

    function commit(address user, address tokenAddress, uint256 tokenAmount) external payable {
        if (tokenAddress != fuxContract) {
            revert TokenNotAccepted();
        }
        giveFUX(user, address(this), tokenAmount);
    }

    function revoke(address user, address tokenAddress, uint256 tokenAmount) external payable {
        if (tokenAddress != fuxContract) {
            revert TokenNotAccepted();
        }
        takeFUX(user, address(this), tokenAmount);
    }

    function giveFUX(address user, address workstream, uint256 fuxGiven) public override {
        IFUXable(fuxContract).giveFUX(user, workstream, fuxGiven);

        emit UserCommitted(workstream, user, fuxContract, fuxGiven);
    }

    function takeFUX(address user, address workstream, uint256 fuxTaken) public override {
        IFUXable(fuxContract).takeFUX(user, workstream, fuxTaken);

        emit UserWithdrawn(workstream, user, fuxContract, fuxTaken);
    }

    modifier isFuxable(address _contract) {
        require(ERC165Checker.supportsInterface(_contract, type(IFUXable).interfaceId), "FUX: Not FUXable");
        _;
    }
}
