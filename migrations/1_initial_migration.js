const token = artifacts.require("BananaToken");

module.exports = function (deployer) {
  deployer.deploy(token);
};