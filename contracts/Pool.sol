// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/utils/math/SafeMath.sol";
import "../interfaces/IERC20Extended.sol";
import "../interfaces/ISampleMapleLoanContract.sol";

contract Pool {
  using SafeMath for uint256;

  uint256 private _expirationTimestamp;
  bool isExpired;
  uint256 private _coveragePool;
  uint256 private _premiumPool;
  // address of the acceptable token address both for premium and coverage payment
  IERC20 public paymentToken;
  IERC20Extended public coverToken;
  IERC20Extended public premToken;
  ISampleMapleLoanContract public sampleMapleLoanContract;

  modifier onlyWhenExpired() {
    require(isExpired == true, "a loan hasn't expired yet");
    _;
  }

  modifier onlyWhenDefault() {
    require(
      sampleMapleLoanContract.loanDefaulted() == true,
      "a loan didn't default"
    );
    _;
  }

  event CoverageClaimed(address claimer);
  event PremiumWithdrawn(address withdrawer);

  constructor(
    IERC20 _paymentToken,
    IERC20Extended _coverToken,
    IERC20Extended _premToken,
    ISampleMapleLoanContract _sampleMapleLoanContract,
    uint256 _expiryTimestamp
  ) {
    paymentToken = _paymentToken;
    coverToken = _coverToken;
    premToken = _premToken;
    sampleMapleLoanContract = _sampleMapleLoanContract;
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

  function buyCoverage(uint256 _premiumAmount) external {
    _buyCoverage(msg.sender, _premiumAmount);
  }

  function _buyCoverage(address _buyer, uint256 _premiumAmount) private {
    paymentToken.transferFrom(_buyer, address(this), _premiumAmount);
    _premiumPool += _premiumAmount;
    uint256 _coverTokenAmount = _calculateCoverTokenAmount(_premiumAmount);
    coverToken.mint(_buyer, _coverTokenAmount);
  }

  function _calculateCoverTokenAmount(uint256 _premiumAmount)
    private
    pure
    returns (uint256)
  {
    return _premiumAmount.mul(2);
  }

  function claimCoverage() public onlyWhenDefault {
    emit CoverageClaimed(msg.sender);
  }

  function getMaxLoss() public pure returns (uint256) {
    return uint256(0);
  }

  function sellCoverage(uint256 _coverageAmount) external {
    _sellCoverage(msg.sender, _coverageAmount);
  }

  function _sellCoverage(address _seller, uint256 _coverageAmount) private {
    paymentToken.transferFrom(_seller, address(this), _coverageAmount);
    _coveragePool += _coverageAmount;
    uint256 _premTokenAmount = _calculatePremTokenAmount(_coverageAmount);
    premToken.mint(_seller, _premTokenAmount);
  }

  function _calculatePremTokenAmount(uint256 _coverageAmount)
    private
    pure
    returns (uint256)
  {
    return _coverageAmount.div(2);
  }

  function withdrawPremium() public onlyWhenExpired {
    emit PremiumWithdrawn(msg.sender);
  }
}
