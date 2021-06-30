import { ethers } from "hardhat";

const EXPIRATION_TIMESTAMP = 1625629498;

async function main() {
  const Pool = await ethers.getContractFactory("Pool");
  const pool = await Pool.deploy(EXPIRATION_TIMESTAMP);

  console.log("Deploying Pool...");
  console.log("pool deployed to:", pool.address);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
