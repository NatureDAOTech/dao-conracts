//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./base/IERC20.sol";
import "./base/Ownable.sol";

contract NDAOVesting {

    IERC20 NDAO;
    address founder;
    address co_founder;
    uint public advisorAndAuditorRelease;
    uint public devsRemuneration;
    uint public lockTime = 10 minutes;
    uint public advisorLastClaimTime;
    uint public devsLastClaimTime;
    uint public deployTime;
    uint counterForAdv = 1;
    uint counterForDevsOwner = 1;
    address[] advisoryAndAuditor;
    address[] devs;
    address[] founders;
    bool public finalRewardIsClaimed;
    mapping(address => uint) balance;

    constructor(address _ndao, address[] memory _devs, address _auditor,
        address _advisor, address _coFounder, address _founder) {
        NDAO = IERC20(_ndao);
        advisoryAndAuditor.push(_auditor);
        advisoryAndAuditor.push(_advisor);
        founder = _founder;
        advisorLastClaimTime = block.timestamp;
        devsLastClaimTime = block.timestamp;
        startTime = block.timestamp;
        co_founder = _coFounder;
        for (uint i;i<_devs.length;i++)
            devs.push(_devs[i]);
    }
    function claimAdvisorAndAuditorMonthlyRemuneration() external {
        require(block.timestamp >counterForAdv*(deployTime + 30 days),'Salary not unlocked');
        require(advisorAndAuditorRelease < 5,'Remuneration period over');
        advisorAndAuditorRelease++;
        counterForAdv = (block.timestamp - advisorLastClaimTime)/ 30 days;
        for (uint i;i<advisoryAndAuditor.length;i++) {
            NDAO.transfer(advisoryAndAuditor[i],monthlyGeneration* 100_000 ether);
        }
        advisorLastClaimTime = block.timestamp;
    }

    function claimDevsAndOwnerMonthlyRemuneration() external {
        require(block.timestamp >counterForDevsOwner*(deployTime + 30 days),'Salary not unlocked');
        require (devsRemuneration < 24,'Remuneration period over');
        devsRemuneration++;
        counterForDevsOwner = (block.timestamp - devsLastClaimTime)/ 30 days;
        for (uint i;i<devs.length;i++) {
            NDAO.transfer(devs[i],counterForDevsOwner*10_000 ether);
        }
        NDAO.transfer(founder,counterForDevsOwner*33_000 ether);
        NDAO.transfer(co_founder,counterForDevsOwner*20_000 ether);
        devsLastClaimTime = block.timestamp;
    }

    function claimFinalReward() external {
        require(!finalRewardIsClaimed, "Final Reward already claimed");
        require(block.timestamp - startTime > lockTime, 'Reward Will Be Published After 2 years only');
        for (uint i;i<devs.length;i++) {
            NDAO.transfer(devs[i],200_000 ether);
        }
        NDAO.transfer(founder, 1_000_000 ether);
        NDAO.transfer(co_founder, 400_000 ether);
        finalRewardIsClaimed = true;
    }

}
