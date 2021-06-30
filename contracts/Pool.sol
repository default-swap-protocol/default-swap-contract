// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "../interfaces/IERC20Extended.sol";
import "./SampleMapleLoanContract.sol";

contract Pool is SampleMapleLoanContract {
  uint256 private _expirationTimestamp;
  bool isExpired;
  uint256 private _coveragePool;
  uint256 private _premiumPool;
  // address of the acceptable token address both for premium and coverage payment
  IERC20 public paymentToken;
  IERC20Extended public coverToken;
  IERC20Extended public premToken;

  constructor(
    IERC20 _paymentToken,
    IERC20Extended _coverToken,
    IERC20Extended _premToken,
    uint256 _expiryTimestamp
  ) {
    paymentToken = _paymentToken;
    coverToken = _coverToken;
    premToken = _premToken;
    _expirationTimestamp = _expiryTimestamp;
  }

  function expirationTimestamp() public view returns (uint256) {
      return _expirationTimestamp;
  }

  function coveragePool() public view returns (uint256) {
      return _coveragePool;
  }

  function premiumPool() public view returns (uint256) {
      return _premiumPool;
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
      block.timestamp > _expirationTimestamp,
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
