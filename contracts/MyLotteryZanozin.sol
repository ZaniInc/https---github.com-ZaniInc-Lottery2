// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./ERC20.sol";

contract Lottery is ERC20 {

    mapping(address => uint) private _ticketNumber;
    mapping(address => uint) private _balances;
    address [] private _winners;

    address  payable [] private members;
    address payable private owner = payable(msg.sender) ;
    uint public numberOfMembers ;
    
    modifier onlyOwner () {
        require (msg.sender == owner);
        _;
    }

    // CHECK BANK OF LOTTERY
    function bankOfLottery () public view returns(uint) {
        return address(this).balance;
    }

    // CHECK ETHER BALANCE FOR TEST
    function balanceOfETH () public view returns(uint) {
        return msg.sender.balance;
    }

    // CHECK MEMBERS OF LOTTERY

    function membersOfLottery () public view returns (address payable [] memory) {
        return members;
    }

    // This function we use to check number of lottery ticket
    function myTicket () public view returns (uint) {
        return _ticketNumber[msg.sender];
    }

   /**
    IMPORTANTS THINKS OF THIS FUNCTION IS ADD NEW MEMBER TO ARRAY
    AND BUY 1 TICKET FOR 1 ETHER
    */
    // function buyTicket () public payable {
    //     require(numberOfMembers < 10 && msg.value == 1 ether && _balances[msg.sender] < 1);
    //     numberOfMembers += msg.value / 1000000000000000000;
    //     payable(msg.sender).transfer(1);
    //     _ticketNumber[msg.sender] += members.length + 1;
    //     _balances[msg.sender] += 1;

    //     // address add to list with members
    //     members.push(payable(msg.sender));
    // }

    // This function for buy tickets by tokens
    function buyTicketByTokens (uint amount) public {
        require(numberOfMembers < 10 && amount == 1 && balanceOfTokens(msg.sender) == 1);
        numberOfMembers += amount;
        _ticketNumber[msg.sender] += members.length + 1;
        _balances[msg.sender] += 1;
        _balancesOfToken[msg.sender] -= amount;

        // address add to list with members
        members.push(payable(msg.sender));
    }

    // This function for buy new tokens by ethers
    function buyTokens (uint256 amountTokens) public payable {
        require((msg.value / 10**18) == 1);
        mintToken(msg.sender , amountTokens);
    }

   /**
    WE USE RESULT OF FUNCTION randomNumber like random number and after % on length of array.
    After this 90% of balance we transfer to random winner and 10 to owner of contract.
    And last we reset members of Lottery.
    Function will start when bank = 10 ether.
    */
    function pickWinner () public onlyOwner  {
        require(bankOfLottery() > 1 ether);
        sendToOwner();
        uint winner = randomNumber() % members.length;
        members[winner].transfer(address(this).balance);
        _winners.push(members[winner]);
        members = new address payable[](0);
        numberOfMembers = 0;

    }


    function lastWinner () public view returns(address [] memory){
        return _winners;
    }
    // Send 10% to contract owner
    function sendToOwner () private {
       
        uint a = 10 * bankOfLottery() / 100;
        owner.transfer(a);
    }

     // This function we use to create random number by creating random hash.
    function randomNumber () private view returns(uint){
        address owner_ = msg.sender;
        return uint (keccak256(abi.encodePacked(owner_ , block.timestamp)));
    }
}