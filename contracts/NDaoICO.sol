//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
import "./NDAO.sol";
import "./base/ReentrancyGuard.sol";
import '@openzeppelin/contracts/security/Pausable.sol';

contract CrowdFundNDAO is Ownable, Pausable, ReentrancyGuard{

    IERC20 NDao;
    IERC20 mUSDT;

    address maticUSDT = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;

    uint public basePriceNDAO = 0.25 *10**6; //0.25 USDT per NDAO

    constructor(address _mUSDT, address _NDAO) {
        mUSDT = IERC20(_mUSDT);
        NDao = IERC20(_NDAO);
    }
    
    //Token amount to buy up till 2 decimals
    function Invest (uint _tokensToBuy) external nonReentrant whenNotPaused{
        uint amount = _tokensToBuy* basePriceNDAO/10**2;
        mUSDT.transferFrom(_msgSender(),address(this),amount);
        NDao.transfer(_msgSender(), _tokensToBuy*10**16);
    }

    function withdrawUnsoldNDaoTokens(address _to) external onlyOwner {
        NDao.transfer(_to, NDao.balanceOf(address(this)));
    }

    function ExtractInvestment(address _to, uint _amount) public onlyOwner{
        mUSDT.transfer(_to, _amount);
    }

    function setPaused(bool _paused) external onlyOwner {
        if (_paused) _pause();
        else _unpause();
    }

    function changebasePrice(uint _amt) public onlyOwner{
        basePriceNDAO = _amt;
    }
}
