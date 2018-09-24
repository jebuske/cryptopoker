var CryptoPoker = artifacts.require("./CryptoPoker.sol");

module.exports = function(deployer) {
  deployer.deploy(CryptoPoker, 250000000000000000);
};
