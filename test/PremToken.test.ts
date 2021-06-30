const { expect } = require("chai");
import { ethers } from "hardhat";

describe("PremToken", function () {
  it("Should return the right name and symbol", async function () {
    const PremToken = await ethers.getContractFactory("PremToken");
    const premToken = await PremToken.deploy("PremToken", "PRM");

    console.log("premToken deployed to:", premToken.address);

    expect(await premToken.name()).to.equal("PremToken");
    expect(await premToken.symbol()).to.equal("PRM");
    expect(await premToken.totalSupply()).to.equal(10000);
  });
});
