//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./base/IERC20.sol";
import "./base/Ownable.sol";

contract NDAOVesting {

    IERC20 NDAO;

    address public founder;
    address public co_founder;
    address[2] public advisoryAndAuditor;
    address[3] public devs;

    uint public lockTime = 10 minutes;
    uint public deployTime;

    uint counterForAdv = 1;
    uint counterForDevsOwner = 1;

    bool public finalRewardIsClaimed;

    constructor(address _ndao, address[3] memory _devs, address[2] memory _auditorAdvisor,
        address _coFounder, address _founder) {
        NDAO = IERC20(_ndao);
        //advisor and auditor
        advisoryAndAuditor = _auditorAdvisor;
        //founder
        founder = _founder;
        //co-founder
        co_founder = _coFounder;
        //developers
        devs = _devs;
        //start time
        deployTime = block.timestamp;
    }

    function claimAdvisorAndAuditorMonthlyRemuneration() external {
        require(block.timestamp > deployTime + counterForAdv*2 minutes,'Salary not unlocked for the next month');
        require(counterForAdv <= 5,'Remuneration period over');
        for (uint i;i<advisoryAndAuditor.length;i++) {
            NDAO.transfer(advisoryAndAuditor[i],100_000 ether);
        }
        counterForAdv++;
    }

    function claimDevsAndOwnerMonthlyRemuneration() external {
        require(block.timestamp > deployTime + counterForDevsOwner*2 minutes,'Salary not unlocked for the next month');
        require (counterForDevsOwner <= 24,'Remuneration period over');
        for (uint i;i<devs.length;i++){
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
