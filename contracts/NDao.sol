pragma solidity ^0.8.0;
import "./base/ERC20.sol";
//contracts/base/Base64.sol
contract NDao is ERC20{

    address public generalInvestors;
    address public communityTreasury;
    address public coreTeam;
    address public advisors;
    address public auditors;
    // setters required

    constructor () ERC20 ("Nature_Dao","ND") {
        _totalSupply = 10 ** 10; //setting up totalSupply as 10 billion
        initialMinter(10000000); //minting 10 million tokens to different parties
    }

    function initialMinter(uint _amount) internal {
            uint _giValue = 40*_amount/100;
            _mint(generalInvestors,_giValue);
            uint _ctValue = 30 * _amount / 100;
            _mint (communityTreasury , _ctValue);
            uint _teamValue = 20 * _amount/100;
            _mint (coreTeam, _teamValue);
            uint _advisorValue = 5* _amount / 100;
            _mint(advisors, _advisorValue);
            _mint(auditors, _advisorValue);
    }



}
