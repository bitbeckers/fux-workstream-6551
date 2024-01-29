// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import { IWERKStrategy } from "./IWERKStrategy.sol";

interface IDistribute is IWERKStrategy {
    event Distributed(address operator, bytes payoutData);

    function distribute(bytes memory payoutData) external payable;
}
