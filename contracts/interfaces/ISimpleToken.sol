// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface ISimpleToken {
    function mint(address to_, uint256 amount_) external;

    function burn(uint256 amount_) external;
}
