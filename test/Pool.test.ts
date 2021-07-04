import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import { ethers } from "hardhat";
import { daiTokenAbi } from "../abis/DaiToken";

const PAYMENT_TOKEN_ADDRESS = "0x6B175474E89094C44Da98b954EedeAC495271d0F"; // DAI Token address
const EXPIRATION_TIMESTAMP = 1625629498;

describe("Pool", function () {
  let deployer: any;
  let address1: any;
  let address2: any;
  let daiToken: any;
  let coverToken: any;
  let premToken: any;
  let sampleMapleLoanContract: any;
  let pool: any;

  before("...should make a DAI token contract instance", async function () {
    try {
      [deployer, address1, address2] = await ethers.getSigners();
    } catch (e) {
      console.log(e);
    }

    daiToken = new ethers.Contract(
      PAYMENT_TOKEN_ADDRESS,
      daiTokenAbi,
      deployer
    );
  });

  before("...should deploy a Pool contract", async function () {
    const CoverToken = await ethers.getContractFactory("CoverToken");
    const PremToken = await ethers.getContractFactory("PremToken");
    const Pool = await ethers.getContractFactory("Pool");
    const SampleMapleLoanContract = await ethers.getContractFactory(
      "SampleMapleLoanContract"
    );

    coverToken = await CoverToken.deploy("CoverToken", "COV");
    premToken = await PremToken.deploy("PremToken", "PRM");
    sampleMapleLoanContract = await SampleMapleLoanContract.deploy();
    pool = await Pool.deploy(
      PAYMENT_TOKEN_ADDRESS,
      coverToken.address,
      premToken.address,
      sampleMapleLoanContract.address,
      EXPIRATION_TIMESTAMP
    );

    console.log("Deploying Pool...");
    console.log("pool deployed to:", pool.address);
  });

  before("...the deployer should approve 10 DAI", async () => {
    await daiToken.approve(
      pool.address,
      BigNumber.from(10).mul(BigNumber.from(10).pow(18))
    );
    expect(await daiToken.allowance(deployer.address, pool.address)).to.equal(
      BigNumber.from(10).mul(BigNumber.from(10).pow(18))
    );
  });

  before("...the address1 should approve 1 DAI", async () => {
    await daiToken
      .connect(address1)
      .approve(pool.address, BigNumber.from(1).mul(BigNumber.from(10).pow(18)));
    expect(
      await daiToken.connect(address1).allowance(address1.address, pool.address)
    ).to.equal(BigNumber.from(1).mul(BigNumber.from(10).pow(18)));
  });

  before("...the address2 should approve 1 DAI", async () => {
    await daiToken
      .connect(address2)
      .approve(pool.address, BigNumber.from(1).mul(BigNumber.from(10).pow(18)));
    expect(
      await daiToken.connect(address2).allowance(address2.address, pool.address)
    ).to.equal(BigNumber.from(1).mul(BigNumber.from(10).pow(18)));
  });

  it("...should set the correct expiration timestamp value", async () => {
    expect(await pool.expirationTimestamp()).to.equal(1625629498);
  });

  it("...should mint 1 coverage tokens to the buyer address1", async () => {
    await pool
      .connect(address1)
      .buyCoverage(BigNumber.from(1).mul(BigNumber.from(10).pow(18)));
    expect(
      await coverToken.connect(address1).balanceOf(address1.address)
    ).to.equal(BigNumber.from(1).mul(BigNumber.from(10).pow(18)));
  });

  it("...should mint 1 coverage tokens to the buyer address2", async () => {
    await pool
      .connect(address2)
      .buyCoverage(BigNumber.from(1).mul(BigNumber.from(10).pow(18)));
    expect(
      await coverToken.connect(address2).balanceOf(address2.address)
    ).to.equal(BigNumber.from(1).mul(BigNumber.from(10).pow(18)));
  });

  it("...should mint 10 premium tokens to the seller deployer", async () => {
    await pool.sellCoverage(BigNumber.from(10).mul(BigNumber.from(10).pow(18)));
    expect(await premToken.balanceOf(deployer.address)).to.equal(
      BigNumber.from(10).mul(BigNumber.from(10).pow(18))
    );
  });

  it("...should NOT allow claiming when there is no default event", async () => {
    await expect(
      pool
        .connect(address1)
        .claimCoverage(BigNumber.from(1).mul(BigNumber.from(10).pow(18)))
    ).to.be.reverted;
  });

  it("...should allow claiming when there is a default event", async () => {
    await sampleMapleLoanContract.setLoanState(true);
    await expect(
      pool
        .connect(address1)
        .claimCoverage(BigNumber.from(1).mul(BigNumber.from(10).pow(18)))
    )
      .to.emit(pool, "CoverageClaimed")
      .withArgs(
        address1.address,
        BigNumber.from(5).mul(BigNumber.from(10).pow(18))
      );
  });

  it("...should NOT allow withdrawal of premium when a swap has NOT expired yet", async () => {
    await expect(pool.withdrawPremium()).to.be.reverted;
  });

  it("...should allow withdrawal of premium when a swap has expired yet", async () => {
    await pool.setIsExpiredTrueForTesting();
    await expect(
      pool.withdrawPremium(BigNumber.from(10).mul(BigNumber.from(10).pow(18)))
    )
      .to.emit(pool, "PremiumWithdrawn")
      .withArgs(
        deployer.address,
        BigNumber.from(2).mul(BigNumber.from(10).pow(18))
      );
  });

  it("...should allow withdrawal of coverage when a swap has expired and a loan did NOT default", async () => {
    await daiToken.approve(
      pool.address,
      BigNumber.from(10).mul(BigNumber.from(10).pow(18))
    );
    await pool.sellCoverage(BigNumber.from(10).mul(BigNumber.from(10).pow(18)));
    await sampleMapleLoanContract.setLoanState(false);
    await expect(
      pool.withdrawCoverage(BigNumber.from(10).mul(BigNumber.from(10).pow(18)))
    )
      .to.emit(pool, "CoverageWithdrawn")
      .withArgs(
        deployer.address,
        BigNumber.from(10).mul(BigNumber.from(10).pow(18))
      );
  });
});
