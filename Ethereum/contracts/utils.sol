pragma solidity>0.6.0;


contract Utils{
    
    function getLargest(address[] memory keys,uint256[] memory values) public returns(address){

        uint256 storage_var=0;
        address key;

        for (uint i =1;i<keys.length;i++){
            if(storage_var < values[i]){
                storage_var =  values[i];
                key = keys[i];
            }
        }
        return key;
    }
    function getPathForETHToToken(address weth,address crypto) public view returns (address[] memory) {
        address[] memory path = new address[](2);
        path[0] = weth;
        path[1] = crypto;
    
    return path;
  }
}