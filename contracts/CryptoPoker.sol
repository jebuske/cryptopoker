pragma solidity ^0.4.18;

import "./Pausable.sol";

//contract CryptoPoker is Pausable and therefore it is Owned. By making it pausable we can pause the contract in case something would be wrong to avoid further damage.
contract CryptoPoker is Pausable {

//player struct that keeps track of the address, if the player did a rebuy/addon, if he's bust or still in the game
  struct Player {
    bool rebought;
    bool addon;
    bool bust;
    bool stillIn;
  }

  //public variables
  bool public rebuyState;
  uint public tournamentFee;
  uint public tournamentStake;
  bool public addonState;
  uint public stake;
  uint public playersIn;
  bool public depositState;

  address[] public registeredPlayers;

  //mapping that maps the addresses of the players to the playerstruct
  mapping(address => Player) players;
  //mapping to save the withdrawal amounts that the winners can withdraw
  mapping(address => uint) withdrawals;

  //events
  event LogPlayerDeposit(address sender, uint value);
  event LogPlayerRebuy(address sender, uint value);
  event LogPlayerAddon(address sender, uint value);
  event LogPlayerBusted(address sender, uint playerBusted);
  event LogPlayerOut(address sender, uint playerOut);
  event LogWithdrawal(uint amount, address sender);
  event LogWinners(address first, address second, address third, address fourth, address fifth);
  event LogPayouts(uint payout1, uint payout2, uint payout3, uint payout4, uint payout5);

  //modifier that only allows you to rebuy when the rebuys are open
  modifier rebuyOpen(){
    require(rebuyState==true);
    _;
  }

  modifier addonsOpen(){
    require(addonState == true);
    _;
  }

  //constructor function that takes on argument, the stake of the tournament. Creation of the contract opens the deposits.
  function CryptoPoker(uint _stake){

    stake = _stake;
    addonState=false;
    depositState = true;
    rebuyState = true;
    }
  

  //getter function to get the tournament buyin
  function getStake() constant returns (uint stake){
    return stake;
  }

  //getter function to get a player's address by the playerid
  function getPlayer(uint _playerid) constant returns (address user){
    return registeredPlayers[_playerid];
  }

  //function to open/close the addons
  function setAddonState (bool _addonState)
  fromOwner
  returns (bool success){
    require(addonState != _addonState);
    addonState = _addonState;
    return true;
  }

  //getter function to see the total stake of the tournament
  function getTournamentStake()
  returns (uint tournamentStake)
  {
    return tournamentStake;
  }

  //function to close the rebuys
  function closeRebuy()returns(bool success){
    rebuyState = false;
    return true;
  }

  //function to open/close the deposits
  function closeDeposits()
  fromOwner
  returns (bool success){
    depositState = false;
    return true;
  }

  //the deposit function. You should send the exact tournament stake. Max 24 players. The same address can't deposit twice.
  function deposit()
  whenNotPaused
  payable
  returns (bool success){
    require(playersIn<24);
    require(depositState != false);
    require(msg.value == stake);
    require(players[msg.sender].stillIn==false);

    tournamentStake += msg.value;

    players[msg.sender].stillIn=true;
    playersIn +=1;
    registeredPlayers.push(msg.sender);
    LogPlayerDeposit(msg.sender, msg.value);
    return true;
  }

  //function to rebuy. Only possible when rebuys are open. You should send the exact amount. Players can only rebuy once.
  function rebuy()
  whenNotPaused
  rebuyOpen
  payable 
  returns (bool success){
    require(players[msg.sender].bust==true);
    require(msg.value == stake);
    require(players[msg.sender].rebought == false);
    tournamentStake += msg.value;
    players[msg.sender].rebought=true;
    LogPlayerRebuy(msg.sender, msg.value);
    return true;
  }

  function hasRebought() constant returns (bool rebought){
    return players[msg.sender].rebought;
  }

  //function to addon. You should send the exact amount. Only possible when addons are open
  function addon()
  whenNotPaused
  addonsOpen
  payable 
  returns (bool success){
  require(players[msg.sender].addon == false);
  require(players[msg.sender].stillIn == true);
  require(msg.value == stake);
  players[msg.sender].addon = true;
  tournamentStake += msg.value;
  LogPlayerAddon(msg.sender, msg.value);
  return true;
  }

  //function that takes on argument, the playerId of the busted player. If a player is bust he can rebuy once and stays marked "bust". Second time he goes bust he is out 4 ever.
  //function can be called by the owner of the contract only.
  function playerBusted(uint _playerId)
  fromOwner
  returns (bool success){
    require(playersIn >5);
    require(players[getPlayer(_playerId)].bust != true);
    require(players[getPlayer(_playerId)].stillIn != false);
    players[getPlayer(_playerId)].bust = true;
    LogPlayerBusted(msg.sender, _playerId);
    return true;
  }
  
  //function to check if player is still in
  function getPlayerStillIn(uint _playerId) constant
  returns (bool stillIn){
       return players[getPlayer(_playerId)].stillIn;
  }

  //function that takes one argument, the playerId of the player that is out for ever. Only possible to call this function as long as there are more than 5 people playing.
  //Function can be called by the owner of the contract only
  function playerOut4ever(uint _playerId) 
  fromOwner
  returns (bool success){
    require(players[getPlayer(_playerId)].stillIn != false);
    require(playersIn >5);
    players[getPlayer(_playerId)].stillIn = false;
    playersIn-=1;
    LogPlayerOut(msg.sender, _playerId);
    return true;
  }

  //function that determines the winners. It takes 5 arguments and devides the prize pool between the five winners.
  //function can be called by the owner of the contract only
  function determineWinners(uint _first, uint _second, uint _third, uint _fourth, uint _fifth)
  fromOwner
  returns (bool succes){
    require(playersIn == 5);
    require(players[getPlayer(_first)].stillIn == true);
    require(players[getPlayer(_second)].stillIn == true);
    require(players[getPlayer(_third)].stillIn == true);
    require(players[getPlayer(_fourth)].stillIn == true);
    require(players[getPlayer(_fifth)].stillIn == true);
    uint payout1 = (37*tournamentStake)/100;
    uint payout2 = (26*tournamentStake)/100;
    uint payout3 = (185*tournamentStake)/1000;
    uint payout4 = (11*tournamentStake)/100;
    uint payout5 = (75*tournamentStake)/1000;
    withdrawals[getPlayer(_first)] = payout1;
    withdrawals[getPlayer(_second)] = payout2;
    withdrawals[getPlayer(_third)] = payout3;
    withdrawals[getPlayer(_fourth)] = payout4;
    withdrawals[getPlayer(_fifth)] = payout5;
    LogWinners(getPlayer(_first), getPlayer(_second), getPlayer(_third), getPlayer(_fourth), getPlayer(_fifth));
    LogPayouts(payout1,payout2, payout3, payout4, payout5);
    return true;
  }

  //withdraw function that allows the winners of the tournament to withdraw their winnings
   function withdraw () returns (bool success) {
    require(withdrawals[msg.sender]>0);
    uint amount = withdrawals[msg.sender];
    withdrawals[msg.sender] = 0;
    msg.sender.transfer(amount);
    LogWithdrawal(amount, msg.sender);
    return true;
  }

}





