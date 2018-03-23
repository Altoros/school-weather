var Bets = artifacts.require("./Bets.sol");

module.exports = function(deployer) {
  deployer.deploy(Bets);
};
