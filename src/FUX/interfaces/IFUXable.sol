// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IFUXable {
    event FUXGiven(address user, address workstream, uint256 fuxGiven);
    event FUXTaken(address user, address workstream, uint256 fuxTaken);

    error GiveFUXFailed();
    error TakeFUXFailed();

    function giveFUX(address user, address workstream, uint256 fuxGiven) external;

    function takeFUX(address user, address workstream, uint256 fuxTaken) external;
}
