// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { ERC721Enumerable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import { ERC721URIStorage } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import { ERC721Pausable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC721Burnable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import { IERC6551Registry } from "./interfaces/IERC6551Registry.sol";
import { IWERKFactory } from "./interfaces/IWERKFactory.sol";

interface IAccountProxy {
    function initialize(address implementation) external;
}

/// @title WERK NFT
/// @notice The WERK NFT contract. When a workstream is minted, the contract creates a new account and a new WERK
/// instance.
/// @dev A clone of
contract WERKNFT is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Pausable, Ownable, ERC721Burnable {
    // https://docs.tokenbound.org/contracts/deployments
    address public constant ACCOUNT_REGISTRY = 0x000000006551c19487814612e58FE06813775758;
    address public constant ACCOUNT_PROXY = 0x55266d75D1a14E4572138116aF39863Ed6596E7F;
    address public constant ACCOUNT_IMPLEMENTATION = 0x41C8f39463A868d3A88af00cd0fe7102F30E44eC;
    address public immutable werkFactory;

    /// @dev Stores the next token ID.
    uint256 private _nextTokenId;

    /// @dev Maps token IDs to workstream instances.
    mapping(uint256 tokenId => address instance) public workstreams;

    /// @notice Creates a new instance of WERKNFT.
    /// @param _initialOwner The initial owner of the contract.
    /// @param _werkFactory The address of the werkFactory contract.
    constructor(address _initialOwner, address _werkFactory) ERC721("WERK", "WRK") Ownable(_initialOwner) {
        werkFactory = _werkFactory;
    }

    /// @notice Pauses targeted functions of the contract.
    function pause() public onlyOwner {
        _pause();
    }

    /// @notice Unpauses targeted functions of the contract.
    function unpause() public onlyOwner {
        _unpause();
    }

    /// @notice Mints a new workstream.
    /// @param to The address of the recipient of the workstream.
    /// @param uri The URI of the workstream.
    /// @param coordinationStrategyId The ID of the coordination strategy.
    /// @param commitmentStrategyId The ID of the commitment strategy.
    /// @param evaluationStrategyId The ID of the evaluation strategy.
    /// @param fundingStrategyId The ID of the funding strategy.
    /// @param payoutStrategyId The ID of the payout strategy.
    /// @return account The address of the account bound to the NFT.
    /// @return werkInstance The address of the werkInstance owned by the account.
    /// @return tokenId The token ID of the minted NFT.
    function mintWorkstream(
        address to,
        string memory uri,
        bytes32 coordinationStrategyId,
        bytes32 commitmentStrategyId,
        bytes32 evaluationStrategyId,
        bytes32 fundingStrategyId,
        bytes32 payoutStrategyId
    )
        public
        whenNotPaused
        returns (address account, address werkInstance, uint256 tokenId)
    {
        uint256 salt = 1_234_567_890; // hard code saltNonce for now
        tokenId = _nextTokenId++;
        account = IERC6551Registry(ACCOUNT_REGISTRY).createAccount(
            ACCOUNT_PROXY, bytes32(salt), block.chainid, address(this), tokenId
        );

        IAccountProxy(account).initialize(ACCOUNT_IMPLEMENTATION);

        bytes memory initializationParameters = abi.encode(
            account,
            tokenId,
            coordinationStrategyId,
            commitmentStrategyId,
            evaluationStrategyId,
            fundingStrategyId,
            payoutStrategyId
        );

        werkInstance = IWERKFactory(werkFactory).createWerkInstance(initializationParameters);

        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);

        workstreams[tokenId] = werkInstance;
    }

    /// @notice Updates the metadata of a workstream.
    /// @param tokenId The token ID of the workstream.
    /// @param uri The new URI of the workstream.
    function updateWorkstreamMetadata(uint256 tokenId, string memory uri) public {
        if (msg.sender != ownerOf(tokenId) || _isAuthorized(ownerOf(tokenId), msg.sender, tokenId)) {
            revert ERC721InvalidOperator(msg.sender);
        }
        _setTokenURI(tokenId, uri);
    }

    // The following functions are overrides required by Solidity.

    function _update(
        address to,
        uint256 tokenId,
        address auth
    )
        internal
        override(ERC721, ERC721Enumerable, ERC721Pausable)
        returns (address)
    {
        return super._update(to, tokenId, auth);
    }

    function _increaseBalance(address account, uint128 value) internal override(ERC721, ERC721Enumerable) {
        super._increaseBalance(account, value);
    }

    /// @inheritdoc ERC721
    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    /// @inheritdoc ERC721
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
