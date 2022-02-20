//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./base/IERC20.sol";
import "./base/Ownable.sol";
import "./base/Initializable.sol";

contract NDAOVesting {

    IERC20 NDAO;
    address founder;
    address co_founder;
    uint public advisorAndAuditorRelease;
    uint public devsRemuneration;
    uint public lockTime = 10 minutes;
    uint public advisorLastClaimTime;
    uint public devsLastClaimTime;
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
        advisorLastClaimTime = block.timestamp;
        devsLastClaimTime = block.timestamp;
        startTime = block.timestamp;
        co_founder = _cofounder;
        for (uint i;i<devs.length;i++)
            devs.push(_devs[i]);
    }
    function claimAdvisorAndAuditorMonthlyRemuneration() external {
            require(block.timestamp - advisorLastClaimTime > 2 minutes,'Min 30days to re-claim');
            require(advisorAndAuditorRelease < 5,'Remuneration period over');
            advisorAndAuditorRelease++;
            for (uint i;i<advisoryAndAuditor.length;i++) {
                NDAO.transfer(advisoryAndAuditor[i],100_000 ether);
            }
    }

    function claimDevsAndOwnerMonthlyRemuneration() external {
        require(block.timestamp -  devsLastClaimTime> 2 minutes,'Min 30days to re-claim');
        require (devsRemuneration < 24,'Remuneration period over');
        devsRemuneration++;
        for (uint i;i<devs.length;i++) {
            NDAO.transfer(devs[i],10_000 ether);
        }
        NDAO.transfer(founder,33_000 ether);
        NDAO.transfer(co_founder,20_000 ether);
    }

    function claimFinalReward() external {
        require(block.timestamp - startTime > lockTime, 'Reward Will Be Published After 2 years only');
        for (uint i;i<devs.length;i++) {
            NDAO.transfer(devs[i],200_000 ether);
        }
        NDAO.transfer(founder, 1_000_000 ether);
        NDAO.transfer(co_founder, 400_000 ether);
    }
}