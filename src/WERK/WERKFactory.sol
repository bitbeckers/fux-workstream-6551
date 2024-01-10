// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.23;

import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { ICommit } from "./interfaces/ICommit.sol";
import { IWERKFactory } from "./interfaces/IWERKFactory.sol";
import { IStrategyRegistry } from "./interfaces/IStrategyRegistry.sol";

import { WERKImplementation } from "./WERKImplementation.sol";

interface IInit {
    function setUp(bytes memory _initializationParams) external;
}

contract WERKFactory is IWERKFactory, Ownable {
    address internal _werkImplementation;
    address internal _strategyRegistry;

    /*solhint-disable no-empty-blocks*/
    constructor(address initialOwner, address werkImplementation, address strategyRegistry) Ownable(initialOwner) {
        _werkImplementation = werkImplementation;
        _strategyRegistry = strategyRegistry;
    }

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
            bytes32 _fundingStrategy,
            bytes32 _payoutStrategy
        ) = abi.decode(_initializer, (address, bytes32, bytes32, bytes32, bytes32, bytes32));

        address commitmentStrategy = Clones.clone(strategyRegistry.getStrategy(_commitmentStrategy).implementation);
        address coordinationStrategy = Clones.clone(strategyRegistry.getStrategy(_coordinationStrategy).implementation);
        address evaluationStrategy = Clones.clone(strategyRegistry.getStrategy(_evaluationStrategy).implementation);
        address fundingStrategy = Clones.clone(strategyRegistry.getStrategy(_fundingStrategy).implementation);
        address payoutStrategy = Clones.clone(strategyRegistry.getStrategy(_payoutStrategy).implementation);

        IInit(commitmentStrategy).setUp(abi.encode(_owner));
        IInit(coordinationStrategy).setUp(abi.encode(_owner));
        IInit(evaluationStrategy).setUp(abi.encode(_owner));
        IInit(fundingStrategy).setUp(abi.encode(_owner));
        IInit(payoutStrategy).setUp(abi.encode(_owner, fundingStrategy));

        bytes memory initParams = abi.encode(
            _owner, commitmentStrategy, coordinationStrategy, evaluationStrategy, fundingStrategy, payoutStrategy
        );

        werkInstance.setUp(initParams);

        emit WerkCreated(
            address(werkInstance),
            coordinationStrategy,
            commitmentStrategy,
            evaluationStrategy,
            fundingStrategy,
            payoutStrategy
        );

        return address(werkInstance);
    }
}
