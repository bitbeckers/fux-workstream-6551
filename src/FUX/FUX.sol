// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC1155 } from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import { ERC1155Pausable } from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

import { IERC165 } from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import { IERC721Receiver } from "@openzeppelin/contracts/interfaces/IERC721Receiver.sol";
import { IERC1155Receiver } from "@openzeppelin/contracts/interfaces/IERC1155Receiver.sol";

import { IFUX } from "./interfaces/IFUX.sol";
import { IFUXable } from "./interfaces/IFUXable.sol";

contract FUX is IFUX, ERC1155Pausable, Ownable {
    using Strings for uint256;

    uint256 public constant VFUX_TOKEN_ID = 0;
    uint256 public constant FUX_TOKEN_ID = 1;
    uint256 internal sbtTokenCounter = 2;

    mapping(uint256 id => address user) public sbtUserAddress;
    mapping(address user => uint256 sbtId) public userSbtId;

    /**
     * @dev This mapping keeps track of whether an address is a FUXer
     */
    mapping(address user => bool isFuxer) internal _isFuxer;

    // solhint-disable-next-line no-empty-blocks
    constructor(address initialOwner) ERC1155("FUX") Ownable() { }

    function setURI(string memory newuri) public onlyOwner {
        _setURI(newuri);
    }

    function pause() public onlyOwner {
        _pause();
    }

    function unpause() public onlyOwner {
        _unpause();
    }

    function mint(address operator, address fuxUser) public {
        if (_isFuxer[fuxUser]) revert UserAlreadyCreated();
        _isFuxer[fuxUser] = true;
        uint256 sbtId = sbtTokenCounter;

        _mint(fuxUser, FUX_TOKEN_ID, 100, "");

        _mintSBT();

        emit UserCreated(operator, fuxUser, sbtId);
    }

    function giveFUX(address user, address workstream, uint256 amount) public {
        if (!supportsInterface(type(IFUXable).interfaceId)) revert UnsupportedWorkstream();

        safeTransferFrom(user, workstream, FUX_TOKEN_ID, amount, "");

        emit FUXGiven(user, workstream, amount);
    }

    function takeFUX(address user, address workstream, uint256 amount) public {
        if (!supportsInterface(type(IFUXable).interfaceId)) revert UnsupportedWorkstream();

        safeTransferFrom(workstream, user, FUX_TOKEN_ID, amount, "");

        emit FUXTaken(user, workstream, amount);
    }

    function isFuxer(address user) public view returns (bool) {
        return _isFuxer[user];
    }

    /**
     * @dev Returns the URI for a given token ID
     * @param tokenId The ID of the token
     * @return The URI for the given token ID
     */
    function uri(uint256 tokenId) public view override returns (string memory) {
        if (tokenId > 1) {
            return _constructTokenURI(tokenId);
        }
        return ERC1155.uri(tokenId);
    }

    /**
     * @dev Mints FuxSBT to the caller
     * @notice This function can only be called once per address
     * @dev Emits a Fux
     */
    function _mintSBT() internal {
        if (userSbtId[msg.sender] != 0) revert UserAlreadyCreated();

        _mint(msg.sender, sbtTokenCounter, 1, "");

        sbtUserAddress[sbtTokenCounter] = msg.sender;
        userSbtId[msg.sender] = sbtTokenCounter;

        sbtTokenCounter += 1;
    }

    /**
     * @dev Constructs the SBT Uri
     * @param _tokenId The Id of the SBT to generate Uri for
     */
    function _constructTokenURI(uint256 _tokenId) internal view returns (string memory) {
        string memory _nftName = string(abi.encodePacked("FuxSBT"));
        address _owner = sbtUserAddress[_tokenId];
        string memory _image = string(
            abi.encodePacked(
                uri(2),
                "?vfux=",
                Strings.toString(ERC1155Pausable(address(this)).balanceOf(_owner, 0)),
                "&percentage=",
                Strings.toString(100 - ERC1155Pausable(address(this)).balanceOf(_owner, 1)),
                "&address=",
                Strings.toHexString(_owner)
            )
        );

        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(
                    bytes(
                        abi.encodePacked(
                            "{\"name\":\"",
                            _nftName,
                            "\", \"image\":\"",
                            _image,
                            "\", \"description\": \"How many FUX do you give?\"",
                            "\", \"attributes\": [{\"trait_type\": \"base\", \"value\": \"FUX\"}]}"
                        )
                    )
                )
            )
        );
    }

    // Receiver functions

    function onERC721Received(address, address, uint256, bytes memory) external pure returns (bytes4) {
        return IERC721Receiver.onERC721Received.selector;
    }

    function onERC1155Received(address, address, uint256, uint256, bytes memory) external pure returns (bytes4) {
        return IERC1155Receiver.onERC1155Received.selector;
    }

    function onERC1155BatchReceived(
        address,
        address,
        uint256[] memory,
        uint256[] memory,
        bytes memory
    )
        external
        pure
        returns (bytes4)
    {
        return IERC1155Receiver.onERC1155BatchReceived.selector;
    }

    function supportsInterface(bytes4 interfaceId) public view override returns (bool) {
        return interfaceId == type(IFUXable).interfaceId || super.supportsInterface(interfaceId);
    }

    function _beforeTokenTransfer(
        address operator,
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory data
    )
        internal
        override(ERC1155Pausable)
    {
        super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
    }
}
