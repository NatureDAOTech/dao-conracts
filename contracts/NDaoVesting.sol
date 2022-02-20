//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./base/IERC20.sol";
import "./base/Ownable.sol";
import "./base/Initializable.sol";

contract DAOVesting is Ownable, Initializable{

    IERC20 NDAO;
    address founder;
    address co_founder;
    uint public advisorAndAuditorRelease;
    uint public founderRemuneration;
    uint public devsRemuneration;
    uint public lockTime = 730 days;
    uint public advisorLastClaimTime;
    uint public devsLastClaimTime;
    uint public founderLastClaimTime;
    uint public startTime;
    address[] advisoryAndAuditor;
    address[] devs;
    address[] founders;
    mapping(address => uint) balance;

    constructor(address _ndao, address[] memory _devs, address _auditor, address _advisor, address _cofounder, address _founder) {
        NDAO = IERC20(_ndao);
        advisoryAndAuditor.push(_auditor);
        advisoryAndAuditor.push(_advisor);
        founder = _founder;
        startTime = block.timestamp;
        co_founder = _cofounder;
        for (uint i;i<devs.length;i++)
            devs.push(_devs[i]);
    }

    function initialize()
    public
    virtual
    override(Ownable)
    initializer onlyOwner
    {
        Ownable.initialize();
    }

    function setNDAO(address _ndao) external onlyOwner{
        NDAO = IERC20(_ndao);
    }

    //todo: monthly release [Done]
    //todo: auditor, advisor only first 5 months [Done]
    //todo: devs 2 years [Done]
    //todo: after 2 years every one gets bonus [Done]
    function claimAdvisorAndAuditorMonthlyRemuneration() external{
            require(block.timestamp - startTime + advisorLastClaimTime> 30 days,'Min 30days to re-claim');
            require(advisorAndAuditorRelease<5,'Remuneration period over');
            advisorAndAuditorRelease++;
            for (uint i;i<advisoryAndAuditor.length;i++) {
                NDAO.transfer(advisoryAndAuditor[i],100_000 ether);
            }
    }

    function claimDevsMonthlyRemuneration() external {
        require(block.timestamp - startTime + devsLastClaimTime> 30 days,'Min 30days to re-claim');
        require (devsRemuneration <12,'Remuneration period over');
        devsRemuneration++;
        for (uint i;i<devs.length;i++) {
            NDAO.transfer(devs[i],10_000 ether);
        }
    }

    function claimfounders () external {
        require(block.timestamp - startTime + founderLastClaimTime> 30 days,'Min 30days to re-claim');
        require (founderRemuneration <12,'Remuneration period over');
        founderRemuneration++;
        NDAO.transfer(founder,33_000 ether);
        NDAO.transfer(co_founder,20_000 ether);
    }

    //todo please confirm the values
    function claimFinalReward() external {
        require(block.timestamp - startTime > lockTime, 'Reward Will Be Published After 2 years only');
        for (uint i;i<devs.length;i++) {
            NDAO.transfer(devs[i],200_000 ether);
        }
        NDAO.transfer(founder, 1_000_000 ether);
        NDAO.transfer(co_founder, 400_000 ether);

    }
}