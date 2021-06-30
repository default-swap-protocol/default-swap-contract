const { expect } = require("chai");
import { ethers } from "hardhat";

const PAYMENT_TOKEN_ADDRESS = "0x6B175474E89094C44Da98b954EedeAC495271d0F"; // DAI Token address
const EXPIRATION_TIMESTAMP = 1625629498;

describe("Pool", function () {
  it("Should create a pool", async function () {
    const Pool = await ethers.getContractFactory("Pool");
    const pool = await Pool.deploy(PAYMENT_TOKEN_ADDRESS, EXPIRATION_TIMESTAMP);

    console.log("Deploying Pool...");
    console.log("pool deployed to:", pool.address);

    expect(await pool.paymentTokenAddress()).to.equal(
      "0x6B175474E89094C44Da98b954EedeAC495271d0F"
    );
    expect(await pool.expirationTimestamp()).to.equal(1625629498);
  });
});
