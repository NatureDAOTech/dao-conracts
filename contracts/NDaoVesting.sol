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

    address public Founder;
    address public Co_Founder;
    address public dev1;
    address public dev2;
    address public dev3;

    uint public lockTime = 7 days;

    mapping(address => uint) balance;

    constructor(address _ndao){
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

    function setNDAO(address _ndao) external onlyOwner{
        NDAO = IERC20(_ndao);
    }

    function claimMonthlyRemuneration(address _inquirer) external{

    }
    //Add in logic to unlock amount for individual participants every month
    //Save a mapping (or double mapping idk) to check if they have received amount for current month
    //Only allow retrieval after 30 days of contract initiation and 30 days every next time
    //If someone skips a turn, they should be able to make 2 (even better if 1) transaction to retrieve balance

    function claimFinalReward() external {
        require(block.timestamp - startTime > lockTime, 'Reward Will Be Published After 2 years only');
        for (uint i;i<devs.length;i++) {
            NDAO.transfer(devs[i],200_000 ether);
        }
        NDAO.transfer(founder, 1_000_000 ether);
        NDAO.transfer(co_founder, 400_000 ether);
    }
}