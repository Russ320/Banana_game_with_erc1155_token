// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;
// import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

interface Itoken {

    event transfer(address _from,address _to,uint256 _amount, uint _id);
    event exchange(address _account, uint256 _amount, uint _id);
    event approve(address _account, address _operator);

    /////////////
    //| function|
    //////////////

    function transferToMarket(address _user, uint256 _amount,uint _id) external;

    function validTransfer(address _user,uint256 _amount,uint _id) external returns(bool);
    // function upStage(address _account,uint256 _time) public ;
    // function getReward(address _account) external override returns(uint256[] memory,uint256[] memory);
    // function uint2str(uint256 _i) internal pure returns (string memory);
    // function reward(address _account,uint256 _num,uint256[] memory _amount,uint256[] memory _rates) public returns(string memory);
    // function addToken(address _account,uint256 _amount, uint _id,bytes memory data)external;
    // function getReward(address _account) external override returns(uint256[] memory,uint256[] memory);
    
}