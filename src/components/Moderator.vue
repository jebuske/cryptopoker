/* eslint-disable */
<template>
 <div class="container">
    <h1>Crypto Poker moderator</h1>
    <div class="account">
      <p v-if="contractAddress">The contract is deployed at {{contractAddress}}</p>
      <p v-if="!contractAddress">No contracts found</p>
      <p v-if="account">Current account: {{account}}. Please make sure this is the address you've registered with.</p>
      <p v-if="!account">No accounts found</p>
    </div>
    <div class="setStates">
        <div class="depositState">
            <button type='button' @click='disableDeposits'>Disable Deposits</button>
        </div>
        <div class="rebuyState">
            <button type='button' @click='disableRebuys'>Close Rebuys</button>
        </div>
        <div class="addonState">
            <button type='button' @click='disableAddons'>Close addons</button>
            <button type='button' @click='enableAddons'>Open addons</button>        
        </div>
    </div>
    <div class="markPlayersOut">
      <p>Here you can put in the player ID of the player who is busted (will rebuy) or out forever.</p>
      <input v-model='playerid' placeholder="put the player id here">
      <button type='button' @click='playerBusted'>Player busted</button>
      <button type='button' @click='playerOut4Ever'>Player out forever</button>
    </div>
    <div class="Determine winners">
      <p>Below you can put the player ID's of the winners</p>
      <p>Winner: </p><input v-model='first' placeholder="player id of the winner">
      <p>Second: </p><input v-model='second' placeholder="player id of the second">
      <p>Third: </p><input v-model='third' placeholder="player id of the third">
      <p>Fourth: </p><input v-model='fourth' placeholder="player id of the fourth">
      <p>Fifth: </p><input v-model='fifth' placeholder="player id of the fifth">
      <p>Warning! Only press the button below if you are 100% sure you want to send the winners</p>
      <button type='button' @click='determineWinners'>Send winners to the contract</button>
    </div>
    <div class="logs">
        {{this.message}}
    </div>
  </div>
</template>

<script>
import Web3 from 'web3'
import contract from 'truffle-contract'
import artifacts from '../../build/contracts/CryptoPoker.json'
const CryptoPoker = contract(artifacts)

export default {
  name: 'BoothHolder',
  data() {
    return {
      playerid: null,
      newDepositState: null,
      newAddonState: null,
      newRebuyState: null,
      message: null,
      valueSent: null,
      contractAddress: '0x605d5aa14ba611515e85cf5ab6b684db7dd11334',
      account: null,
      depositValue: null,
      sender: null,
      first: null,
      second: null,
      third: null,
      fourth: null,
      fifth: null,
    }
  },
  created() {
    if (typeof web3 !== 'undefined') {
      console.warn("Using web3 detected from external source. If you find that your accounts don't appear or you have 0 Fluyd, ensure you've configured that source properly. If using MetaMask, see the following link. Feel free to delete this warning. :) http://truffleframework.com/tutorials/truffle-and-metamask")
      // Use Mist/MetaMask's provider
      web3 = new Web3(web3.currentProvider)
    } else {
      console.warn("No web3 detected. Falling back to http://127.0.0.1:9545. You should remove this fallback when you deploy live, as it's inherently insecure. Consider switching to Metamask for development. More info here: http://truffleframework.com/tutorials/truffle-and-metamask")
      // fallback - use your fallback strategy (local node / hosted node + in-dapp id mgmt / fail)
      web3 = new Web3(new Web3.providers.HttpProvider("http://127.0.0.1:9545"))
    }
    CryptoPoker.setProvider(web3.currentProvider)
    web3.eth.getAccounts((err, accs) => {
      if (err != null) {
        console.error(err)
        this.message = "There was an error fetching your accounts. Do you have Metamask, Mist installed or an Ethereum node running? If not, you might want to look into that"
        return
      }
      if (accs.length == 0) {
        this.message = "Couldn't get any accounts! Make sure your Ethereum client is configured correctly."
        return
      }
      this.account = accs[0];
    })
  },
  methods: {
    disableDeposits() {
      var cryptoPokerInstance = CryptoPoker.at(this.contractAddress);
      return cryptoPokerInstance.closeDeposits({
          from: this.account,
          
        })
    },
    disableDeposits() {
      var cryptoPokerInstance = CryptoPoker.at(this.contractAddress);
      return cryptoPokerInstance.closeRebuy({
          from: this.account,
        })
    },
    disableAddons() {
      var cryptoPokerInstance = CryptoPoker.at(this.contractAddress);
      return cryptoPokerInstance.setAddonState(false,{
          from: this.account,
        })
    },
    enableAddons() {
      var cryptoPokerInstance = CryptoPoker.at(this.contractAddress);
      return cryptoPokerInstance.setAddonState(true,
      {
          from: this.account,
        })
    },
    playerBusted() { 
      var cryptoPokerInstance = CryptoPoker.at(this.contractAddress);

      return cryptoPokerInstance.playerBusted(this.playerid,
        {
          from: this.account,
        })
    },
    playerOut4Ever() { 
      var cryptoPokerInstance = CryptoPoker.at(this.contractAddress);

      return cryptoPokerInstance.playerOut4ever(this.playerid,
        {
          from: this.account,
        })
    },
    determineWinners() { 
      var cryptoPokerInstance = CryptoPoker.at(this.contractAddress);
      
      return cryptoPokerInstance.determineWinners(this.first, this.second, this.third, this.fourth, this.fifth,
        {
          from: this.account,
        })
    },
}
}


</script>

<style lang="css" scoped>
</style>