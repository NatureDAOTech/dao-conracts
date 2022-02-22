// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./base/ERC20.sol";
import "./base/Ownable.sol";

contract Anyx is ERC20, Ownable{
    constructor() ERC20("Anyx", "ANX") {
        _mint(msg.sender, 1000 * (10 ** uint256(decimals())));
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }

    function mintTokens(uint _amt) public onlyOwner{
        _mint(msg.sender, _amt * (10 ** uint256(decimals())));
    }

}