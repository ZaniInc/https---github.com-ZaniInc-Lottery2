// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

interface IERC721 {

    function balanceOfNFT(address owner)external returns(uint256 balance);

    function ownerOf(uint256 tokenId)external returns(address owner);

    // function safeTransferFrom(address from , address to , uint256 tokenId)external ;

    function transferFromNFT(address from , address to , uint256 tokenId)external ;

    function approveNFT(address to , uint256 tokenId)external ;

    function getApprovedNFT(uint256 tokenId)external returns(address operator);

    function setApprovalForAll(address owner, address operator, bool _approved)external ;

    function isApprovedForAll(address owner , address opertor)external returns(bool operatorApprove);

    // function safeTransferFromm(address from, address to, uint256 tokenId, bytes calldata data)external;

}