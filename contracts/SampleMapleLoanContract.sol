// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract SampleMapleLoanContract {
  bool loanDefaulted;

  // set whether the loan has defaulted or not
  function setLoanState(bool _hasDefaulted) public {
    loanDefaulted = _hasDefaulted;
  }

  function hasDefaulted() public view returns (bool) {
    return loanDefaulted;
  }
}
