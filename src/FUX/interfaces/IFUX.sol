// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IFUXable } from "./IFUXable.sol";
import "@openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol";

interface IFUX is IFUXable {
    error NotAllowed();
    error UserAlreadyCreated();

    /**
     * @dev This event is emitted when a new FUX SBT is minted
     * @param operator The address that minted the FUX SBT.
     * @param user The address associated with the FUX SBT.
     * @param sbtID The ID of the newly minted FUX SBT.
     */
    event UserCreated(address operator, address user, uint256 sbtID);

    function mint(address operator, address fuxUser) external;
}
