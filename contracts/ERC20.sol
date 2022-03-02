pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract TestToken is ERC20{

    constructor() ERC20("Test Tokens","TTS"){}

    function mint(uint amount) external {
        _mint(msg.sender,amount);
    }

    function decimals() public pure override returns (uint8) {
        return 6;
    }

}
