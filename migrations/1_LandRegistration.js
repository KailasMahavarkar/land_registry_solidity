var LandRegistry = artifacts.require("LandRegistry");

module.exports = function (deployer) {
  // deployment steps
  deployer.deploy(LandRegistry);
};
