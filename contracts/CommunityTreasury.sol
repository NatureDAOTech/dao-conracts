//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./base/IERC20.sol";
import "./Signer.sol";

contract Treasury is signerCheck{

    struct party{
        bool isParty;
        uint8 index;
    }
    
    mapping(address=>party) holders;

    mapping(uint=>bool) proposalFulfilled;

    constructor(address[5] memory signers) {
        for(uint8 i=0;i<signers.length;i++){
            holders[signers[i]] = party(true,i);
        }
    }

    function allowTransaction(uint proposalId,address contractAddress,uint amount,address receiver,bytes[] memory signatures) external {
        require(!proposalFulfilled[proposalId],"Already fulfilled");
        bool[5] memory votes;
        for(uint i=0;i<signatures.length;i++){
            address partyAddress = getSigner(Signer(proposalId,contractAddress,amount,receiver,signatures[i]));
            require(holders[partyAddress].isParty,"Not holder");
            votes[holders[partyAddress].index] = true;
        }
        uint8 count;
        for(uint i=0;i<5;i++){
            if(votes[i]){
                count++;
            }
        }
        require(count >= 3,"Quorum not reached");
        proposalFulfilled[proposalId] = true;
        IERC20(contractAddress).transfer(receiver,amount);
    }

    function getChain() external view returns(uint){
        return block.chainid;
    }

}