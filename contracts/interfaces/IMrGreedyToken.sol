// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IMrGreedyToken {
    function treasury() external view returns (address);

    function getResultingTransferAmount(uint256 amount_) external view returns (uint256);
}
