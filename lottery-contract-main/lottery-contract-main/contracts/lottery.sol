//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Tombola{
    bool started = false;
    address private admin;
    address[] public players;
    string public nume;
    uint data;
    uint randomCounter;
    uint numberOfPlayers;
    
    function setNume(string memory _nume) public {
        nume = _nume;
    } 

    function getNume() public view returns(string memory) {
        return nume;
    }
    
    function getStarted() public view returns(bool) {
        return started;
    }

    function getNumber() public view returns(uint) {
        return numberOfPlayers;
    }
    
    function startTombola() public {
        require(started == false, "The lottery is already started.");
        data = block.timestamp;
        started = true;
        numberOfPlayers = 0;
    }

    constructor() {
        admin = msg.sender;
    }

    function enter() public payable{
        require(started == true, "The lottery is not opened.");
        require(msg.value ==  0.1 ether, "Incorrect value !");
        players.push(msg.sender);
        numberOfPlayers +=1;
    }

    function random() private returns(uint){
        randomCounter = randomCounter + 1;
        return uint(keccak256(abi.encodePacked(randomCounter, block.timestamp, msg.sender, msg.data)));
    }

    function finalizareTombola() public adminOnly{
        require(started == true, "No lottery is currently ongoing.");
        uint locul1 = random() % players.length;
        payable (players[locul1]).transfer(address(this).balance*70/100);

        uint locul2 = random() % players.length;

        while(locul1 == locul2) {
            locul2 = random() % players.length;
        }
        payable (players[locul2]).transfer(address(this).balance * 83333/100000); 

        players = new address[](0);
        started = false;
        
    }

    function withdrawFunds() external payable{
        require(started == false, "Cannot withdraw, the lottery is curently ongoing.");
        payable (admin).transfer(address(this).balance);
         // restul de 5%
    }

    modifier adminOnly(){
        require(msg.sender == admin, "Acces interzis!");
        _;

    }

    modifier not_admin() {
        _;
    }

}