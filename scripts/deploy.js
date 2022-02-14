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

  [player1, player2, player3, player4] = await ethers.getSigners()
  const NDAOICO = await hre.ethers.getContractFactory("NDAOICO");
  const NDAOTOKEN = await hre.ethers.getContractFactory("NDAO")

  let token = await NDAOTOKEN.deploy()

  token = token.deployed()

  await token.setCT (player1.address);
  await token.setCoreTeam (player2.address);
  await token.setAdv (player3.address);
  await token.setAuditors (player4.address);

  let ico = await NDAOICO.deploy(player1.address, token.address, 1644758027, 1000000)
  ico = ico.deployed()
  await token.setGI (ico.address);

  await ico.setStatusToActive();
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
