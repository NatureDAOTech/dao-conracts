//SPDX-License-Identifier: UNLICENSED

pragma soldity ^0.8.0;

import "./base/IERC20.sol";
import "./base/Ownable.sol";

contract DAOVesting is Ownable{

    IERC20 NDAO;

    constructor(address _ndao){
        NDAO = IERC20(_ndao);
    }

    function setNDAO(address _ndao) external onlyOwner{
        
    }

    //Add in logic to unlock amount for individual participants every month
    //Save a mapping (or double mapping idk) to check if they have received amount for current month
    //Only allow retrieval after 30 days of contract initiation and 30 days every next time
    //If someone skips a turn, they should be able to make 2 (even better if 1) transaction to retrieve balance

}