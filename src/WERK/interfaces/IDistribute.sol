// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

interface IDistribute {
    function distribute(bytes memory payoutData) external payable;
}
