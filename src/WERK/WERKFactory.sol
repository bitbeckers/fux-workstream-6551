// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.23;

import { Clones } from "@openzeppelin/contracts/proxy/Clones.sol";
import { Ownable } from "@openzeppelin/contracts/access/Ownable.sol";

import { IWERKFactory } from "./interfaces/IWERKFactory.sol";
import { IWERKStrategy } from "./interfaces/IWERKStrategy.sol";
import { IStrategyRegistry } from "./interfaces/IStrategyRegistry.sol";

import { WERKImplementation } from "./WERKImplementation.sol";

/// @title WERKFactory
/// @dev This contract allows the owner to create WERK instances and update the WERK implementation and strategy
/// registry.
contract WERKFactory is IWERKFactory, Ownable {
    /// @dev The address of the current WERK implementation.
    address internal _werkImplementation;
    /// @dev The address of the strategy registry.
    address internal _strategyRegistry;

    /// @notice Creates a new instance of WERKFactory.
    /// @param initialOwner The initial owner of the contract.
    /// @param werkImplementation The address of the initial WERK implementation.
    /// @param strategyRegistry The address of the strategy registry.
    constructor(address initialOwner, address werkImplementation, address strategyRegistry) Ownable(initialOwner) {
        _werkImplementation = werkImplementation;
        _strategyRegistry = strategyRegistry;
    }

    /// @notice Gets the current WERK implementation.
    /// @return The address of the current WERK implementation.
    function currentImplementation() public view returns (address) {
        return _werkImplementation;
    }

    /// @notice Can only be called by the contract owner.
    /// @inheritdoc IWERKFactory
    function setImplementation(address _implementation) public onlyOwner {
        _werkImplementation = _implementation;
        emit WerkImplementationUpdated(_implementation);
    }

    /// @notice Can only be called by the contract owner.
    /// @inheritdoc IWERKFactory
    function setStrategyRegistry(address _registry) public onlyOwner {
        _strategyRegistry = _registry;
        emit StrategyRegistryUpdated(_strategyRegistry);
    }

    /// @notice The function clones the current WERK implementation and the strategies specified in the initializer.
    /// @inheritdoc IWERKFactory
    function createWerkInstance(bytes memory _initializer) public payable returns (address werkInstance) {
        werkInstance = Clones.clone(_werkImplementation);
        IStrategyRegistry strategyRegistry = IStrategyRegistry(_strategyRegistry);

        /// Get config
        (
            address _owner,
            uint256 _tokenId,
            bytes32 _commitmentStrategy,
            bytes32 _coordinationStrategy,
            bytes32 _evaluationStrategy,
            bytes32 _fundingStrategy,
            bytes32 _payoutStrategy
        ) = abi.decode(_initializer, (address, uint256, bytes32, bytes32, bytes32, bytes32, bytes32));

        /// Clone strategies
        address commitmentStrategy = Clones.clone(strategyRegistry.getStrategy(_commitmentStrategy).implementation);
        address coordinationStrategy = Clones.clone(strategyRegistry.getStrategy(_coordinationStrategy).implementation);
        address evaluationStrategy = Clones.clone(strategyRegistry.getStrategy(_evaluationStrategy).implementation);
        address fundingStrategy = Clones.clone(strategyRegistry.getStrategy(_fundingStrategy).implementation);
        address payoutStrategy = Clones.clone(strategyRegistry.getStrategy(_payoutStrategy).implementation);

        /// Set up strategies
        IWERKStrategy(commitmentStrategy).setUp(abi.encode(_owner));
        IWERKStrategy(coordinationStrategy).setUp(abi.encode(_owner));
        IWERKStrategy(evaluationStrategy).setUp(abi.encode(_owner));
        IWERKStrategy(fundingStrategy).setUp(abi.encode(_owner));
        IWERKStrategy(payoutStrategy).setUp(abi.encode(_owner, fundingStrategy));

        /// Set up werk instance
        bytes memory initParams = abi.encode(
            _owner, commitmentStrategy, coordinationStrategy, evaluationStrategy, fundingStrategy, payoutStrategy
        );

        WERKImplementation(werkInstance).setUp(initParams);

        emit WorkstreamCreated(
            _owner,
            werkInstance,
            _tokenId,
            coordinationStrategy,
            commitmentStrategy,
            evaluationStrategy,
            fundingStrategy,
            payoutStrategy
        );
    }
}
