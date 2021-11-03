// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";

contract OwnedToken is ERC20{
   
     constructor(uint256 initialSupply, string memory name, string memory symbol, address creator) ERC20(name, symbol) {
        _mint(creator, initialSupply);
        }

    
}


contract TokenCreator {
    
    // The owner of the contract, who receives the funds
  address payable immutable public owner;
    
    constructor(address payable _owner) {
    owner = _owner;
    }
    
    function createToken(uint256 initialSupply, string memory name, string memory symbol)
        public payable
        returns (OwnedToken tokenAddress)
    {
         uint256 serviceFee = 1000000000000000; // 0.001 ETH
         require(msg.value >= serviceFee, "Service Fee of 0.05ETH wasn't paid");
        // Create a new `Token` contract and return its address.
        // From the JavaScript side, the return type
        // of this function is `address`, as this is
        // the closest type available in the ABI.
        return new OwnedToken(initialSupply, name, symbol, msg.sender);
    }
    
    /// @notice Pays out all Factory ETH balance to owners address
  function payout() external {
    require(owner.send(address(this).balance));
  }

    
}