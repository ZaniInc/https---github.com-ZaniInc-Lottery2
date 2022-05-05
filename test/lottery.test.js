const {expect} = require("chai");
const {ethers} = require("hardhat");

describe("Lottery" , function () {

let owner;
let acc2 , acc3;
let lottery;

 before(async function () {
    
    [owner , acc2 , acc3] = await ethers.getSigners();
    const Lottery = await ethers.getContractFactory("Lottery" , owner);
    lottery = await Lottery.deploy();
    await lottery.deployed();
    
 });

 it("acc2 ether balance before pay" , async function () {

    let balanceOf = await lottery.connect(acc2).balanceOfETH() ;
    console.log("Acc2 balance ETH before pay :",balanceOf);
    
  
   })

 it("Buy ERC20 TOKENS by acc2" , async function () {

    let tokens = await lottery.connect(acc2).buyTokens(1 , {value : ethers.utils.parseEther("1.0")}) ;
    expect(tokens.value).to.eq(1000000000000000000n);
    await tokens.wait();
    
  
   })

 it("acc2 balance after pay" , async function () {

    let balanceOf = await lottery.connect(acc2).balanceOfETH() ;
    console.log("Acc2 balance ETH after pay :", balanceOf);
  
   })
  
  it("Buy ticket by ERC20 TOKENS for acc2" , async function () {

    
    let balanceOfTokkens = await lottery.connect(acc2).balanceOfTokens(acc2.address);
    expect(balanceOfTokkens).to.eq(1);
    console.log("Acc2 balance of ERC20 tokens :",balanceOfTokkens);
    let ticket = await lottery.connect(acc2).buyTicketByTokens(1);
    
  
  })

  it("Check NFT acc2" , async function () {

    let tokenIdNft = await lottery.connect(acc2).balanceOfNFT(acc2.address);
    expect(tokenIdNft).to.eq(1);
    console.log("tokenId of acc2 :",tokenIdNft);

    console.log("tokenURI of tokenId = 1", await lottery.tokenURI(1));

  })

  it("Should fail if acc try to buy ticket with out tokens" , async function () {

    let balanceOfTokkens = lottery.connect(acc3).balanceOfTokens(acc3.address);
    expect(balanceOfTokkens > 0 , "Not enough ERC20 tokens").to.be.true;
    await lottery.connect(acc3).buyTicketByTokens(1);
    

  })

 it("Buy ERC20 TOKENS for acc3" , async function () {

    let ticketForMember = await lottery.connect(acc3).buyTokens(1 , {value : ethers.utils.parseEther("1.0")}) ;
    expect(ticketForMember.value).to.eq(1000000000000000000n);
    await ticketForMember.wait();

    let balanceOf2 = await lottery.connect(acc3).balanceOfETH() ;
    console.log("Acc3 balance of ETH :",balanceOf2);
  
   })

  it("Buy ticket by ERC20 TOKENS by acc3" , async function () {

    let balanceOfTokkens = await lottery.connect(acc3).balanceOfTokens(acc3.address);
    expect(balanceOfTokkens).to.eq(1);
    console.log("Acc3 balance of ERC20 tokens :",balanceOfTokkens);
    let ticket = await lottery.connect(acc3).buyTicketByTokens(1);
    
  })

  it("Check NFT acc3" , async function () {

    let tokenIdNft = await lottery.connect(acc3).balanceOfNFT(acc3.address);
    expect(tokenIdNft).to.eq(2);
    console.log("tokenId of acc3 :",tokenIdNft);

    console.log("tokenURI of tokenId = 2", await lottery.tokenURI(2));

  })
  
 it("Check number of ticket by member1 + bank of lottery + members of lotter" , async function () {

    
    let ticketMy = await lottery.connect(acc2).myTicket() ;
    expect(ticketMy > 0 ).to.be.true;
    console.log("Number of ticket acc2 :",ticketMy);

    let bankOfLottery = await lottery.bankOfLottery();
    expect(bankOfLottery > 1000000000000000000n , "Bank below then 1 ether").to.be.true;
    console.log("Balance of contract :",bankOfLottery);

    let membersOfLottery = await lottery.membersOfLottery();
    console.log("Address of members :",membersOfLottery);
  
 })

 it("Pick Winner" , async function () {
  
    // find winner
  let winner = await lottery.pickWinner();
  let bankOfLottery = await lottery.bankOfLottery();

    // check change of bank
  console.log("Bank balance after lottery :",bankOfLottery);

    // check change of balance contract owner
  let balanceOf = await lottery.balanceOfETH() ;
  console.log("ETH balance of owner :",balanceOf);

    // check change of balance member2
  let balanceOf2 = await lottery.connect(acc2).balanceOfETH() ;
  console.log("ETH balance of member1 :",balanceOf2);
    // check change of balance member3
  let balanceOf3 = await lottery.connect(acc3).balanceOfETH() ;
  console.log("ETH balance of member2 :",balanceOf3);

 })

 it("Last winner" , async function() {
    // Address of winner
  let lastWinner = await lottery.lastWinner();
  console.log("Winner of lottery :",lastWinner);


 })



})