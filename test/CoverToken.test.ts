const { expect } = require("chai");
import { ethers } from "hardhat";

describe("CoverToken", function () {
  it("Should return the right name and symbol", async function () {
    const CoverToken = await ethers.getContractFactory("CoverToken");
    const coverToken = await CoverToken.deploy("CoverToken", "COV");
    
    console.log("coverToken deployed to:", coverToken.address);

    expect(await coverToken.name()).to.equal("CoverToken");
    expect(await coverToken.symbol()).to.equal("COV");
  });
});
