const { expect } = require("chai");
import { ethers } from "hardhat";

const PAYMENT_TOKEN_ADDRESS = "0x6B175474E89094C44Da98b954EedeAC495271d0F"; // DAI Token address
const EXPIRATION_TIMESTAMP = 1625629498;

describe("Pool", function () {
  it("Should create a pool", async function () {
    const CoverToken = await ethers.getContractFactory("CoverToken");
    const PremToken = await ethers.getContractFactory("PremToken");
    const Pool = await ethers.getContractFactory("Pool");

    const coverToken = await CoverToken.deploy("CoverToken", "COV");
    const premToken = await PremToken.deploy("PremToken", "PRM", 10000);
    const pool = await Pool.deploy(
      PAYMENT_TOKEN_ADDRESS,
      coverToken.address,
      premToken.address,
      EXPIRATION_TIMESTAMP
    );

    console.log("Deploying Pool...");
    console.log("pool deployed to:", pool.address);

    expect(await pool.paymentTokenAddress()).to.equal(
      "0x6B175474E89094C44Da98b954EedeAC495271d0F"
    );
    expect(await pool.expirationTimestamp()).to.equal(1625629498);
  });
});
