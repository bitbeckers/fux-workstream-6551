// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IDistribute {
    event Distributed(address operator, bytes payoutData);

    function distribute(bytes memory payoutData) external payable;
}
