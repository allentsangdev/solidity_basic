//SPDX-License-Identifier: MIT  
pragma solidity ^0.5.7;

// EXERCISE: 
// 1. Refactor the code to use an array of Structs to hold the beneficiary information,
// without using a mapping.
// 2. create a function to translate the value entered in Ether to Wei.
// 3. Add some require statement to make sure the balance in the contract is sufficient to cover
// the setInheritance values

//******************************
// MARKED LAB RELATED COMMENT WITH @dev PREFIX
//******************************

contract LastWillAndTestament {

    address owner;
    uint funds;
    bool isDeceased;
    uint remainingFund; // @dev For make sure the balance in the contract is sufficient to cover the setInheritance values

    constructor() public payable {
        owner = msg.sender; 
        funds = msg.value;
        isDeceased = false;
        remainingFund = msg.value; // @dev Initialize the value of remaining fund to fund that passed into this contract 
    }

    modifier onlyOwner() {
        require (msg.sender == owner, "You are not the owner of the contract.");
        _;
    }

    modifier isOwnerDeceased() {
        require (isDeceased==true, "Contract owner must be deceased for funds to be distributed.");
        _;
    }

    // @dev Declaring a modifier to make sure owner have enough fund to distribute
    modifier enoughFund(uint fundToBeDistrubute) {
        require (fundToBeDistrubute <= remainingFund, "Not enough fund to distribute");
        _;
    }

    // @dev Declaring the structure of beneficiary. This strucut will be holding beneficiary information 
    struct beneficiaryInformation {
        address payable beneficiaryAddress;
        uint beneficiaryAmt;
    }
    // @dev Declaring a array of beneficiaryInformation
    beneficiaryInformation[] public beneficiary; 
    // @dec function to set inheritance details
    function setInheritance(address payable _account, uint _inheritAmt) public onlyOwner enoughFund(_inheritAmt) {
        beneficiary.push(beneficiaryInformation(_account, _inheritAmt));
        remainingFund -= _inheritAmt; // @dev update the remaining fund
    }

    // @dev Updated the distributeFunds() function
    // @dev loop through a arrary of "beneficiaryInformation" instead of a arrary a mapping key
    function distributeFunds() private isOwnerDeceased {
        for (uint i=0; i<beneficiary.length; i++) {
            beneficiary[i].beneficiaryAddress.transfer(beneficiary[i].beneficiaryAmt);
        }
    }        
    
    // QUESTION? How would this function get called if the owner is deceased? 
    function deceased() public onlyOwner {
        isDeceased = true;
        distributeFunds();
    }

    // @dev function to translate the value entered in Ether to Wei.
    function EthToWei (uint _ethInput) public pure returns (uint) {
        return _ethInput * (10**18);
    }

}