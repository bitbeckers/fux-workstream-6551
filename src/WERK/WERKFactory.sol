// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.23;

import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";
import { IERC20 } from "@openzeppelin/contracts/interfaces/IERC20.sol";

import { IWerkFactory } from "./interfaces/IWERKFactory.sol";

import { WERKImplementation } from "./WERKImplementation.sol";

contract WerkFactory is IWERKFactory, Ownable {
    WERKImplementation internal werkImplementation;

    event WerkCreated(address indexed werk, bytes initializer);

    /*solhint-disable no-empty-blocks*/
    constructor() { }

    // must be called after deploy to set libraries
    function setImplementation(address _werkImplementation) public onlyOwner {
        werkImplementation = WERKImplementation(_werkImplementation);
    }

    function createWerkInstance(bytes memory _initializer) public payable returns (address) {
        WERKImplementation werkInstance = Clones.clone(werkImplementation);

        werkInstance.setUp(_initializationParams);

        emit WerkCreated(werkInstance, _initializer);

        return address(werkInstance);
    }
}
