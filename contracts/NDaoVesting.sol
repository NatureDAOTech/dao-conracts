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
    uint public deployTime;
    uint counterForAdv = 1;
    uint counterForDevsOwner = 1;
    address[] public advisoryAndAuditor;
    address[] public devs;
    address[] public founders;
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
        deployTime = block.timestamp;
        co_founder = _coFounder;
        for (uint i;i<_devs.length;i++)
            devs.push(_devs[i]);
    }

// 
    function claimAdvisorAndAuditorMonthlyRemuneration() external {
        require(block.timestamp > deployTime + counterForAdv*30 days,'Salary not unlocked for the next month');
        require(advisorAndAuditorRelease < 5,'Remuneration period over');
        advisorAndAuditorRelease++;
        for (uint i;i<advisoryAndAuditor.length;i++) {
            NDAO.transfer(advisoryAndAuditor[i],100_000 ether);
        }
        counterForAdv++;
    }

    function claimDevsAndOwnerMonthlyRemuneration() external {
        require(block.timestamp >deployTime + counterForDevsOwner*30 days,'Salary not unlocked for the next month');
        require (devsRemuneration < 24,'Remuneration period over');
        devsRemuneration++;
        for (uint i;i<devs.length;i++) {
            NDAO.transfer(devs[i],10_000 ether);
        }
        NDAO.transfer(founder, 33_000 ether);
        NDAO.transfer(co_founder, 20_000 ether);
        counterForDevsOwner++;
    }

    function claimFinalReward() external {
        require(!finalRewardIsClaimed, "Final Reward already claimed");
        require(block.timestamp - deployTime> lockTime, 'Reward Will Be Published After 2 years only');
        for (uint i;i<devs.length;i++) {
            NDAO.transfer(devs[i],200_000 ether);
        }
        NDAO.transfer(founder, 1_000_000 ether);
        NDAO.transfer(co_founder, 400_000 ether);
        finalRewardIsClaimed = true;
    }

}
