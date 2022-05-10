// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./ERC721.sol";
import "./IERC20.sol";

contract Lottery is ERC721 {

    mapping(address => uint) private _ticketNumber;
    mapping(address => uint) private _balances;
    address [] private _winners;

    address  payable [] private members;
    address public owner = msg.sender;
    uint public numberOfMembers ;

    address public erc20Connect;
    
    modifier onlyOwner () {
        require (msg.sender == owner);
        _;
    }

    // Set connect with ERC20
    constructor(address ERC20) {
         erc20Connect = ERC20;
    }

    // Check balance of ERC20
    function callBalanceOfERC20(address _owner)public view returns (uint) {
        return IERC20(erc20Connect).balanceOfTokens(_owner);
    }

    // CHECK BANK OF LOTTERY IN ERC20
    function bankOfLottery() public view returns(uint) {
        return IERC20(erc20Connect).balanceOfTokens(address(this));
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
        require(numberOfMembers < 10 && amount == 1 && IERC20(erc20Connect).balanceOfTokens(msg.sender) == 1);
        IERC20(erc20Connect).approve(msg.sender , address(this) , amount);
        numberOfMembers += amount;
        _ticketNumber[msg.sender] += members.length + 1;
        _balances[msg.sender] += 1;
        IERC20(erc20Connect).transferFrom(msg.sender , address(this) , amount);
        _mintNFT(msg.sender);

        // address add to list with members
        members.push(payable(msg.sender));
    }

    // This function for buy new tokens by ethers
    function buyTokens (address to , uint256 amountTokens) public payable {
        require((msg.value / 10**18) == 1);
        IERC20(erc20Connect).mintToken(to , amountTokens);
        // mintToken(msg.sender , amountTokens);
    }

   /**
    WE USE RESULT OF FUNCTION randomNumber like random number and after % on length of array.
    After this 90% of balance ERC20 we transfer to random winner and 10% to owner of contract.
    And last we reset members of Lottery.
    Function will start when bank >= 2 tokens.
    */

    function pickWinner () public onlyOwner  {
        require(bankOfLottery() >= 2);
        setToZero();
        setToZeroLottery();
        sendToOwner();
        uint winner = randomNumber() % members.length;
        IERC20(erc20Connect).approve(address(this) , members[winner] , bankOfLottery());
        IERC20(erc20Connect).transfer(members[winner] , bankOfLottery());
        // members[winner].transfer(address(this).balance);
        _winners.push(members[winner]);
        members = new address payable[](0);
        numberOfMembers = 0;
        

    }

    // Check address of lastWinner
    function lastWinner () public view returns(address [] memory){
        return _winners;
    }

    // Send 10% to contract owner IN ERC20
    function sendToOwner () private {

        uint a = 10 * bankOfLottery() / 100;
        IERC20(erc20Connect).approve(address(this) , owner , a);
        IERC20(erc20Connect).transfer(owner , a);

        // owner.transfer(a);
    }

     // This function we use to create random number by creating random hash.
    function randomNumber () private view returns(uint){
        address owner_ = msg.sender;
        return uint (keccak256(abi.encodePacked(owner_ , block.timestamp)));
    }

    // Decrease ticket and balance after pickWinner
    function setToZeroLottery()private{

        for(uint i = 0;i<members.length;i++){
        _ticketNumber[members[i]] = 0;
        _balances[members[i]] = 0;

        }

    }
}