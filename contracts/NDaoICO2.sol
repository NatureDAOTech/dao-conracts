//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
import "./NDAO.sol";
import "./base/Ownable.sol";
import "./base/ReentrancyGuard.sol";
import './base/IERC20.sol';
import './base/Pausable.sol';
import "./base/Initializable.sol";


contract CrowdFundNDAO is Ownable, Pausable, Initializable{

    IERC20 NDao;
    IERC20 mUSDT;

    address maticUSDT = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;

    uint public basePriceNDAO = 0.25 *10**6;
    uint public startTime;

    bool private _paused;

    mapping(address => bool) isLaunched;

//    struct Campaign{
//        uint startTime;
//        uint endTime;
//        bool completed;
//    }

//    Campaign public ico;

    constructor(address _mUSDT, address _NDAO){
        mUSDT = IERC20(_mUSDT);
        NDao = IERC20(_NDAO);
//        startTime = block.timestamp;
    }

    function Invest (uint _tokensToBuy) external whenNotPaused{
        uint amount = _tokensToBuy* basePriceNDAO;
        mUSDT.transferFrom(_msgSender(),address(this),amount/2);
        mUSDT.transferFrom(_msgSender(),owner(),amount/2); //subjected to change
        NDao.transfer(_msgSender(), _tokensToBuy);
    }

//    function launchICO() external onlyOwner{
//        require(!isLaunched[_msgSender()], "ICO is already launched");
//        ico.startTime = block.timestamp;
//        ico.endTime = block.timestamp + 7 days;
//        ico.completed = false;
//        isLaunched[_msgSender()] = true;
//    }
    function withdrawUnsoldNDaoTokens() external onlyOwner {
        NDao.transfer(_msgSender(), NDao.balanceOf(address(this)));
    }

    function ExtractInvestment() public {
        mUSDT.transfer(owner(), mUSDT.balanceOf(address(this)));
    }

    function initialize()
    public virtual  override(Pausable, Ownable) initializer
    {
        Pausable.initialize();
        Ownable.initialize();
    }

    function setPaused(bool _paused) external onlyOwner {
        if (_paused) _pause();
        else _unpause();
    }
}
