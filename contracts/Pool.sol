// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./SampleMapleLoanContract.sol";

contract Pool is SampleMapleLoanContract {
  uint256 expirationTimestamp;
  bool isExpired;
  uint256 premiumPool;
  uint256 coveragePool;
  // address of the acceptable token address both for premium and coverage payment
  IERC20 public paymentToken;
  IERC20 public coverToken;
  IERC20 public premToken;

  constructor(
    IERC20 _paymentToken,
    IERC20 _coverToken,
    IERC20 _premToken,
    uint256 _expirationTimestamp
  ) {
    paymentToken = _paymentToken;
    coverToken = _coverToken;
    premToken = _premToken;
    expirationTimestamp = _expirationTimestamp;
  }

  modifier onlyWhenExpired() {
    require(isExpired == true, "a loan hasn't expired yet");
    _;
  }

  modifier onlyWhenDefault() {
    require(SampleMapleLoanContract.hasDefaulted() == true, "a loan didn't default");
    _;
  }

  function setIsExpiredTrue() public {
    require(
      block.timestamp > expirationTimestamp,
      "the expiration time hasn't come yet"
    );
    isExpired = true;
  }

  function calculatePremium() public pure returns (uint256) {
    return uint256(0);
  }

  function buyCoverage(uint256 premium) public {
  }

  function mintCoverageToken() public {
  }

  function claimCoverage() onlyWhenDefault public {}

  function getMaxLoss() public pure returns (uint256) {
    return uint256(0);
  }

  function sellCoverage(uint256 coverage) public {}

  function mintPremiumToken() public {
    // premToken._mint(msg.sender, 1);
  }

  function withdrawPremium() onlyWhenExpired public {
  }
}
