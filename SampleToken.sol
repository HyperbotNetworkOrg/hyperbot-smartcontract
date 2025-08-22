// SPDX-License-Identifier: MIT
pragma solidity ^0.8.10;

import "@openzeppelin/contracts@4.9.6/access/Ownable.sol";
import "@openzeppelin/contracts@4.9.6/token/ERC20/ERC20.sol";
import "./IFourERC20.sol";
import "./TransferMode.sol";

contract SampleToken is ERC20, Ownable, IFourERC20 {
    //
    // The controller who can change the transfer mode.
    //
    address public _transferController;

    //
    // The transfer mode includes
    // RESTRICTED  The transfer is disabled.  (Initial mode)
    // CONTROLLED  The transfer can only performed between transfer controller and token owner.
    // NORMAL      The transfer is enabled.
    //
    uint256 public _transferMode;

    event ChangeTransferController(address oldValue, address newValue);
    event ChangeTransferMode(uint256 oldValue, uint256 newValue);

    constructor(
        string memory name,
        string memory symbol,
        uint256 totalSupply
    ) ERC20(name, symbol) {
        _mint(owner(), totalSupply);
        _transferMode = TransferMode.RESTRICTED;
        _transferController = owner();
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);
        if (_transferMode == TransferMode.RESTRICTED) {
            revert("Transfer is restricted");
        }
        if (_transferMode == TransferMode.CONTROLLED) {
            require(from == _transferController || to == _transferController, "Invalid transfer");
        }
    }

    function isTransferController(address account) external view returns (bool) {
        return account == _transferController;
    }

    function setTransferMode(uint256 newValue) external {
        require(msg.sender == _transferController, "Caller is not the transfer controller");
        require(newValue <= TransferMode.MAX_VALUE, "Invalid mode");

        if (_transferMode != TransferMode.NORMAL) {
            uint256 oldValue = _transferMode;
            _transferMode = newValue;
            emit ChangeTransferMode(oldValue, newValue);
        }
    }

    function setTransferController(address newValue) external onlyOwner {
        address oldValue = _transferController;
        _transferController = newValue;
        emit ChangeTransferController(oldValue, newValue);
    }
}