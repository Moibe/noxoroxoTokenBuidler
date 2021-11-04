// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.4.22 <0.9.0;

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/Ownable.sol";

contract BrandNewToken is ERC20 {
    
    // This creates the new Token with all its features.
     constructor(uint256 initialSupply, string memory name, string memory symbol, address creator) ERC20(name, symbol) {
        _mint(creator, initialSupply);
        }

}


contract TokenFactoryMoibe is Ownable {
    
    // The acc that receives the funds.
    address payable public monedero;
    // The fee is dynamic. By default starts @ 0.001 ETH
    uint256 public serviceFee = 1000000000000000; 
  
    constructor(address payable _monedero) {
    monedero = _monedero;
    }
    
    //With this function you can set a new fee value.
    function setFee(uint256 _serviceFee) onlyOwner external {
    serviceFee = _serviceFee;
    }
    
    //With this function you can set a new monedero.
    function setMonedero(address payable _monedero) onlyOwner external {
    monedero = _monedero;
    }
    
    function createToken(uint256 initialSupply, string memory name, string memory symbol)
        external payable
        returns (BrandNewToken tokenAddress)
    {
         //uint256 serviceFee is required to complete tre transaction.
         require(msg.value >= serviceFee, "Service fee wasn't paid.");
        // Create a brand new token contract and return its address.
        // From the JavaScript side, the return type
        // of this function is `address`, as this is
        // the closest type available in the ABI.
        return new BrandNewToken(initialSupply, name, symbol, msg.sender);
    }
    
    //Pays out manually all factory eth balance to monedero address.
    //Because in the meanwhile eth received remains at the factory contract.
    function payout() onlyOwner external {
    require(monedero.send(address(this).balance));
    }

    
}