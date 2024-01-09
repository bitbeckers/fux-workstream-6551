// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.23;

interface IWerkFactory {
    event WerkCreated(address indexed werk, bytes initializer);

    function setImplementation(address _werkImplementation) external;

    function createWerkInstance(bytes memory _initializer) external payable returns (address);
}
