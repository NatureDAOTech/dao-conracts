// We require the Hardhat Runtime Environment explicitly here. This is optional
// but useful for running the script in a standalone fashion through `node <script>`.
//
// When running the script with `npx hardhat run <script>` you'll find the Hardhat
// Runtime Environment's members available in the global scope.
const hre = require("hardhat");
const { ethers } = require("hardhat");

async function main() {
  // Hardhat always runs the compile task when running scripts with its command
  // line interface.
  //
  // If this script is run directly using `node` you may want to call compile
  // manually to make sure everything is compiled
  // await hre.run('compile');

  // We get the contract to deploy

  [player1] = await ethers.getSigners()
  const NDAOICO = await hre.ethers.getContractFactory("NDAOICO");
  const NDAOTOKEN = await hre.ethers.getContractFactory("NDAO")
  const anikCoin = await  hre.ethers.getContractFactory("Anyx")
  const VESTING = await hre.ethers.getContractFactory("NDAOVesting")
  const CommunityTreasury = await hre.ethers.getContractFactory("DAOMultisig")

  let token = await NDAOTOKEN.deploy(player1.address, player1.address, player1.address)
  console.log("NDao address: ", token.address)

  // console.log()
  let stable = await  anikCoin.deploy()
  console.log("AnikCoin address: ", stable.address)

  let ico = await NDAOICO.deploy(stable.address, token.address)
  console.log("ICO address: ", ico.address)

  let communityTreasury = await  CommunityTreasury.deploy([player1.address, player1.address, player1.address, player1.address, player1.address])
  console.log("CommunityTreasury address: ", communityTreasury.address)


  let vesting = await VESTING.deploy(token.address,[player1.address, player1.address, player1.address], [player1.address,player1.address],
            player1.address, player1.address, communityTreasury.address)
  console.log("Vesting address: ", vesting.address)
  console.log("Player1 address: ", player1.address)
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
