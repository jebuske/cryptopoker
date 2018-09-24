/* eslint-disable */
<template>
 <div class="container">
    <h1>Crypto Poker player</h1>
    <div class="account">
      <p v-if="contractAddress">The contract is deployed at {{contractAddress}}</p>
      <p v-if="!contractAddress">No contracts found</p>
      <p v-if="account">Current account: {{account}}.Please make sure this is the address you've registered with.</p>
      <p v-if="!account">No accounts found</p>
    </div>
    <div class="interactions">
        <div class="deposit">
            <button type='button' @click='deposit'>Deposit your buy in(0.25ETH) to the contract</button>
        </div>
        <div class="rebuy">
            <button type='button' @click='rebuy'>Rebuy(0.25ETH) if you want to continue playing. Make sure you use the same account as your initial deposit.</button>
        </div>
        <div class="addon">
            <button type='button' @click='addon'>Do an addon of 0.25ETH to increase your stack. Make sure you use the same account as your initial deposit</button>
        </div>
        <div class="withdraw">
            <button type='button' @click='withdraw'>Withdraw your winnings from the contract</button>
        </div>
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
  name: 'CryptoPoker',
  data() {
    return {
      message: null,
      valueSent: null,
      cryptoPokerAddress: null,
      contractAddress: '0x605d5aa14ba611515e85cf5ab6b684db7dd11334',
      account: null,
      depositValue: null,
      sender: null,
      withdrawAmount: null,
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
    deposit() {
      var cryptoPokerInstance = CryptoPoker.at(this.contractAddress);
      this.message = "Transaction started";
      return cryptoPokerInstance.deposit({
          from: this.account,
          value: 250000000000000000
        })
        .then(() => {
          depositEvent = cryptoPokerInstance.LogPlayerDeposit();
          LogPlayerDeposit.watch((error, result) => {
            if (!error) {
              this.sender = "The sender of the tx is " + result.args.sender;
              this.valueSent = "You have made a deposit of: " + result.args.value + " Wei.";
              this.message = "Transaction done." + this.valueSent + this.sender;
            } else {
              console.log(error);
              return
            }
          })
        })
        .catch((e) => {
          console.error(e)
          this.message = "Transaction failed"
        })
    },
    rebuy() {
      var cryptoPokerInstance = CryptoPoker.at(this.contractAddress);
      this.message = "Transaction started";
      return cryptoPokerInstance.rebuy({
          from: this.account,
          value: 250000000000000000
        })
        .then(() => {
          this.message = "Transaction done"
          rebuyEvent = cryptoPokerInstance.LogPlayerRebuy();
          LogPlayerRebuy.watch((error, result) => {
            if (!error) {
              this.sender = "The sender of the tx is " + result.args.sender;
              this.valueSent = "You have made a rebuy of: " + result.args.value + " Wei";
              this.message = "Transaction done." + this.valueSent + this.sender;
            } else {
              console.log(error);
              return
            }
          })
        })
        .catch((e) => {
          console.error(e)
          this.message = "Transaction failed"
        })
    },
    addon() {
      var cryptoPokerInstance = CryptoPoker.at(this.contractAddress);

      this.message = "Transaction started";
      return cryptoPokerInstance.addon({
          from: this.account,
          value: 250000000000000000
        })
        .then(() => {
          this.message = "Transaction done"
          rebuyEvent = cryptoPokerInstance.LogPlayerRebuy();
          LogPlayerAddon.watch((error, result) => {
            if (!error) {
              this.sender = "The sender of the tx is " + result.args.sender;
              this.valueSent = "You have made an addon of: " + result.args.value + " Wei";
            this.message = "Transaction done." + this.valueSent + this.sender;
            } else {
              console.log(error);
              return
            }
          })
        })
        .catch((e) => {
          console.error(e)
          this.message = "Transaction failed"
        })
    },
    withdraw() {
      this.message = "Transaction started";
      return CryptoPoker.deployed()
        .then((instance) => instance.withdraw({
          from: this.account
        }))
        .then(() => {
          this.message = "Transaction done"
          withdrawalEvent = instance.LogWithdrawal();
          LogPlayerRebuy.watch((error, result) => {
            if (!error) {
              this.sender = "The sender of the tx is " + result.args.sender;
              this.withdrawAmount = "You have withdrawn " + result.args.amount + " Wei from the contract.";
              this.message = "Transaction done." + this.withdrawAmount + this.sender;
            } else {
              console.log(error);
              return
            }
          })
        })
        .catch((e) => {
          console.error(e)
          this.message = "Transaction failed"
        })
    },

  }
}


</script>

<style lang="css" scoped>
</style>