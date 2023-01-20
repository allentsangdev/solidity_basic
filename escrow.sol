// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract Escrow {

    //this enum stores the current state of the transcation
    enum State {AWAITING_PAYMENT, AWAITING_DELIVERY, COMPLETE} // declare a custom data type

    // variable to hold the State
    State public currentState;

    //buyer address
    address public buyer;

    //seller address
    address payable public seller;

    //developer's address
    //***** Try to look for a way to indentify owner of the contract *****
    address public owner;

    // Ensure that only the buyer can call functions the modifier is attached to
    modifier onlyBuyer() {
        require(msg.sender==buyer, "Only the buyer can call this function!");
        _;
    }

    // Ensure that only the seller can call functios the modifier is attached to
    modifier onlySeller() {
        require(msg.sender==seller, "Only the buyer can call this function!");
        _;
    }

    // Ensure that only the seller can call functios the modifier is attached to
    modifier onlyOwner() {
        require(msg.sender==owner, "Only the contract owner only can initialze this contract");
        _;
    }


    //Set up the buyer and seller addresses
    constructor(address _buyer, address payable _seller, address _owner ) {
        buyer = _buyer;
        seller = _seller;
        owner = _owner;
    }

    // only the Buyer can call this function to deposit Ether to the contract
    function deposit() onlyBuyer external payable {
        require(currentState==State.AWAITING_PAYMENT, "Buyer has already deposited Ether to the contract");
        currentState = State.AWAITING_DELIVERY;
    } 

    // the buyer calls this function to confirm that they have received the item for sale
    function comfirmDelivery() onlySeller external {
        require(currentState==State.AWAITING_DELIVERY, "Delivery has not been confirmed!");
        seller.transfer(address(this).balance);
        currentState = State.COMPLETE;
    } 

    function initializeContract() public {
        require(currentState == State.COMPLETE, "The transaction is not yet complete");
        currentState = State.AWAITING_PAYMENT;
    } 

    function getBalance() public view returns(uint) {
        return address(this).balance;
    }

}