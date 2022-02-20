//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.7;
import "./NDAO.sol";
import "./base/Ownable.sol";
import "./base/ReentrancyGuard.sol";
import './base/IERC20.sol';


contract NDAOICO is Ownable{

    address maticUSDTAddress =   0xc2132D05D31c914a87C6611C10748AEb04B58e8F;
//    address public admin;

    uint public basePriceNDAO = 0.25 *10**6;
    uint public icoStartTime;
//    uint public icoEndTime;
//    uint public totalSupply;
    address public recipient;
//    uint public tokensRaised;

//    mapping(address => uint) investmentBalance;
//    enum Status{inactive, active, stopped, completed}
//    Status public icoStatus;
    IERC20 mUSDT;
    IERC20 NDao;

    constructor(address _NDAO, uint _icoStartTime){
//        admin = _msgSender();
        icoStartTime = _icoStartTime;
        NDao = IERC20(_NDAO);
        mUSDT = IERC20(maticUSDTAddress);
        icoEndTime = icoStartTime + 7 days;
    }

//    function setICOStartTime(uint _time) external {
//        icoStartTime = _time;
//    }
//
//    function setStatusToActive() external onlyOwner {
//        icoStatus = Status.active;
//    }
//
//    function setStatusToStopped() external onlyOwner {
//        icoStatus = Status.stopped;
//    }


// TODO 1 : Allow users to buy 1 NDAO for 0.25 USDT
// TODO 2 : Lock 50% of user's investment for x duration and transfer the other 50% instantly


    function ExtractInvestment() public {
        require(icoStatus == Status.completed, "ICO not completed yet");
        mUSDT.transfer(recipient, mUSDT.balanceOf(address(this)));
    }

    //assuming this ICO contract will be holding the 40% of 1million initial minted token i.e. 400,000 tokens will be utilised in this ICO
    function Invest (uint _tokensToBuy) external payable{
        getIcoStatus();
        require (icoStatus == Status.active,"ICO Ended");
        uint amount = _tokensToBuy* basePriceNDAO;
        mUSDT.transferFrom(_msgSender(),address(this),amount/2);
        mUSDT.transferFrom(_msgSender(),recipient,amount/2); //subjected to change
        NDao.transfer(_msgSender(), _tokensToBuy);
        tokensRaised += _tokensToBuy;
    }

    function withdrawUnsoldNDaoTokens() external onlyOwner {
        require(icoStatus == Status.completed, "ICO not completed yet");
        NDao.transfer(_msgSender(), NDao.balanceOf(address(this)));
    }

}
