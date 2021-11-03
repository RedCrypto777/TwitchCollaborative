pragma solidity > 0.6.0;

import '../interfaces/IERC20.sol';
import '../interfaces/IWETH.sol';
import '../interfaces/IUniswapV2Router01.sol';
import '../interfaces/IUniswapV2Router02.sol';
import './utils.sol';

contract twitch_fund{
    struct GAME{
        bool state;
        address win_address;
        uint256 total_value;
    }
    Utils utils;
    IUniswapV2Router02 immutable urouter;
    IWETH immutable weth;
    address immutable owner;
    GAME game;
    mapping (address => mapping(address => uint256)) depth_map;
    address[] tokens_voted;
    mapping(address => uint256) votes;
    uint256 end_date;
    constructor(address _urouter,address _weth){
        urouter = IUniswapV2Router02(_urouter);
        weth    = IWETH(_weth);
        owner = msg.sender;
    }
    

    modifier OnlyOwner{
        require(msg.sender==owner,"You are not the owner");
        _;
    }
    modifier Game{
        require(game.state ==true, "Game already initialized");
        _;
    }
    modifier timestamp(uint256 lower_bound,uint256 upper_bound) {
        require(lower_bound < block.timestamp && block.timestamp < upper_bound);
        _;
    }

    function init_game() public OnlyOwner Game returns(bool){
        game.state = true;
        end_date = block.timestamp + 1 days;
        for (uint i=0;i<tokens_voted.length;i++){
            votes[tokens_voted[i]] = 0;
        }
        delete tokens_voted;
        return true;
    }

    function end_game() public Game{
        require(block.timestamp > end_date);
        uint256[] memory values;
        address[] memory path = new address[](2);
        for(uint i=0;i<tokens_voted.length;i++){
            values[i] = votes[tokens_voted[i]];
        }
        game.win_address = utils.getLargest(tokens_voted,values);
        game.state = false;
        path[0] = address(weth);
        path[1] = game.win_address;

        urouter.swapExactETHForTokens{value:game.total_value}(0,path,address(this), 166666666);
    }

        
}

