import { BigNumber } from "@ethersproject/bignumber";
import { expect } from "chai";
import { ethers } from "hardhat";
import { daiTokenAbi } from "../abis/DaiToken";

const PAYMENT_TOKEN_ADDRESS = "0x6B175474E89094C44Da98b954EedeAC495271d0F"; // DAI Token address
const EXPIRATION_TIMESTAMP = 1625629498;

describe("Pool", function () {
  let deployer: any;
  let daiToken: any;
  let coverToken: any;
  let premToken: any;
  let pool: any;

  before("...should make a DAI token contract instance", async function () {
    try {
      [deployer] = await ethers.getSigners();
    } catch (e) {
      console.log(e);
    }

    // const provider = ethers.getDefaultProvider();
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

    coverToken = await CoverToken.deploy("CoverToken", "COV");
    premToken = await PremToken.deploy("PremToken", "PRM");
    pool = await Pool.deploy(
      PAYMENT_TOKEN_ADDRESS,
      coverToken.address,
      premToken.address,
      EXPIRATION_TIMESTAMP
    );

    console.log("Deploying Pool...");
    console.log("pool deployed to:", pool.address);
  });

  it("...should set the correct expiration timestamp value", async () => {
    expect(await pool.expirationTimestamp()).to.equal(1625629498);
  });

  it("...should approve 10 DAI", async () => {
    await daiToken.approve(
      pool.address,
      BigNumber.from(10).mul(BigNumber.from(10).pow(18))
    );
    expect(await daiToken.allowance(deployer.address, pool.address)).to.equal(
      BigNumber.from(10).mul(BigNumber.from(10).pow(18))
    );
  });

  it("...should mint 10 coverage tokens to a buyer", async () => {
    await pool.buyCoverage(BigNumber.from(5).mul(BigNumber.from(10).pow(18)));
    expect(await coverToken.balanceOf(deployer.address)).to.equal(
      BigNumber.from(10).mul(BigNumber.from(10).pow(18))
    );
  });

  it("...should mint 2 premium tokens to a seller", async () => {
    await pool.sellCoverage(BigNumber.from(4).mul(BigNumber.from(10).pow(18)));
    expect(await premToken.balanceOf(deployer.address)).to.equal(
      BigNumber.from(2).mul(BigNumber.from(10).pow(18))
    );
  });
});
