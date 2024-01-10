// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { ERC721 } from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import { ERC721Enumerable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import { ERC721URIStorage } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import { ERC721Pausable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC721Burnable } from "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import { IERC6551Registry } from "./interfaces/IERC6551Registry.sol";
import { IWERK } from "./interfaces/IWERK.sol";
import { IWERKFactory } from "./interfaces/IWERKFactory.sol";

interface IAccountProxy {
    function initialize(address implementation) external;
}

contract WERKNFT is ERC721, ERC721Enumerable, ERC721URIStorage, ERC721Pausable, Ownable, ERC721Burnable {
    // https://docs.tokenbound.org/contracts/deployments
    address public constant ACCOUNT_REGISTRY = 0x000000006551c19487814612e58FE06813775758;
    address public constant ACCOUNT_PROXY = 0x55266d75D1a14E4572138116aF39863Ed6596E7F;
    address public constant ACCOUNT_IMPLEMENTATION = 0x41C8f39463A868d3A88af00cd0fe7102F30E44eC;
    address public immutable werkFactory;

    uint256 private _nextTokenId;

    // struct WerkInfo {
    //     address owner;
    //     bytes32 coordinationStrategyId;
    //     bytes32 commitmentStrategyId;
    //     bytes32 evaluationStrategyId;
    //     bytes32 fundingStrategyId;
    //     WorkstreamStatus status;
    // }
    mapping(uint256 tokenId => IWERK.WerkInfo workstream) public workstreams;

    constructor(address _initialOwner, address _werkFactory) ERC721("WERK", "WRK") Ownable(_initialOwner) {
        werkFactory = _werkFactory;
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

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
        returns (address account, uint256 tokenId)
    {
        uint256 salt = 1_234_567_890; // hard code saltNonce for now
        tokenId = _nextTokenId++;
        account = IERC6551Registry(ACCOUNT_REGISTRY).createAccount(
            ACCOUNT_PROXY, bytes32(salt), block.chainid, address(this), tokenId
        );

        IAccountProxy(account).initialize(ACCOUNT_IMPLEMENTATION);

        // _initializationParams = abi.encode(
        // address _owner,
        // bytes32 _coordinationStrategyId,
        // bytes32 _commitmentStrategyId,
        // bytes32 _evaluationStrategyId,
        // bytes32 _fundingStrategyId,
        // bytes32 _payoutStrategyId
        // )
        bytes memory initializationParameters = abi.encode(
            to, coordinationStrategyId, commitmentStrategyId, evaluationStrategyId, fundingStrategyId, payoutStrategyId
        );

        address werkInstance = IWERKFactory(werkFactory).createWerkInstance(initializationParameters);

        _safeMint(msg.sender, tokenId);
        _setTokenURI(tokenId, uri);

        emit IWERK.WorkstreamCreated(account, werkInstance, tokenId);
    }

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

    function tokenURI(uint256 tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721Enumerable, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
