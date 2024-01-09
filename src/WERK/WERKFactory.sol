// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.23;

import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { IWERKFactory } from "./interfaces/IWERKFactory.sol";
import { IStrategyRegistry } from "./interfaces/IStrategyRegistry.sol";

import { WERKImplementation } from "./WERKImplementation.sol";

contract WERKFactory is IWERKFactory, Ownable {
    address internal _werkImplementation;
    address internal _strategyRegistry;

    /*solhint-disable no-empty-blocks*/
    constructor(address initialOwner) Ownable(initialOwner) { }

    function currentImplementation() public view returns (address) {
        return _werkImplementation;
    }

    function setImplementation(address _implementation) public onlyOwner {
        _werkImplementation = _implementation;
        emit WerkImplementationUpdated(_implementation);
    }

    function setStrategyRegistry(address _registry) public onlyOwner {
        _strategyRegistry = _registry;
        emit StrategyRegistryUpdated(_strategyRegistry);
    }

    function createWerkInstance(bytes memory _initializer) public payable returns (address) {
        WERKImplementation werkInstance = WERKImplementation(Clones.clone(_werkImplementation));
        IStrategyRegistry strategyRegistry = IStrategyRegistry(_strategyRegistry);

        // _initializationParams = abi.encode(
        // address _owner,
        // bytes32 _commitmentStrategy,
        // bytes32 _coordinationStrategy,
        // bytes32 _evaluationStrategy,
        // bytes32 _fundingStrategy,
        // )
        (
            address _owner,
            bytes32 _commitmentStrategy,
            bytes32 _coordinationStrategy,
            bytes32 _evaluationStrategy,
            bytes32 _fundingStrategy
        ) = abi.decode(_initializer, (address, bytes32, bytes32, bytes32, bytes32));

        address commitmentStrategy = Clones.clone(strategyRegistry.getStrategy(_commitmentStrategy).implementation);
        address coordinationStrategy = Clones.clone(strategyRegistry.getStrategy(_coordinationStrategy).implementation);
        address evaluationStrategy = Clones.clone(strategyRegistry.getStrategy(_evaluationStrategy).implementation);
        address fundingStrategy = Clones.clone(strategyRegistry.getStrategy(_fundingStrategy).implementation);

        werkInstance.setUp(
            abi.encode(_owner, commitmentStrategy, coordinationStrategy, evaluationStrategy, fundingStrategy)
        );

        emit WerkCreated(
            address(werkInstance),
            _initializer,
            coordinationStrategy,
            commitmentStrategy,
            evaluationStrategy,
            fundingStrategy
        );

        return address(werkInstance);
    }
}
