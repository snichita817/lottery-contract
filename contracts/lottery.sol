//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Tombola{
    address private admin;
    address[] public players;
    string public nume;
    uint data;
    uint randomCounter;
    function setNume(string memory _nume) public {
        nume = _nume;
    } 

    function getNume() public view returns(string memory) {
        return nume;
    }
    //admin only
    function startTombola() public {
        data = block.timestamp;
    }

    constructor() {
        admin = msg.sender;
    }

    function enter() public payable{
        require(msg.value ==  0.1 ether, "Incorrect value");
        players.push(msg.sender);
    }

    function random() private returns(uint){
        randomCounter = randomCounter + 1;
        return uint(keccak256(abi.encodePacked(randomCounter, block.timestamp, msg.sender, msg.data)));
    }

    function finalizareTombola() public adminOnly{
        uint locul1 = random() % players.length;
        payable (players[locul1]).transfer(address(this).balance*7/10);//70%

        uint locul2 = random() % players.length;

       //
        while(locul1 == locul2) {
            locul2 = random() % players.length;
        }
        payable (players[locul2]).transfer(address(this).balance * 5/20); // 25%

        players = new address[](0);
    }

    function withdrawFunds() external payable{
        payable (admin).transfer(address(this).balance); // restul de 5%
    }

    modifier adminOnly(){
        require(msg.sender == admin, "Acces interzis!");
        _;

    }

    modifier not_admin() {
        _;
    }

}