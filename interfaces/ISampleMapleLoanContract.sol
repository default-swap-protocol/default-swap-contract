// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

interface ISampleMapleLoanContract {
  function setLoanState(bool _hasDefaulted) external;

  function loanDefaulted() external view returns (bool);
}
