// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

import  "@OpenZeppelin/interfaces/IERC4626.sol";
import  "@OpenZeppelin/token/ERC20/ERC20.sol";

contract Vault is IERC4626,ERC20{
    address public asset;

    constructor(address _asset)ERC20("Banana Vault","BV"){
        asset = _asset;
    }
    function totalAssets()public view returns(uint256){
        return ERC(asset).balanceOf(address(this));
    }

    // function convertToAssets(uint256 shares) public view return(uint256){

    // }

}