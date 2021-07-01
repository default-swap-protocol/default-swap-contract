const { expect } = require("chai");
import { ethers } from "hardhat";

describe("SampleMapleLoanContract", function () {
  let sampleMapleLoanContract: any;
  before("..._loanDefaulted should return false", async function () {
    const SampleMapleLoanContract = await ethers.getContractFactory(
      "SampleMapleLoanContract"
    );
    sampleMapleLoanContract = await SampleMapleLoanContract.deploy();

    console.log(
      "sampleMapleLoanContract deployed to:",
      sampleMapleLoanContract.address
    );

    expect(await sampleMapleLoanContract.loanDefaulted()).to.equal(false);
  });

  it("...should change the _loanDefaulted value to true", async function () {
    await sampleMapleLoanContract.setLoanState(true);
    expect(await sampleMapleLoanContract.loanDefaulted()).to.equal(true);
  });
});
