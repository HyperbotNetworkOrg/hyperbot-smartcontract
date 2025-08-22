// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.9.6/token/ERC20/IERC20.sol";

interface IFourERC20 is IERC20 {
    function isTransferController(address account) external returns (bool);
    function setTransferMode(uint256) external;
}