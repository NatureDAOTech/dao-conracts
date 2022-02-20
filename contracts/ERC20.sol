pragma solidity ^0.8.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract TestToken is ERC20{

    constructor() ERC20("Test Tokens","TTS"){}

    function mint(uint amount) external {
        _mint(msg.sender,amount);
    }

    function decimals() public view override returns (uint8) {
        return 6;
    }

}
