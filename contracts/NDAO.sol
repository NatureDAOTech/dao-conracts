//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
import "./base/ERC20.sol";
import "./base/Ownable.sol";

contract NDAO is ERC20, Ownable{

    address public generalInvestors;
    address public communityTreasury;
    address public vestingAddress;


    function setGI(address _GIAddress) external onlyOwner{
        generalInvestors = _GIAddress;
    }

    function setCT(address _CTAddress) external onlyOwner{
        communityTreasury = _CTAddress;
    }

    function setCoreTeam(address _VestingAddress) external onlyOwner{
        vestingAddress = _VestingAddress;
    }

    constructor () ERC20 ("NatureDAO","NDAO") {
        //minting 10 million tokens to different parties
    }

    function initialMinter(uint _amount) external onlyOwner {
        uint _giValue = 40*_amount/100;
        _mint(generalInvestors, _giValue);
        uint _ctValue = 30 * _amount / 100;
        _mint (communityTreasury , _ctValue);
        uint _teamValue = 30 * _amount/100;
        _mint (vestingAddress, _teamValue);
    }

}
