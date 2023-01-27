require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config()

const URL = process.env.URL;
const PRIVATE_KEY = process.env.PRIVATE_KEY;

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.17",
  networks: {
    goerli: {
      url: `https://goerli.infura.io/v3/${URL}`,
      accounts: [PRIVATE_KEY],
    },
  }
};
