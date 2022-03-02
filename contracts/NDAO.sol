//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

///@author Ace, Alfa, Anyx
contract NDAO is ERC20, Ownable{

    address public generalInvestors;
    address public communityTreasury;
    address public vestingAddress;

    bool isInitialized;

    modifier onlyOnce {
        require(!isInitialized,"Already initialized");
        isInitialized = true;
        _;
    }

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

    function initialMinter() external onlyOwner onlyOnce{
        _mint(generalInvestors, 4000000 ether);
        _mint (communityTreasury ,3000000 ether);
        _mint (vestingAddress, 5000000 ether);
    }

    function burn(uint amount) external {
        require(msg.sender == communityTreasury,"Only treasury can burn");
        _burn(msg.sender,amount);
    }

}
