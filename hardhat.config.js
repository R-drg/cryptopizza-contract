require("@nomiclabs/hardhat-waffle");
require("@nomiclabs/hardhat-etherscan");

const { resolve } = require("path");

const { config } = require("dotenv");

config({ path: resolve(__dirname, "./.env") });

const ALCHEMY_API_URL = process.env.ALCHEMY_API_URL ?? "";

const WALLET_PRIVATE_KEY = process.env.WALLET_PRIVATE_KEY ?? "";

module.exports = {
  solidity: "0.8.15",
  networks: {
    rinkeby: {
      url: ALCHEMY_API_URL,
      accounts: [WALLET_PRIVATE_KEY],
    },
  },
  etherscan: {
  },
};
