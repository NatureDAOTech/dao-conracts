//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import '@openzeppelin/contracts/security/Pausable.sol';
import "@openzeppelin/contracts/access/Ownable.sol";

///@author Ace, Alfa, Anyx
contract testNDAOICO is Ownable, Pausable, ReentrancyGuard{

    IERC20 NDao;
    IERC20 mUSDT;

    address maticUSDT = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;

    uint public basePriceNDAO = 0.25 *10**6; //0.25 USDT per NDAO

    constructor(address _mUSDT, address _NDAO) {
        mUSDT = IERC20(_mUSDT);
        NDao = IERC20(_NDAO);
    }
    
    ///@dev amount to buy up till 2 decimals
    ///@notice Allows Investor to buy NDAO tokens by paying in USDT
    ///@param _tokensToBuy: The amount of NDAO tokens you want to buy.
    function Invest (uint _tokensToBuy) external nonReentrant whenNotPaused{
        uint amount = _tokensToBuy* basePriceNDAO/10**2;
        mUSDT.transferFrom(_msgSender(),address(this),amount);
         NDao.transfer(_msgSender(), _tokensToBuy*10**16);
    }

    ///@dev Allows the owner to withdraw all the unsold NDAO tokens.
    ///@param _to: Enter the address you want to return the unsold tokens.
    function withdrawUnsoldNDaoTokens(address _to) external onlyOwner {
        NDao.transfer(_to, NDao.balanceOf(address(this)));
    }

    ///@dev Allows the owner to extract the investment while the ICO is running
    ///@param _to: Enter the address who will withdraw the investment,
    ///       _amount: Enter the amount of USDT to be withdrawn.
    function ExtractInvestment(address _to, uint _amount) public onlyOwner{
        mUSDT.transfer(_to, _amount);
    }

    ///@dev Allows the owner to Pause the ICO at anytime after starting.
    ///@param _paused: Enter true if you want to pause or false if you want to unpause.
    function setPaused(bool _paused) external onlyOwner {
        if (_paused) _pause();
        else _unpause();
    }

    ///@dev Allows the owner to change the base price of NDAO tokens
    ///@param _amt: Enter the new amount you want to set for the NDAO tokens.
    function changeBasePrice(uint _amt) public onlyOwner{
        basePriceNDAO = _amt;
    }
}
