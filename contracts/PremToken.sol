// SPDX-License-Identifier: MIT
pragma solidity 0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract PremToken is ERC20 {
  constructor(string memory name, string memory symbol, uint256 initialSupply) ERC20(name, symbol) {
      _mint(msg.sender, initialSupply);
  }

  function mint(address _to, uint256 _amount) external {
    _mint(_to, _amount);
  }

  function burn(address _from, uint256 _amount) external {
    _burn(_from, _amount);
  }
}
