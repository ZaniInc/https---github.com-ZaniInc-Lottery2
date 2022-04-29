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

 it("Buy Ticket" , async function () {

    let ticket = await lottery.buyTicket({value : 1000000000000000000n}) ;
    await ticket.wait();
  
   })

 it("Buy Ticket 2" , async function () {

    let ticketForMember = await lottery.connect(acc2).buyTicket({value : 1000000000000000000n}) ;
    await ticketForMember.wait();
  
   })

 it("Check number of ticket + bank of lottery + members of lotter" , async function () {

    
    let ticketMy = await lottery.myTicket() ;
    expect(ticketMy).to.eq(1);
    console.log(ticketMy);

    let bankOfLottery = await lottery.bankOfLottery();
    // expect(bankOfLottery).to.equal(1000000000000000000n);
    console.log(bankOfLottery);

    let membersOfLottery = await lottery.membersOfLottery();
    console.log(membersOfLottery);
  
 })

 it("Pick Winner" , async function () {

  let winner = await lottery.pickWinner() ;
  console.log(acc1.address);
  console.log(acc2.address);
  console.log(winner.value);
  

 })



})