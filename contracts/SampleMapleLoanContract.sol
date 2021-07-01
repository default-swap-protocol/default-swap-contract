// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract SampleMapleLoanContract {
  bool private _loanDefaulted;

  // set whether the loan has defaulted or not
  function setLoanState(bool _hasDefaulted) external {
    _loanDefaulted = _hasDefaulted;
  }

  function loanDefaulted() external view returns (bool) {
    return _loanDefaulted;
  }
}
