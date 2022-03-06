//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./testSigner.sol";

contract testDAOMultisig is testSignerCheck{

    struct party{
        bool isParty;
        uint8 index;
    }

    mapping(address=>party) holders;

    mapping(uint=>bool) proposalFulfilled;

    event fulfillment(uint indexed proposalId,bool fulfilled,bytes data);

    constructor(address[5] memory signers) {
        for(uint8 i=0;i<signers.length;i++){
            holders[signers[i]] = party(true,i);
        }
    }

    function callMultiSig(uint proposalId,address contractAddress,bytes memory functionCall,bytes[] memory signatures) external payable{
        require(!proposalFulfilled[proposalId],"Already fulfilled");
        bool[5] memory votes;
        for(uint i=0;i<signatures.length;i++){
            address partyAddress = getSigner(Signer(proposalId,contractAddress,functionCall,signatures[i]));
            require(holders[partyAddress].isParty,"Not holder");
            votes[holders[partyAddress].index] = true;
        }
        uint8 count;
        for(uint i=0;i<5;i++){
            if(votes[i]){
                count++;
            }
        }
        (bool success,bytes memory data) = contractAddress.call{value:msg.value}(functionCall);
        
        emit fulfillment(proposalId, success, data);
    }

}