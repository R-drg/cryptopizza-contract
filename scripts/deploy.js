const { ethers } = require("hardhat");

const pizzasData = {
  names: ["Pepperoni Pizza", "Portuguese Pizza", "Champignon Pizza"],
  descriptions: [
    "Tomato sauce, pepperoni, mozzarella cheese",
    "Tomato sauce, portuguese ham, eggs, mozzarella cheese",
    "Tomato sauce, champignon, mozzarella cheese"
  ],
  prices: [
    ethers.utils.parseEther("0.02"),
    ethers.utils.parseEther("0.025"),
    ethers.utils.parseEther("0.03"),
  ],
  images: [
    "https://i.ibb.co/xhFLTvk/pepperoni.png",
    "https://i.ibb.co/b1mkz2Y/portuguese.png",
    "https://i.ibb.co/qsGnXDS/champignon.png"
  ]
};

const imageURI =
  "https://gateway.pinata.cloud/ipfs/Qmckm5C1k47HH5yYuYAcmVFSnxzUcBeEXwx1Zhhdbjmvm9";

async function main() {
  const CryptoPizza = await hre.ethers.getContractFactory("CryptoPizza");
  const cryptoPizza = await CryptoPizza.deploy(
    pizzasData.names,
    pizzasData.descriptions,
    pizzasData.prices,
    pizzasData.images,
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
