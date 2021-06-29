// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "./SampleMapleLoanContract";

contract Pool is SampleMapleLoanContract {
  uint256 expirationTimestamp;
  bool isExpired;
  bool isDefault;
  uint256 premiumPool;
  uint256 coveragePool;

  modifier onlyWhenExpired() {
    require(isExpired == true, "a loan hasn't expired yet");
    _;
  }

  modifier onlyWhenDefault() {
    require(isDefault == true, "a loan didn't default");
    _;
  }

  constructor(uint256 _expirationTimestamp) {
    expirationTimestamp = _expirationTimestamp;
  }

  function setIsExpiredTrue() public {
    require(
      block.timestamp > expirationTimestamp,
      "the expiration time hasn't come yet"
    );
    isExpired = true;
  }

  function setIsDefaultTrue() public {
    require(
      SampleMapleLoanContract.isDefault() == true,
      "the loan did not default"
    );
    isDefault = true;
  }

  function calculatePremium() public view returns () {}

  function buyCoverage(uint256 premium) {}

  function mintCoverageToken() {}

  function claimCoverage() onlyWhenDefault {}

  function getMaxLoss() {}

  function sellCoverage(uint256 coverage) {}

  function mintPremiumToken() {}

  function withdrawPremium() onlyWhenExpired {}
}
