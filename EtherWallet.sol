// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract EtherWallet {

    address payable public owner;

    constructor() {
        owner = payable(msg.sender);
    }

    function receiveEther() public payable {}

    function withdraw(uint _amount) public {
        require(msg.sender == owner, "The function caller is not the wallet owner!");
        payable(msg.sender).transfer(_amount);
    }

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

} 








