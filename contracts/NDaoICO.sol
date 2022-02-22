//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
import "./NDAO.sol";
import "./base/Ownable.sol";
import "./base/ReentrancyGuard.sol";
import './base/IERC20.sol';
import './base/Pausable.sol';

contract CrowdFundNDAO is Ownable, Pausable, ReentrancyGuard{

    IERC20 NDao;
    IERC20 mUSDT;
    address maticUSDT = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;
    uint public basePriceNDAO = 0.25 *10**6;
    uint public startTime;
    bool private _paused;
    constructor(address _mUSDT, address _NDAO) {
        mUSDT = IERC20(_mUSDT);
        NDao = IERC20(_NDAO);
    }

    function Invest (uint _tokensToBuy) external nonReentrant whenNotPaused{
        uint amount = _tokensToBuy* basePriceNDAO;
        mUSDT.transferFrom(_msgSender(),address(this),amount);
        NDao.transfer(_msgSender(), _tokensToBuy* 1 ether);
    }

    function withdrawUnsoldNDaoTokens() external onlyOwner {
        NDao.transfer(_msgSender(), NDao.balanceOf(address(this)));
    }

    function ExtractInvestment() public {
        mUSDT.transfer(owner(), mUSDT.balanceOf(address(this)));
    }

    function setPaused(bool _paused) external onlyOwner {
        if (_paused) _pause();
        else _unpause();
    }

    function changebasePrice(uint _amt) public onlyOwner{
        basePriceNDAO = _amt;
    }
}
