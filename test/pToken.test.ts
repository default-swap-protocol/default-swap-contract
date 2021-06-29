const { expect } = require("chai");
import { ethers } from "hardhat";

describe("pToken", function () {
  it("Should return the right name and symbol", async function () {
    const pToken = await ethers.getContractFactory("pToken");
    const pTokenInstance = await pToken.deploy("pToken", "PRM");
    
    console.log("pTokenInstance deployed to:", pTokenInstance.address);

    expect(await pTokenInstance.name()).to.equal("pToken");
    expect(await pTokenInstance.symbol()).to.equal("PRM");
  });
});
