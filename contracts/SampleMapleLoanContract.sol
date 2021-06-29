// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

contract SampleMapleLoanContract {
  bool isDefault;

  constructor(bool _isDefault) {
    isDefault = _isDefault;
  }

  function setIsDefault(bool _isDefault) public {
    isDefault = _isDefault;
  }
}
