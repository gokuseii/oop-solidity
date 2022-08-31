// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./interfaces/IMrGreedyToken.sol";
import "./SimpleToken.sol";

contract MrGreedyToken is IMrGreedyToken, SimpleToken {
    uint256 private _fee = 10 * (10**decimals());
    address private _treasury = 0x586b72229938e9B7E243912E06f46A44ba396c02;

    constructor(string memory name_, string memory symbol_)
        SimpleToken(name_, symbol_)
    {}

    function treasury() external view returns (address) {
        return _treasury;
    }

    function getResultingTransferAmount(uint256 amount_)
        external
        view
        returns (uint256)
    {
        if (amount_ > _fee) return amount_ - _fee;
        return 0;
    }

    function decimals() public view virtual override returns (uint8) {
        return 6;
    }

    function transfer(address to, uint256 amount)
        public
        virtual
        override
        returns (bool)
    {
        address owner = _msgSender();
        // если сумма больше комиссии, то вычитаем комиссию и переводим
        // иначе перводим всю сумму на баланс treasury
        if (amount > _fee) {
            amount -= _fee;
            _transfer(owner, _treasury, _fee);
            _transfer(owner, to, amount);
        } else {
            _transfer(owner, _treasury, amount);
        }
        return true;
    }
}
