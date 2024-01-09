// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { ERC1155 } from "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { ERC1155Pausable } from "@openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol";
import { Base64 } from "@openzeppelin/contracts/utils/Base64.sol";
import { Strings } from "@openzeppelin/contracts/utils/Strings.sol";

import { IERC165 } from "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import { IERC721Receiver } from "@openzeppelin/contracts/interfaces/IERC721Receiver.sol";
import { IERC1155Receiver } from "@openzeppelin/contracts/interfaces/IERC1155Receiver.sol";

import { IFUX } from "./interfaces/IFUX.sol";
import { IFUXable } from "./interfaces/IFUXable.sol";

contract FUX is IFUX, ERC1155, Ownable, ERC1155Pausable {
    using Strings for uint256;

    uint256 public constant VFUX_TOKEN_ID = 0;
    uint256 public constant FUX_TOKEN_ID = 1;
    uint256 internal sbtTokenCounter = 2;

    mapping(uint256 id => address user) public sbtIds;

    /**
     * @dev This mapping keeps track of whether an address is a FUXer
     */
    mapping(address user => bool isFuxer) internal isFuxer;

    // solhint-disable-next-line no-empty-blocks
    constructor(address initialOwner) ERC1155("") Ownable(initialOwner) { }

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
        if (isFuxer[fuxUser]) revert UserAlreadyCreated();
        isFuxer[fuxUser] = true;
        uint256 sbtId = sbtTokenCounter;

        _mint(fuxUser, FUX_TOKEN_ID, 100, "");

        _mintSBT();

        emit UserCreated(operator, fuxUser, sbtId);
    }

    function giveFUX(address user, address workstream, uint256 amount) public isFuxable(workstream) {
        safeTransferFrom(user, workstream, FUX_TOKEN_ID, amount, "");

        emit FUXGiven(user, workstream, amount);
    }

    function takeFUX(address user, address workstream, uint256 amount) public isFuxable(workstream) {
        safeTransferFrom(workstream, user, FUX_TOKEN_ID, amount, "");

        emit FUXTaken(user, workstream, amount);
    }

    /**
     * @dev Mints FuxSBT to the caller
     * @notice This function can only be called once per address
     * @dev Emits a Fux
     */
    function _mintSBT() internal {
        if (sbtIds[sbtTokenCounter] != address(0)) revert UserAlreadyCreated();

        _mint(msg.sender, sbtTokenCounter, 1, "");

        sbtIds[sbtTokenCounter] = msg.sender;

        sbtTokenCounter += 1;
    }

    /**
     * @dev Constructs the SBT Uri
     * @param _tokenId The Id of the SBT to generate Uri for
     */
    function _constructTokenURI(uint256 _tokenId) internal view returns (string memory) {
        string memory _nftName = string(abi.encodePacked("FuxSBT"));
        address _owner = sbtIds[_tokenId];
        string memory _image = string(
            abi.encodePacked(
                "ipfs://QmNXwWzzZGvS3sp9JChSArdrZ7p8eo7QjBiW499yBBXRD3?vfux=",
                Strings.toString(ERC1155(address(this)).balanceOf(_owner, 0)),
                "&percentage=",
                Strings.toString(100 - ERC1155(address(this)).balanceOf(_owner, 1)),
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

    // The following functions are overrides required by Solidity.

    function _update(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory values
    )
        internal
        override(ERC1155, ERC1155Pausable)
    {
        super._update(from, to, ids, values);
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

    modifier isFuxable(address _contract) {
        require(IERC165(_contract).supportsInterface(type(IFUXable).interfaceId), "FUX: Not FUXable");
        _;
    }
}
