//SPDX-License-Identifier: MIT  
pragma solidity ^0.6.6;

contract CrowdFunder {
    // contract owner
    address public owner;

    // recipient of the crowd fund which may not be the same as the contract owner
    address payable public fundRecipient;

    // Has the funding goal been reached in the set amount of time?
    // If not, the contributors get their money back.

    uint public minimumToRaise;

    string campaignURL;
    byte version = "1";

    // STRUCTURES

    enum State {Fundraising, ExpiredRefund, Successful}

    struct Contribution {
        uint amount;
        address payable contributor;
    }

    // STATE VARIABLES

    State public state = State.Fundraising;
    uint public totalRaised;
    uint public raiseBy;
    uint public completeAt;
    Contribution[] contributions;

    // EVENTS
    event LogFundingReceived(address addr, uint amount, uint currentTOtal);
    event LogRecipientPaid(address recipientAddress);

    // MODIFIERS
    modifier inState(State _state) {
        require(state == _state, "");
        _;
    }

    modifier isOwner() {
        require(msg.sender == owner);
        _;
    }

    modifier atEndOfLifecycle() {
        require(((state==State.ExpiredRefund || state==State.Successful) && completeAt + 2 weeks < now));
        _;
    }

    // FUNCTIONS

    function crowdFund(uint _timeInHoursForFundraising, string memory _campaignURL,
                         address payable _fundRecipient, uint _minimumToRaise) public {
        owner = msg.sender;
        fundRecipient = _fundRecipient;
        campaignURL = _campaignURL;
        minimumToRaise = _minimumToRaise;
        raiseBy = now + (_timeInHoursForFundraising * 1 hours);
    }

    function contribute() public payable inState(State.Fundraising) returns (uint id) {
        // using an array which we can iterate over
        contributions.push(Contribution({amount:1, contributor:msg.sender}));
        totalRaised += 1;
        emit LogFundingReceived(msg.sender, 1, totalRaised);
        checkIfFundingCompleteOrExpired();
        // returns the id, which is the current contributions index
        return contributions.length - 1;

    }

    function checkIfFundingCompleteOrExpired() public {
        if (totalRaised > minimumToRaise) {
            state = State.Successful;
            payout();
        } else if (now > raiseBy) {
            // Contributor to the successful crowd funding can now ask for a refund.
            // They will do that by calling the function getRefund(id)
            state = State.ExpiredRefund;
        }
        completeAt = now;
    }

    function payout() public inState(State.Successful) {
        fundRecipient.transfer(address(this).balance);
        emit LogRecipientPaid(fundRecipient);
    }

    function getRefund(uint _id) inState(State.ExpiredRefund) public returns (bool) {
        require(contributions.length > _id && _id >= 0 && contributions[_id].amount != 0);
        uint amountToRefund = contributions[_id].amount;
        // ZERO the amount before doing the transfer!
        contributions[_id].amount = 0;
        contributions[_id].contributor.transfer(amountToRefund);
        return true;
    }

    function removeContract() public isOwner() atEndOfLifecycle() {
        // contract owner will reveive any remaining Ether in the smart contract
        // The selfdestruct function removes all bytecode from the  blockchain, and sends Ether to the address. 
        
        selfdestruct(msg.sender);
    }


}