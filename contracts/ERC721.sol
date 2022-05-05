// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./IERC721.sol";
import "./Strings.sol";


contract ERC721 is IERC721 {

    using Strings for uint256;

    // Token name
    string private _nameNFT = "TicketNFT";

    // Token symbol
    string private _symbolNFT = "TTN";

    uint public nftTotalSupply;

    // Mapping from token ID to owner address
    mapping(uint256 => address) private _owners;

    // Mapping owner address to token count
    mapping(address => uint256) private _balances;

    // Mapping from token ID to approved address
    mapping(uint256 => address) private _tokenApprovals;

    // Mapping from owner to operator approvals
    mapping(address => mapping(address => bool)) private _operatorApprovals;

    // Check NFT balance
    function balanceOfNFT(address owner) public view virtual override returns (uint256) {
        require(owner != address(0), "balance query for the zero address");
        return _balances[owner];
    }

    // Check NFT owner
    function ownerOf(uint256 tokenId) public view virtual override returns (address) {
        require(_owners[tokenId] != address(0) , "This token dont have owner");
        return _owners[tokenId];
    }

    // Show name of NFTs
    function nameNFT() public view virtual returns (string memory) {
        return _nameNFT;
    }

    // Show NFTs symbol
    function symbolNFT() public view virtual returns (string memory) {
        return _symbolNFT;
    }

    // Show token URI
    function tokenURI(uint256 tokenId) public view virtual returns (string memory) {
        require(_owners[tokenId] != address(0), "URI query for nonexistent token");

        string memory baseURI = _baseURI();
        return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
    }

    // Set up base uri
    function _baseURI() internal view virtual returns (string memory) {
        return "https://gateway.pinata.cloud/ipfs/QmeBykqdA6f2SMyDt5nnkXhaYrQPvNU6ojM9zSr81veRFe/";
    }

    // function safeTransferFrom(address from , address to , uint256 tokenId)public override {


    // }

    // Transfers NFT function
    function transferFromNFT(address from , address to , uint256 tokenId)public override {

        require(from != address(0) && to != address(0) && tokenId != 0);
        require(_isApprovedOrOwner(msg.sender, tokenId), "transfer caller is not owner nor approved");
        require(_tokenApprovals[tokenId] == to);
        _tokenApprovals[tokenId] != to;
        _transferNFT(from , to ,tokenId);


    }

    // Set approve to made transactions
    function approveNFT(address to , uint256 tokenId) public override {

        address owner = ERC721.ownerOf(tokenId);
        require(to != owner, "approval to current owner");

        require(
            msg.sender == owner || isApprovedForAll(owner, msg.sender),
            "approve caller is not owner nor approved for all"
        );

        _tokenApprovals[tokenId] = to;

    }

    // Show available transactions
    function getApprovedNFT(uint256 tokenId)public view override returns(address operator) {

        return _tokenApprovals[tokenId];

    }

    // Set approve to manage all your NFTs by operator
    function setApprovalForAll( address _owner,address _operator, bool _approved)public override {
        require(_owner != address(0) && _operator != address(0));
        require(_owner != _operator);       
        _operatorApprovals[_owner][_operator] = _approved;

    }

    // Check operator permission to manage your NFTs
    function isApprovedForAll(address _owner , address _operator)public view override returns(bool operatorApprove){

        return _operatorApprovals[_owner][_operator];

    }

    function _isApprovedOrOwner (address spender , uint256 tokenId) private view returns (bool) {
        require(spender != address(0) && tokenId != 0);
        address owner = ERC721.ownerOf(tokenId);
        return(owner == spender || getApprovedNFT(tokenId) == spender || isApprovedForAll(owner , spender));
    }

    // function safeTransferFromm(address from, address to, uint256 tokenId, bytes calldata data)public override {

    // }

    // This function are minting NFTs
    function _mintNFT (address to) internal returns (uint256) {
        uint256 tokenId;
        ++tokenId;

        require(to != address(0) && tokenId != 0);
        require(_balances[to] <1);

        _balances[to] += tokenId;
        _owners[tokenId] = to;
        nftTotalSupply += 1;
        return tokenId;
        

    }

    function _transferNFT (address from ,address to , uint256 tokenId) private {

        _balances[from] -= tokenId;
        _balances[to] += tokenId;
        _owners[tokenId] = to;
        
    }

    function setToZero()internal{
        for(uint i=0;i<nftTotalSupply;i++){
            _owners[i] = address(0);
        }
    }

}