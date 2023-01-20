// Contract based on https://docs.openzeppelin.com/contracts/3.x/erc721
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Counter {
    // state variable --> value will be stored in the blockchain 
    uint public count;

    function get() public view returns (uint) {
        return count;
    }

    function inc() public {
        count +=1;
    }

    function dec() public {
        count -=1;
    }

} 