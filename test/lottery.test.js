const {expect} = require("chai");
const {ethers} = require("hardhat");

describe("Lottery" , function () {

let acc1;
let acc2;
let lottery;

 before(async function () {
    
    [acc1, acc2] = await ethers.getSigners();
    const Lottery = await ethers.getContractFactory("Lottery" , acc1);
    lottery = await Lottery.deploy();
    await lottery.deployed();
    
 });

 it("My ether balance before pay" , async function () {

    let balanceOf = await lottery.balanceOf() ;
    console.log(balanceOf);
    
  
   })

 it("Buy Ticket by contract owner" , async function () {

    let ticket = await lottery.buyTicket({value : 1000000000000000000n}) ;
    expect(ticket.value).to.eq(1000000000000000000n);
    await ticket.wait();
    
  
   })

 it("My ether balance after pay" , async function () {

    let balanceOf = await lottery.balanceOf() ;
    console.log(balanceOf);
    
  
   })

 it("Buy Ticket for member2" , async function () {

    let ticketForMember = await lottery.connect(acc2).buyTicket({value : 1000000000000000000n}) ;
    expect(ticketForMember.value).to.eq(1000000000000000000n);
    await ticketForMember.wait();

    let balanceOf2 = await lottery.connect(acc2).balanceOf() ;
    console.log(balanceOf2);
  
   })

 it("Check number of ticket + bank of lottery + members of lotter" , async function () {

    
    let ticketMy = await lottery.myTicket() ;
    expect(ticketMy > 0 ).to.be.true;
    console.log(ticketMy);

    let bankOfLottery = await lottery.bankOfLottery();
    expect(bankOfLottery > 1000000000000000000n , "Bank below then 1 ether").to.be.true;
    console.log(bankOfLottery);

    let membersOfLottery = await lottery.membersOfLottery();
    console.log(membersOfLottery);
  
 })

 it("Pick Winner" , async function () {
  
    // find winner
  let winner = await lottery.pickWinner();
  let bankOfLottery = await lottery.bankOfLottery();

    // check change of bank
  console.log(bankOfLottery);

    // check change of balance contract owner
  let balanceOf = await lottery.balanceOf() ;
  console.log(balanceOf);

    // check change of balance member2
  let balanceOf2 = await lottery.connect(acc2).balanceOf() ;
  console.log(balanceOf2);

 })

 it("last winner" , async function() {

  let lastWinner = await lottery.lastWinner();
  console.log(lastWinner);


 })



})