pragma solidity ^0.8.7;
import "./base/ERC20.sol";
import "./base/Ownable.sol";

contract NDAO is ERC20, Ownable{

    address public generalInvestors;
    address public communityTreasury;
    address public coreTeam;
    address public advisors;
    address public auditors;

    function setGI(address _GIAddress) external onlyOwner{
        generalInvestors = _GIAddress;
    }

    function setCT(address _CTAddress) external onlyOwner{
        communityTreasury = _CTAddress;
    }

    function setCoreTeam(address _CoreTAddress) external onlyOwner{
        coreTeam = _CoreTAddress;
    }

    function setAdv(address _advAddress) external onlyOwner{
        advisors = _advAddress;
    }

    function setAuditors(address _AuditAddress) external onlyOwner{
        auditors = _AuditAddress;
    }

    constructor () ERC20 ("NatureDAO","NDAO") {
        //minting 10 million tokens to different parties
    }

    function initialMinter(uint _amount) external onlyOwner {
        uint _giValue = 40*_amount/100;
        _mint(generalInvestors, _giValue);
        uint _ctValue = 30 * _amount / 100;
        _mint (communityTreasury , _ctValue);
        uint _teamValue = 20 * _amount/100;
        _mint (coreTeam, _teamValue);
        uint _advisorValue = 5* _amount / 100;
        _mint(advisors, _advisorValue);
        uint _auditorValue = 5* _amount / 100;
        _mint(auditors, _auditorValue);
    }

}
