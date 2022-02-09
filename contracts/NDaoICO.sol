pragma solidity ^0.8.7;
import "./NDAO.sol";
import "./base/Ownable.sol";
import "./base/ReentrancyGuard.sol";

contract NDAOICO is NDAO{

    address MaticUSDTAddress = 0xc2132d05d31c914a87c6611c10748aeb04b58e8f;
    address public admin;
    address payable public recipient;

    uint public basePriceNDAO = 0.25 ether;
    uint public maxInvestPerPerson;
    uint public minInvestPerPerson;
    uint public icoTarget;
    uint public icoStartTime;
    uint public icoEndTime;
    uint public investmentRaised;
    uint public tokenSold;

    enum Status{inactive, active, stopped, completed}
    Status public icoStatus;

    constructor(address payable _recipient, uint _icoStartTime, uint _icoEndTime, uint target){
        require(_icoStartTime < _icoEndTime && target != 0, "Enter data correctly");
        admin = _msgSender();
        recipient = _recipient;
        icoStartTime = _icoStartTime;
        icoEndTime = _icoEndTime;
        icoTarget = target;
    }

    function setStatusToActive() external onlyOwner{
        icoStatus = Status.active;
    }

    function setStatusToStopped() external onlyOwner{
        icoStatus = Status.stopped;
    }

    function ExtractInvestment() public onlyOwner{
        require(icoStatus == Status.completed, "ICO not completed yet");
        recipient.transfer(address(this).balance);
    }

    function Invest() public payable nonReentrant{
        getIcoStatus();
        require(icoStatus == Status.active, "ICO ended");
        if(investmentRaised + msg.value <= icoTarget){
            uint tokenToBuy = msg.value/basePriceNDAO;
            transfer(_msgSender(), tokenToBuy);
            tokenSold+=tokenToBuy;
            investmentRaised += msg.value;
        }
        else{
            exceedBalance = icoTarget - investmentRaised - msg.value;
            _msgSender().transfer(exceedBalance);
            uint tokenToBuy = (icoTarget - investmentRaised)/basePriceNDAO;
            transfer(_msgSender(), tokenToBuy);
            tokenSold+=tokenToBuy;
            investmentRaised += msg.value;
        }
    }
    
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
