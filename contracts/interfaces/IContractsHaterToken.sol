// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

interface IContractsHaterToken {
    function addToWhitelist(address candidate_) external;

    function removeFromWhitelist(address candidate_) external;
}
