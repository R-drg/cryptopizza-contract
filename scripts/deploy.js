const { ethers } = require("hardhat");

const pizzasData = {
  names: ["Pepperoni Pizza", "Cheese Pizza", "Marguerita Pizza"],
  descriptions: [
    "Tomato sauce, pepperoni, mozzarella cheese",
    "Tomato sauce, cheese, oregano",
    "Tomato sauce, cheese, basil",
  ],
  prices: [
    ethers.utils.parseEther("0.02"),
    ethers.utils.parseEther("0.025"),
    ethers.utils.parseEther("0.03"),
  ],
};

const imageURI =
  "https://gateway.pinata.cloud/ipfs/Qmckm5C1k47HH5yYuYAcmVFSnxzUcBeEXwx1Zhhdbjmvm9";

async function main() {
  const CryptoPizza = await hre.ethers.getContractFactory("CryptoPizza");
  const cryptoPizza = await CryptoPizza.deploy(
    pizzasData.names,
    pizzasData.descriptions,
    pizzasData.prices,
    imageURI
  );


  await cryptoPizza.deployed();

  console.log("CryptoPizza deployed to:", cryptoPizza.address);

}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
