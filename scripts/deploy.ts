import { ethers } from "hardhat";

async function main() {
  const myToken = await ethers.deployContract("MyToken");

  await myToken.waitForDeployment();

  console.log(`Token deployed to ${myToken.target}`);

  const myAirdrop = await ethers.deployContract("Distribution", [
    9768,
    myToken.target,
  ]);

  await myAirdrop.waitForDeployment();

  console.log(`Distribution Contract deployed to ${myAirdrop.target}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
