// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
// import "./Itoken.sol";
// import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
contract BananaToken {

    event transfer(address _from,address _to,uint256 _amount, uint _id);
    event exchange(address _account, uint256 _amount, uint _id);
    event approve(address _account, address _operator);

    uint256 public constant IRON =0;
    uint256 public constant SILVER =1;
    uint256 public constant GOLD =2;
    uint256 public constant DIAMOND =3;

    mapping (address => uint) stage;
    mapping(address => mapping(uint => uint256)) balance;
    // constructor() ERC1155("https://placeholder.com/{id}.json"){
    //     _mint(address(0),IRON,100000,"");
    //     _mint(address(0),SILVER,50000,"");
    //     _mint(address(0),GOLD,10000,""); // cryptocurrency
    //     _mint(address(0),DIAMOND,5,""); // unique token
        
    // } 

    function addToken(address _account,uint256 _amount, uint _id)public  {
        _mint(_account,_id,_amount);
        emit transfer(address(0),_account,_amount,_id);
    }
    function awardStage(address _account,uint256[] calldata _ids, uint256[] calldata _amounts) external {
             for(uint256 i=0; i <_ids.length; i++){
            _mint(_account,_ids[i], _amounts[i]);
            emit transfer(address(0),_account,_amounts[i],_ids[i]);
        }
    }
    function burn (address _account,uint256 _amount, uint _id) external {
        require(_account !=address(0),"cannot be the zero address");
        _burn(_account,_id,_amount);
        emit transfer(_account,address(0),_amount,_id);
    }
    function burnBatch(address _account,uint256[] calldata _ids, uint256[] calldata _amounts) external {
        require(_account !=address(0),"cannot be the zero address");
        require(_ids.length == _amounts.length,"ids and amounts must have the same length");
        // _berforTokenTransfer(msg.sender,);
        for(uint256 i=0; i <_ids.length; i++){
            _burn(_account,_ids[i],_amounts[i]);
            emit transfer(_account,address(0),_amounts[i],_ids[i]);
        }
    }
    
    function reward(address _account,uint256 _num,uint256[] memory _amount,uint256[] memory _rates) public returns(string memory){
        string memory announce;
        // Diamond reward condition
        if (_num <= _rates[0]) {
            addToken(_account, _amount[0], DIAMOND);
            announce = "You got a diamond";
        } 
        // Gold reward condition
        else if (_num > _rates[0] && _num <= (_rates[1] + _rates[0])) {
            addToken(_account, _amount[1], GOLD);
            announce = string(abi.encodePacked("You got ", uint2str(_amount[1]), " gold"));
        } 
        // Silver reward condition
        else if (_num > (_rates[0] + _rates[1]) && _num <= (_rates[0] + _rates[1] + _rates[2])) {
            addToken(_account, _amount[2], SILVER);
            announce = string(abi.encodePacked("You got ", uint2str(_amount[2]), " silver"));
        } 
        // Iron reward condition
        else if (_num > (_rates[0] + _rates[1] + _rates[2]) && _num <= 1000) {
            addToken(_account, _amount[3], IRON);
            announce = string(abi.encodePacked("You got ", uint2str(_amount[3]), " iron"));
        } 
        // Fallback for invalid _num
        else {
            revert("Invalid number");
        }
        return announce;
    }

    function upStage(address _account,uint256 _time) public returns(uint256) {
        if(_time % 1000==1 && _time>0){
            stage[_account] +=1;
        }
        return stage[_account];
    }
    // function checkUpStage(address _account) external view returns(bool){
    //     return stage[_account];
    // }
    function getReward(uint256 _stage) public view returns(uint256[] memory,uint256[] memory)  {
        uint256[] memory amounts;
        uint256[] memory rates;
        // reward for stage 0
        if(_stage == 0){ 
            // amount of reward for Diamond,gold,silver,iron  token
            // store as % *10 drop rates of Diamond,gold,silver,iron
            amounts[0] = 0; // amount of reward for Diamond
            amounts[1] = 1; // amount of reward for gold
            amounts[2] = 2; // amount of reward for silver
            amounts[3] = 5; // amount of reward for iron
            rates[0] = 0;   // store as % *10 drop rates of Diamond
            rates[1] = 10;  // store as % *10 drop rates of gold
            rates[2] = 490; // store as % *10 drop rates of silver
            rates[3] = 500; // store as % *10 drop rates of iron
        }
        // reward for stage 1
        if(_stage == 1){
            amounts[0] = 1;
            amounts[1] = 10;
            amounts[2] = 20;
            amounts[3] = 50;
            rates[0] = 5;
            rates[1] = 145;
            rates[2] = 450;
            rates[3] = 400; 
        }
        //reward for stage 2
        if(_stage ==2){
            amounts[0] = 1;
            amounts[1] = 20;
            amounts[2] = 100;
            amounts[3] = 200;
            rates[0] = 10;
            rates[1] = 190;
            rates[2] = 400;
            rates[3] = 400;
        }
        // reward for stage 3 and beyond
        if(_stage >2){
            amounts[0] = 1;
            amounts[1] = 50;
            amounts[2] = 200;
            amounts[3] = 100;
            rates[0] = 50;
            rates[1] = 250;
            rates[2] = 350;
            rates[3] = 350;
        }
        return(amounts,rates);
    }
    /**
     * @param '_num' number that random generate to get reward
     * @param '_time' number of time click to get stage
     */
    function rewardBasedOnStage(uint256 _num,uint _time) external returns(string memory){
        uint256[] memory amount;
        uint256[] memory rate;
        // up stage first if meat condition
        uint256 _stage = upStage(msg.sender,_time);
        // get amount and rates of reward 
        // check getReward for futher infor
        (amount,rate) = getReward(_stage);

        string memory announce = reward(msg.sender,_num,amount,rate);
        return announce;
    }
    function uint2str(uint256 _i) internal pure returns (string memory) {
        if (_i == 0) {
            return "0";
        }
        uint256 j = _i;
        uint256 len;
        while (j != 0) {
            len++;
            j /= 10;
        }
        bytes memory bstr = new bytes(len);
        while (_i != 0) {
            bstr[--len] = bytes1(uint8(48 + _i % 10));
            _i /= 10;
        }
        return string(bstr);
    }
    function _mint(address _to, uint256 _id, uint256 _amount)
    internal virtual{
        // Add _amount
        balance[_to][_id] += _amount;
    }

    function _burn(address _to, uint256 _id, uint256 _amount)
    internal virtual{
        // Add _amount
        balance[_to][_id] -= _amount;
    }

    function balanceOf(address _user,uint256 _id)public view returns(uint256){
        return balance[_user][_id];
    }
}