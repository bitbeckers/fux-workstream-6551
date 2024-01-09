// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.23;

interface IWERKFactory {
    event WerkCreated(
        address indexed werk,
        bytes initializer,
        address commitmentStrategy,
        address coordinationStrategy,
        address evaluationStrategy,
        address fundingStrategy
    );
    event WerkImplementationUpdated(address indexed implementation);

    event StrategyRegistryUpdated(address indexed strategyRegistry);

    function setImplementation(address _werkImplementation) external;
    function setStrategyRegistry(address _strategyRegistry) external;

    function createWerkInstance(bytes memory _initializer) external payable returns (address);
}
