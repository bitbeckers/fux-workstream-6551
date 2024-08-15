// SPDX-License-Identifier: MIT

pragma solidity ^0.8.23;

/// @notice This error is emitted when a call to a function fails.
error CallFailed(bytes returnData);

/// @notice This error is emitted when a delegate call to a function fails.
error DelegateCallFailed(bytes returnData);

/// @notice This error is emitted when there are insufficient funds for a transaction.
error InsufficientFunds();

/// @notice This error is emitted when an action is not allowed or approved.
error NotAllowedOrApproved();

/// @notice This error is emitted when an action is not approved or the caller is not the owner.
error NotApprovedOrOwner();

/// @notice This error is emitted when a token is not supported.
error UnsupportedToken();

/// @notice This error is emitted when a workstream is not supported.
error UnsupportedWorkstream();
