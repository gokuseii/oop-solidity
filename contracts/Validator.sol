// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interfaces/ISimpleToken.sol";
import "./interfaces/IMrGreedyToken.sol";
import "./interfaces/IContractsHaterToken.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract Empty {}

contract Validator {
    address constant randomAddress1 = 0xa000000000000000000000000000000000000000;
    address constant randomAddress2 = 0xB000000000000000000000000000000000000000;
    address constant randomAddress3 = 0xC000000000000000000000000000000000000000;

    function validate(
        address simple_,
        address contractsHater_,
        address mrGreedy_
    ) external returns (bool) {
        // metadata validation
        _validateMetadata(simple_, contractsHater_, mrGreedy_);

        // mint/burn validation
        _validateMintBurn(simple_, "SimpleToken");
        _validateMintBurn(contractsHater_, "ContractsHaterToken");
        _validateMintBurn(mrGreedy_, "MrGreedyToken");

        // ContractsHaterToken validation
        _validateContractsHater(contractsHater_);

        // MrGreedyToken validation
        _validateMrGreedy(mrGreedy_);

        return true;
    }

    function _validateMetadata(
        address simple_,
        address contractsHater_,
        address mrGreedy_
    ) private {
        require(
            keccak256(bytes(IERC20Metadata(simple_).name())) == keccak256(bytes("SimpleToken")),
            "Validator: wrong SimpleToken name"
        );
        require(
            keccak256(bytes(IERC20Metadata(simple_).symbol())) == keccak256(bytes("ST")),
            "Validator: wrong SimpleToken symbol"
        );
        require(IERC20Metadata(simple_).decimals() == 18, "SimpleToke: wrong decimals");

        require(
            keccak256(bytes(IERC20Metadata(contractsHater_).name())) ==
                keccak256(bytes("ContractsHaterToken")),
            "Validator: wrong contractsHater name"
        );
        require(
            keccak256(bytes(IERC20Metadata(contractsHater_).symbol())) == keccak256(bytes("CHT")),
            "Validator: wrong contractsHater symbol"
        );
        require(
            IERC20Metadata(contractsHater_).decimals() == 18,
            "Validator: wrong contractsHater decimals"
        );

        require(
            keccak256(bytes(IERC20Metadata(mrGreedy_).name())) ==
                keccak256(bytes("MrGreedyToken")),
            "Validator: wrong mrGreedy name"
        );
        require(
            keccak256(bytes(IERC20Metadata(mrGreedy_).symbol())) == keccak256(bytes("MRG")),
            "Validator: wrong mrGreedy symbol"
        );
        require(IERC20Metadata(mrGreedy_).decimals() == 6, "Validator: wrong mrGreedy decimals");
    }

    function _validateMintBurn(address contract_, string memory name_) private {
        ISimpleToken(contract_).mint(address(this), 100);
        ISimpleToken(contract_).mint(randomAddress1, 55);
        require(
            IERC20(contract_).balanceOf(address(this)) == 100,
            string(abi.encodePacked("Validator: in ", name_, " mint function failed"))
        );
        require(
            IERC20(contract_).balanceOf(randomAddress1) == 55,
            string(abi.encodePacked("Validator: in ", name_, " mint function failed"))
        );

        ISimpleToken(contract_).burn(50);
        require(
            IERC20(contract_).balanceOf(address(this)) == 50,
            string(abi.encodePacked("Validator: in ", name_, " burn function failed"))
        );
        ISimpleToken(contract_).burn(50);
        require(
            IERC20(contract_).balanceOf(address(this)) == 0,
            string(abi.encodePacked("Validator: in ", name_, " burn function failed"))
        );
    }

    function _validateContractsHater(address contractsHater_) private {
        address empty1_ = address(new Empty());
        address empty2_ = address(new Empty());

        ISimpleToken(contractsHater_).mint(address(this), 100);
        IERC20(contractsHater_).transfer(randomAddress2, 21);

        require(
            IERC20(contractsHater_).balanceOf(address(this)) == 79,
            "Validator: transfer at ContractsHaterToken failed"
        );
        require(
            IERC20(contractsHater_).balanceOf(randomAddress2) == 21,
            "Validator: transfer at ContractsHaterToken failed"
        );

        bytes memory transferCall1_ = abi.encodeWithSignature(
            "transfer(address,uint256)",
            empty1_,
            10
        );
        (bool success1_, ) = contractsHater_.call(transferCall1_);
        require(
            !success1_,
            "Validator: transfer to non whitlisted contract passed in contractsHaterToken"
        );

        IContractsHaterToken(contractsHater_).addToWhitelist(empty2_);
        IERC20(contractsHater_).transfer(empty2_, 22);
        require(
            IERC20(contractsHater_).balanceOf(address(this)) == 57,
            "Validator: transfer to whitlisted contract address at ContractsHaterToken failed"
        );
        require(
            IERC20(contractsHater_).balanceOf(empty2_) == 22,
            "Validator: transfer to whitlisted contract address at ContractsHaterToken failed"
        );

        IContractsHaterToken(contractsHater_).removeFromWhitelist(empty2_);
        bytes memory transferCall2_ = abi.encodeWithSignature(
            "transfer(address,uint256)",
            empty2_,
            10
        );
        (bool success2_, ) = contractsHater_.call(transferCall2_);
        require(
            !success2_,
            "Validator: transfer to contract that was removed from whitelist passed in contractsHaterToken"
        );
    }

    function _validateMrGreedy(address mrGreedy_) private {
        uint256 oneToken_ = 10**6;
        ISimpleToken(mrGreedy_).mint(address(this), 100 * oneToken_);
        IERC20(mrGreedy_).transfer(randomAddress3, 97 * oneToken_);

        require(
            IERC20(mrGreedy_).balanceOf(address(this)) == 3 * oneToken_,
            "Validator: transfer at MrGreedyToken failed"
        );
        require(
            IERC20(mrGreedy_).balanceOf(randomAddress3) == 87 * oneToken_,
            "Validator: transfer at MrGreedyToken failed"
        );
        address treasury_ = IMrGreedyToken(mrGreedy_).treasury();
        require(
            IERC20(mrGreedy_).balanceOf(treasury_) == 10 * oneToken_,
            "Validator: transfer at MrGreedyToken failed"
        );

        IERC20(mrGreedy_).transfer(randomAddress3, 3 * oneToken_);
        require(
            IERC20(mrGreedy_).balanceOf(address(this)) == 0,
            "Validator: transfer at MrGreedyToken failed"
        );
        require(
            IERC20(mrGreedy_).balanceOf(treasury_) == 13 * oneToken_,
            "Validator: transfer at MrGreedyToken failed"
        );
    }
}