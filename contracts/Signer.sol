//SPDX-License-Identifier: UNLICENSED

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/cryptography/draft-EIP712.sol";

contract signerCheck is EIP712{

    string private constant SIGNING_DOMAIN = "NDAO";
    string private constant SIGNATURE_VERSION = "1";

    struct Signer{
        uint proposalId;
        address contractAddress;
        bytes functionCall;
        bytes signature;
    }

    constructor() EIP712(SIGNING_DOMAIN, SIGNATURE_VERSION){

    }

    function getSigner(Signer memory signer) public view returns(address){
        return _verify(signer);
    }

    /// @notice Returns a hash of the given Signer, prepared using EIP712 typed data hashing rules.

    function _hash(Signer memory signer) internal view returns (bytes32) {
        return _hashTypedDataV4(keccak256(abi.encode(
                keccak256("Signer(uint256 proposalId,address contractAddress,bytes functionCall)"),
                signer.proposalId,
                signer.contractAddress,
                keccak256(signer.functionCall)
            )));
    }

    function _verify(Signer memory signer) internal view returns (address) {
        bytes32 digest = _hash(signer);
        return ECDSA.recover(digest, signer.signature);
    }

}