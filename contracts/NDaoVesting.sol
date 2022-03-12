//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

///@author Ace, Alfa, Anyx
contract NDAOVesting {

    IERC20 NDAO;

    address public founder;
    address public co_founder;
    address[2] public advisoryAndAuditor;
    address[3] public devs;
    address public communityTreasury;
    uint public lockTime = 10 minutes;
    uint public deployTime;

    uint counterForAdv = 1;
    uint[3] counterForDevsOwner = [1,1,1];

    bool public finalRewardIsClaimed;

    constructor(address _ndao, address[3] memory _devs, address[2] memory _auditorAdvisor,
        address _coFounder, address _founder, address _communityTreasury) {
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
        //communityTreasury address
        communityTreasury = _communityTreasury;
    }

    ///@notice Allows the Advisors and Auditors to claim NDAO tokens on monthly basis for 5 months.
    function claimAdvisorAndAuditorMonthlyRemuneration() external {
        require(block.timestamp > deployTime + counterForAdv*2 minutes,'Salary not unlocked for the next month');
        require(counterForAdv <= 5,'Remuneration period over');
        counterForAdv++;
        for (uint i;i<advisoryAndAuditor.length;i++) {
            NDAO.transfer(advisoryAndAuditor[i],100_000 ether);
        }
    }
    ///@notice Allows the Devs and owner to claim for 2yrs at a monthly interval
    function claimDevsAndOwnerMonthlyRemuneration(uint8[] memory claim) external {
        require(claim.length < 4,"Invalid claim code");
        for(uint i=0;i<claim.length;i++){
            if(claim[i] == 0){
                claimFounderMonthlyInternal();
            }
            else if(claim[i] == 1){
                claimCoFounderMonthlyInternal();
            }
            else{
                claimDevsMonthlyRenumeration();
            }
        }
    }

    function claimFounderMonthlyInternal() private {
        require(block.timestamp > deployTime + counterForDevsOwner[0] * 2 minutes,'Salary not unlocked for the next month');
        require (counterForDevsOwner[0] <= 24,'Remuneration period over');
        counterForDevsOwner[0]++;
        NDAO.transfer(founder, 33_000 ether);
    }

    function claimCoFounderMonthlyInternal() private {
        require(block.timestamp > deployTime + counterForDevsOwner[1] * 2 minutes,'Salary not unlocked for the next month');
        require (counterForDevsOwner[1] <= 24,'Remuneration period over');
        counterForDevsOwner[1]++;
        NDAO.transfer(co_founder, 20_000 ether);
    }

    function claimDevsMonthlyRenumeration() private {
        require(block.timestamp > deployTime + counterForDevsOwner[2] * 2 minutes,'Salary not unlocked for the next month');
        require (counterForDevsOwner[2] <= 24,'Remuneration period over');
        counterForDevsOwner[2]++;
        for (uint i;i<devs.length;i++){
            NDAO.transfer(devs[i],10_000 ether);
        }
    }

    ///@notice Allows Devs, Auditors, Advisors, Co-founder and Founder to claim a one time reward after 2 years.
    function claimFinalReward() external {
        require(!finalRewardIsClaimed, "Final Reward already claimed");
        require(block.timestamp - deployTime > lockTime, 'Reward Will Be Published After 2 years only');
        finalRewardIsClaimed = true;
        for (uint i;i<devs.length;i++) {
            NDAO.transfer(devs[i],200_000 ether);
        }
        NDAO.transfer(founder, 1_000_000 ether);
        NDAO.transfer(co_founder, 400_000 ether);
    }

    modifier onlyTreasury{
        require(msg.sender == communityTreasury,"Not treasury");
        _;
    }

    function changeAddress(address _changedAdd, uint8 _addressIndex) external onlyTreasury{
        require(_addressIndex < 7, "Invalid Address Index");
        if(_addressIndex == 0){
            founder = _changedAdd;
        }
        else if(_addressIndex == 1){
            co_founder = _changedAdd;
        }
        else if(_addressIndex < 5){
            devs[_addressIndex-2] = _changedAdd;
        }
        else{
            advisoryAndAuditor[_addressIndex - 5] = _changedAdd;
        }
    }

}
