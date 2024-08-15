// SPDX-License-Identifier: Unlicense
pragma solidity 0.8.23;

/// @title IWERKFactory
/// @dev This interface provides methods for creating WERK instances and updating the WERK implementation and strategy
/// registry.
interface IWERKFactory {
    /// @notice This event is emitted when a workstream is created.
    /// @param owner The owner of the workstream.
    /// @param werk The address of the WERK instance.
    /// @param tokenId The token ID of the workstream.
    /// @param commitmentStrategy The address of the commitment strategy.
    /// @param coordinationStrategy The address of the coordination strategy.
    /// @param evaluationStrategy The address of the evaluation strategy.
    /// @param fundingStrategy The address of the funding strategy.
    /// @param payoutStrategy The address of the payout strategy.
    event WorkstreamCreated(
        address owner,
        address werk,
        uint256 tokenId,
        address commitmentStrategy,
        address coordinationStrategy,
        address evaluationStrategy,
        address fundingStrategy,
        address payoutStrategy
    );

    /// @notice This event is emitted when the WERK implementation is updated.
    /// @param implementation The address of the new WERK implementation.
    event WerkImplementationUpdated(address implementation);

    /// @notice This event is emitted when the strategy registry is updated.
    /// @param strategyRegistry The address of the new strategy registry.
    event StrategyRegistryUpdated(address strategyRegistry);

    /// @notice Sets the WERK implementation.
    /// @param _werkImplementation The address of the new WERK implementation.
    function setImplementation(address _werkImplementation) external;

    /// @notice Sets the strategy registry.
    /// @param _strategyRegistry The address of the new strategy registry.
    function setStrategyRegistry(address _strategyRegistry) external;

    /// @notice Creates a new WERK instance.
    /// @param _initializer The data to initialize the WERK instance with.
    /// @return werkInstance The address of the new WERK instance.
    function createWerkInstance(bytes memory _initializer) external payable returns (address werkInstance);
}
