const {expect} = require("chai");
const {ethers} = require("hardhat");

describe("Lottery" , function () {

let owner;
let acc2 , acc3;
let lottery;

 before(async function () {

    [owner , acc2 , acc3] = await ethers.getSigners();
    const ERC20 = await ethers.getContractFactory("ERC20" , owner);
    erc20 = await ERC20.deploy();
    await erc20.deployed();
    
    [owner , acc2 , acc3] = await ethers.getSigners();
    const Lottery = await ethers.getContractFactory("Lottery" , owner);
    lottery = await Lottery.deploy(erc20.address);
    await lottery.deployed();
    
 });

 
 it("MINT ERC20 TOKENS by acc2" , async function () {

    let tokensMint = await erc20.connect(acc2).mintToken(acc2.address , 1 ) ;
    expect(await erc20.connect(acc2).balanceOfTokens(acc2.address)).to.eq(1);
    await tokensMint.wait();
    
  
   })

  it("acc2 balance after MINT" , async function () {

    let balanceOf = await lottery.connect(acc2).callBalanceOfERC20(acc2.address) ;
    console.log("Acc2 balance after mint :", balanceOf);
  
   })
  
  it("acc2 approve transfer for lottery" , async function () {

    let approve = await erc20.connect(acc2).approve(acc2.address , lottery.address , 1) ;
    expect(await erc20.connect(acc2).allowance(acc2.address , lottery.address) , "Check allowances").to.eq(1);
  
  })

  it("Buy ticket by ERC20 TOKENS for acc2" , async function () {

    
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

  it("MINT ERC20 TOKENS by acc3" , async function () {

    let tokensMint = await erc20.connect(acc3).mintToken(acc3.address , 1 ) ;
    expect(await erc20.connect(acc3).balanceOfTokens(acc3.address)).to.eq(1);
    await tokensMint.wait();
    
  
   })

  it("acc3 balance after MINT" , async function () {

    let balanceOf = await lottery.connect(acc3).callBalanceOfERC20(acc3.address) ;
    console.log("Acc2 balance after mint :", balanceOf);
  
   })
  
  it("acc3 approve transfer for lottery" , async function () {

    let approve = await erc20.connect(acc3).approve(acc3.address , lottery.address , 1) ;
    expect(await erc20.connect(acc3).allowance(acc3.address , lottery.address) , "Check allowances").to.eq(1);
  
  })

  it("Buy ticket by ERC20 TOKENS for acc3" , async function () {

    
    let ticket = await lottery.connect(acc3).buyTicketByTokens(1);
    
  
  })

  it("Check NFT acc3" , async function () {

    let tokenIdNft = await lottery.connect(acc3).balanceOfNFT(acc3.address);
    expect(tokenIdNft).to.eq(2);
    console.log("tokenId of acc3 :",tokenIdNft);

    console.log("tokenURI of tokenId = 2", await lottery.tokenURI(2));

  })
  
 it("Check number of ticket by acc2 + bank of lottery + members of lotter" , async function () {

    
    let ticketMy = await lottery.connect(acc2).myTicket() ;
    expect(ticketMy > 0 ).to.be.true;
    console.log("Number of ticket acc2 :",ticketMy);

    let bankOfLottery = await lottery.bankOfLottery();
    expect(bankOfLottery == 2 , "Bank below then 2 tokens").to.be.true;
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

    // check change of balance member2
  let balanceOf2 = await erc20.connect(acc2).balanceOfTokens(acc2.address) ;
  console.log("ERC20 balance of member1 :",balanceOf2);
    // check change of balance member3
  let balanceOf3 = await erc20.connect(acc3).balanceOfTokens(acc3.address) ;
  console.log("ERC20 balance of member2 :",balanceOf3);

 })

 it("Last winner" , async function() {
    // Address of winner
  let lastWinner = await lottery.lastWinner();
  console.log("Winner of lottery :",lastWinner);


 })



})