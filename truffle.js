// Allows us to use ES6 in our migrations and tests.
require('babel-register')

var HDWalletProvider = require("truffle-hdwallet-provider");
var mnemonic = "fan moment manage myth team maple jelly spin tube loyal rookie gather";
module.exports = {
  networks: {
    development: {
      host: '127.0.0.1',
      port: 8545,
      network_id: '*' // Match any network id
    },
    ropsten: {
      provider: function() {
        return new HDWalletProvider(mnemonic, "https://ropsten.infura.io/v3/0f593fdfb84f4a4ea6e331212eff122f")
      },
      network_id: 3,
      // from:"0x14c19910d27F85f069e152DB26D65796Cb65BEF8",
      gas:"2700000"
    }
  }
}