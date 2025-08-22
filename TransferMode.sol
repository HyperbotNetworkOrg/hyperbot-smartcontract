// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

library TransferMode {
    uint256 public constant NORMAL = 0;
    uint256 public constant RESTRICTED = 1;
    uint256 public constant CONTROLLED = 2;
    uint256 public constant MAX_VALUE = 2;
}