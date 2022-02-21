//SPDX-License-Identifier: GPL - 3.0

pragma solidity ^0.8.0;

contract lottery{

    address public manager;
    address payable[] public players;

    constructor(){
        manager = msg.sender;
    }

    function alreadyEntered() private view returns(bool){
        
        for(uint i=0;i<players.length;i++)
        {
            if(players[i] == msg.sender)
            {
                return true;
            }
        }
        return false;

    }

    function EnterLottery() payable public {

        require(msg.sender != manager, " Manager cannot enter the Lottery");
        require(msg.value >= 1 ether, "Minimum deposit must be made");
        require(alreadyEntered() == false, "Player has already entered the Lottery");

        players.push(payable(msg.sender));
    } 

    function randomGenerator() view private returns(uint)
    {
        return uint(sha256(abi.encodePacked(block.difficulty, block.number, players)));

    }

    function PickWinner() public
    {
        require(msg.sender == manager,"Only manager can pick winner");
        uint random = randomGenerator()%players.length;
        address contractAddress = address(this);
        players[random].transfer(contractAddress.balance);
        players = new address payable[](0);

    }

    function AllPlayers() public view returns(address payable[] memory)
    {
        return players;
    }
}
