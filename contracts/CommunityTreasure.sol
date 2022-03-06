//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "./Signer.sol";

contract DAOMultisig is signerCheck{

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

    function callMultiSig(uint proposalId,address contractAddress,uint _amount,uint _gas, bytes memory functionCall,bytes[] memory signatures) external payable{
        require(!proposalFulfilled[proposalId],"Already fulfilled");
        bool[5] memory votes;
        for(uint i=0;i<signatures.length;i++){
            address partyAddress = getSigner(Signer(proposalId,contractAddress,_amount,_gas,functionCall,signatures[i]));
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
        (bool success,bytes memory data) = contractAddress.call{value:_amount,gas:_gas}(functionCall);
        
        emit fulfillment(proposalId, success, data);
    }

    receive() external payable{}

}