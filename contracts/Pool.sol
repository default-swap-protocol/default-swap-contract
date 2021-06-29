// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract Pool {
  uint256 expirationTimestamp;
  bool isExpired;
  bool isDefault;
  uint256 premiumPool;
  uint256 coveragePool;

  modifier onlyWhenExpired() {
    _;
  }
  modifier onlyWhenDefault() {
    _;
  }

  constructor() {}

  function expire() {}

  function calculatePremium() public view returns () {}

  function buyCoverage(uint256 premium) {}

  function mintCoverageToken() {}

  function claimCoverage() onlyWhenDefault {}

  function getMaxLoss() {}

  function sellCoverage(uint256 coverage) {}

  function mintPremiumToken() {}

  function withdrawPremium() onlyWhenExpired {}
}
