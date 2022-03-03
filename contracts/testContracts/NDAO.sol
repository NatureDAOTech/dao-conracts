//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

///@author Ace, Alfa, Anyx
contract testNDAO is ERC20, Ownable{

    address public generalInvestors;
    address public communityTreasury;
    address public vestingAddress;

    bool isInitialized;

    constructor (address _icoContract, address _multisig, address _vesting) ERC20 ("NatureDAO","NDAO") {
        //minting 10 million tokens to different parties
        generalInvestors = _icoContract;
        communityTreasury = _multisig;
        vestingAddress = _vesting;
    }

    modifier onlyOnce {
        require(!isInitialized,"Already initialized");
        isInitialized = true;
        _;
    }

    modifier onlyTreasury{
        require(msg.sender == communityTreasury,"Not treasury");
        _;
    }

    ///@dev Allows owner to set General Investors Address.
    function setGI(address _GIAddress) external onlyTreasury{
        generalInvestors = _GIAddress;
    }

    ///@dev Allows owner to set Community Treasure Address.
    function setCT(address _CTAddress) external onlyTreasury{
        communityTreasury = _CTAddress;
    }

    ///@dev Allows owner to set Vesting Contract Address.
    function setCoreTeam(address _VestingAddress) external onlyTreasury{
        vestingAddress = _VestingAddress;
    }

    function mintTokens(address _to, uint _amount) external onlyTreasury{
        _mint(_to, _amount);
    }

    ///@dev Allows Owner to mint NDAO tokens and send to other functional contracts only once.
    function initialMinter() external onlyOwner onlyOnce{
        _mint(generalInvestors, 4000000 ether);
        _mint (communityTreasury ,3000000 ether);
        _mint (vestingAddress, 5000000 ether);
    }

    ///@dev Allows only Community Treasury to burn the NDAO tokens.
    ///@param amount: Enter the amount of tokens to burn.
    function burn(uint amount) external onlyTreasury{
        _burn(msg.sender,amount);
    }
}
