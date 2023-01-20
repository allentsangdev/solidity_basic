//---------------------------------------------------------------
// Game Logic - ROCK, PAPER, SCISSORS:
// 1. There will be 2 players. First player to join the game will be player1
//     and the second to join will the player2. 
//
// 2. Both player need to pay the stake before joining the game. Minimum stake is hardcoded as 1 ETH. 
//
// 3. Stake will be devoted into the total stake pool. Winners gets all devoted stake. If its a tie game,
//    each player gets back their devoted stake 
//
// 4. Game will reset after revealing last round's result
//---------------------------------------------------------------

// SPDX-License-Identifier: MIT
// pragma solidity ^0.5.0;
// Updating complier version to use string.concat
pragma solidity ^0.8.17;
import "@openzeppelin/contracts/utils/Strings.sol"; // Import OpenZeppeline library to use string.concat

contract RockPaperScissor {

    // 2 player game
    address payable private player1;
    address payable private player2;

    // To store players choices
    string private player1choice;
    string private player2choice;

    // To keep track of has players made choices
    bool private hasPlayer1MadeChoice;
    bool private hasPlayer2MadeChoice;    

    // In order to play the game, the player has to pay!
    uint public minimumStake; // Minimum stake to pay
    uint public totalStake; // Total stake pool
    uint public player1Stake;
    uint public player2Stake;

    // The following is a nested mapping, which contains all possiable game results
    mapping(string=>mapping(string=>uint8)) private states;

    // R - ROCK 
    // P - PAPER
    // S - SCISSORS
    // 0 - TIE
    // 1 = PLAYER 1 WINS
    // 2 = PLAYER 2 WINS

    constructor() {
        states['R']['R'] = 0;
        states['R']['P'] = 2;
        states['R']['S'] = 1;
        states['P']['R'] = 1;
        states['P']['P'] = 0;
        states['P']['S'] = 2;
        states['S']['R'] = 2;
        states['S']['P'] = 1;
        states['S']['S'] = 2;
        minimumStake = 1 ether; 
    }

    // MODIFIERS
    modifier isJoinable() {
        require(player1 == address(0) || player2 == address(0), "There are already 2 players!" );
        // To make sure player pay enough stake before joining the game
        require(msg.value>=minimumStake, string.concat("You must pay the stake to play the game, stake must be greater or equal to ", Strings.toString(minimumStake)));
        //require(player1 != address(0) && msg.value == stake || (player1 == address(0)), "Player1 You have to pay the stake to play the game!");
        //require(player2 != address(0) && msg.value == stake, "You have to pay the stake to play the game!");
        _; 
    }

    modifier isPlayer() {
        require(msg.sender == player1 || msg.sender == player2, "You are not a player in the game!");
        _;
    }

    modifier isValidChoice(string memory _playerChoice) {
        require(keccak256(bytes(_playerChoice)) == keccak256(bytes('R')) ||
            keccak256(bytes(_playerChoice)) == keccak256(bytes('P')) ||
            keccak256(bytes(_playerChoice)) == keccak256(bytes('S')),
            "Choice must be Rock, Paper, or Scissors!"); 
        _;
    }

    modifier hasPlayerMadeChoice() {
        require(hasPlayer1MadeChoice && hasPlayer2MadeChoice, "Both players must make a choice!");
        _;
    }

    // FUNCTIONS

    function join() external payable isJoinable() {
        if(player1 == address(0)) {
            player1 = payable (msg.sender);
            // player1 will determine stake
            totalStake += msg.value;
            player1Stake = msg.value;
        } else {
            player2 = payable (msg.sender);
            totalStake += msg.value;
            player2Stake = msg.value;
        }
    }

    function makeChoice(string memory _playerChoice) public isPlayer() isValidChoice(_playerChoice){
        if (msg.sender == player1) {
            player1choice = _playerChoice;
            hasPlayer1MadeChoice = true;
        } else if (msg.sender == player2) {
            player2choice = _playerChoice;
            hasPlayer2MadeChoice = true;
        }
    }

    function resetGame() public {
        player1 = payable (address(0));
        player2 = payable (address(0));
        player1choice = "";
        player2choice = "";
        hasPlayer1MadeChoice = false;
        hasPlayer2MadeChoice = false;
        totalStake = 0 ether;
    }
    function revealResult() public isPlayer() hasPlayerMadeChoice() returns(string memory _gameResult)
  {
        // only the 2 players can reveal the game results, and 
        // results can only be disclosed after both players have made their choices
        uint8 result = states[player1choice][player2choice];
        string memory gameResult;
        if (result == 0) {
            player1.transfer(player1Stake);
            player2.transfer(player2Stake);
            gameResult =  "Tie Game";
        } else if (result == 1){
            player1.transfer(address(this).balance);
            gameResult = "Player1 Wins!";
        } else if (result == 2) {
            player2.transfer(address(this).balance);
            gameResult = "Player2 Wins!";
        }
        // Reset the game
        resetGame();
        return gameResult;
    }

    function displayPlayerAddress() public view returns(address, address) {
        return (player1,player2);
    }

    function displayPlayerChoice() public view returns(string memory, string memory) {
        return (player1choice,player2choice);
    }

    function displayHasPlayerChoice() public view returns(bool,bool) {
        return (hasPlayer1MadeChoice,hasPlayer2MadeChoice);
    }

}