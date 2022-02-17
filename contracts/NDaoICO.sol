pragma solidity ^0.8.7;
import "./NDAO.sol";
import "./base/Ownable.sol";
import "./base/ReentrancyGuard.sol";
import './base/IERC20.sol';


contract NDAOICO is Ownable{

    address maticUSDTAddress = 0xc2132D05D31c914a87C6611C10748AEb04B58e8F;
    address public admin;

    uint public basePriceNDAO = 0.25 *10**6;
//  uint public basePriceNDAO = 0.25 *10**18; 
//  uint public maxInvestPerPerson;
//  uint public icoTarget;
    uint public icoStartTime;
    uint public icoEndTime;
//  uint public investmentRaised;
//  uint public tokenSold;

    enum Status{inactive, active, stopped, completed}
    Status public icoStatus;
    IERC20 mUSDT;
    IERC20 NDao;

    constructor(address payable _recipient, address _NDAO, uint _icoStartTime, uint target){
        admin = _msgSender();
        recipient = _recipient;
        icoStartTime = _icoStartTime;
        icoEndTime = _icoStartTime+7 days;
        NDao = IERC20(_NDAO);
        mUSDT = IERC20(maticUSDTAddress);
    }

    function setICOStartTime(uint _time) external {
        icoStartTime = _time;
    }

    function setStatusToActive() external onlyOwner {
        icoStatus = Status.active;
    }

    function setStatusToStopped() external onlyOwner {
        icoStatus = Status.stopped;
    }


// TODO 1 : Allow users to buy 1 NDAO for 0.25 USDT
// TODO 2 : Lock 50% of user's investment for x duration and transfer the other 50% instantly
// QUERY 1 : Are on investments unlocked on the same day or in constant time from buy
// 

    function ExtractInvestment() public {
        require(icoStatus == Status.completed, "ICO not completed yet");
        mUSDT.transfer(recipient, mUSDT.balanceOf(address(this)));
    }

    //assuming this ICO contract will be holding the 40% of 1million initial minted token i.e. 400,000 tokens will be utilised in this ICO
    function Invest (uint _amountToInvest) external {
        getIcoStatus();
        require (icoStatus == Status.active,"ICO Ended");
//        require (investmentRaised + _amountToInvest <= , "Overflow"); //todo: change this one
        uint _tokenToGive = _amountToInvest/basePriceNDAO;
        mUSDT.transferFrom(_msgSender(),address(this),_tokenToGive* basePriceNDAO);
        NDao.transfer(_msgSender(),_tokenToGive * 1 ether);
        tokenSold+= _tokenToGive;
        investmentRaised+=(_tokenToGive*basePriceNDAO);
    }

    function withdrawUnsoldNDaoTokens(address _recipient) external onlyOwner {
        require(icoStatus == Status.completed, "ICO not completed yet");
        NDao.transfer(_recipient, NDao.balanceOf(address(this)));
    }

//This needs to be optimised
    function getIcoStatus() internal {
        if(block.timestamp < icoStartTime)
        icoStatus = Status.inactive;
        else if(block.timestamp > icoStartTime && block.timestamp < icoEndTime)
        icoStatus =  Status.active;
        else if(block.timestamp > icoEndTime || investmentRaised == icoTarget)
        icoStatus = Status.completed;
        else
        icoStatus = Status.stopped;
    }
}
