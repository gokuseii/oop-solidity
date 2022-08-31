// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interfaces/IContractsHaterToken.sol";
import "./SimpleToken.sol";

contract ContractsHaterToken is SimpleToken, IContractsHaterToken {
    mapping(address => bool) whitelist;

    constructor(string memory name_, string memory symbol_)
        SimpleToken(name_, symbol_)
    {}

    function addToWhitelist(address candidate_) external {
        require(msg.sender == owner(), "Only owner can do this");

        whitelist[candidate_] = true;
    }

    function removeFromWhitelist(address candidate_) external {
        require(msg.sender == owner(), "Only owner can do this");

        whitelist[candidate_] = false;
    }

    function isInWhitelist(address candidate_) public view returns (bool) {
        return whitelist[candidate_];
    }

    function isContract(address address_) public view returns (bool) {
        uint32 size;
        assembly {
            size := extcodesize(address_)
        }
        return (size > 0);
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual override {
        super._beforeTokenTransfer(from, to, amount);
        // проверяем не является ли это минтом, либо сжиганием
        if (from != address(0) && to != address(0))
            if (isContract(to) && !isInWhitelist(to))
                // если получатель это контракт, то проверяем его на вайтлист
                revert(
                    "ContractsHaterToken: Contract address not in the whitelist"
                );
    }
}
