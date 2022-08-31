// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "./interfaces/ISimpleToken.sol";

contract SimpleToken is ERC20, Ownable, ISimpleToken {
    constructor(string memory name_, string memory symbol_)
        ERC20(name_, symbol_)
    {}

    function mint(address to_, uint256 amount_) external {
        require(msg.sender == owner(), "Only owner can do this");

        _mint(to_, amount_);
    }

    function burn(uint256 amount_) external {
        _burn(msg.sender, amount_);
    }
}
