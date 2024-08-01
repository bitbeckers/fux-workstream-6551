// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IWERKStrategy } from "./IWERKStrategy.sol";

/**
 * @title IDistribute
 * @dev Interface for the distribute contract.
 */
interface IDistribute is IWERKStrategy {
    /**
     * @dev Emitted when a distribution occurs.
     * @param operator The address of the operator performing the distribution.
     * @param payoutData The payout data associated with the distribution.
     */
    event Distributed(address operator, bytes payoutData);

    /**
     * @dev Distributes funds according to the specified payout data.
     * @param payoutData The payout data specifying how the funds should be distributed.
     */
    function distribute(bytes memory payoutData) external payable;
}
