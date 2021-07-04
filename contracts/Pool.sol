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

  event CoverageClaimed(address claimer, uint256 _coverageAmount);
  event PremiumWithdrawn(address withdrawer, uint256 _premiumAmount);

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

  function setIsExpiredTrueForTesting() public {
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
    return _premiumAmount.mul(1);
  }

  function claimCoverage(uint256 _coverTokenAmount) public onlyWhenDefault {
    uint256 _coverageAmount = _calculateCoverTokenValue(_coverTokenAmount);
    paymentToken.transferFrom(address(this), msg.sender, _coverageAmount);
    coverToken.burn(msg.sender, _coverTokenAmount);
    emit CoverageClaimed(msg.sender, _coverageAmount);
  }

  function _calculateCoverTokenValue(uint256 _coverTokenAmount)
    private
    view
    returns (uint256)
  {
    uint256 _coveragePoolSize = coveragePool();
    uint256 _totalCoverTokenSupply = coverToken.totalSupply();
    uint256 _coverTokenValue = _coveragePoolSize.mul(100).div(
      _totalCoverTokenSupply
    );
    return _coverTokenAmount.mul(_coverTokenValue).div(100);
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
    return _coverageAmount.mul(1);
  }

  function withdrawPremium(uint256 _premTokenAmount) public onlyWhenExpired {
    uint256 _premiumAmount = _calculatePremTokenValue(_premTokenAmount);
    paymentToken.transferFrom(address(this), msg.sender, _premiumAmount);
    _premiumPool -= _premiumAmount;
    premToken.burn(msg.sender, _premTokenAmount);
    emit PremiumWithdrawn(msg.sender, _premiumAmount);
  }

  function _calculatePremTokenValue(uint256 _premTokenAmount)
    private
    view
    returns (uint256)
  {
    uint256 _premiumPoolSize = premiumPool();
    uint256 _totalPremTokenSupply = premToken.totalSupply();
    uint256 _premTokenValue = _premiumPoolSize.mul(100).div(
      _totalPremTokenSupply
    );
    return _premTokenAmount.mul(_premTokenValue).div(100);
  }
}
