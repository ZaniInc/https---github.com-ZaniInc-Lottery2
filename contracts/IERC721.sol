// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

interface IERC721 {

    function balanceOf(address owner)external returns(uint256 balance);

    function ownerOf(uint256 tokenId)external returns(address owner);

    function safeTransferFrom(address from , address to , uint256 tokenId)external ;

    function transferFrom(address from , address to , uint256 tokenId)external ;

    function approve(address to , uint256 tokenId)external ;

    function getApproved(uint256 tokenId)external returns(address operator);

    function setApprovalForAll(address operator, bool _approved)external ;

    function isApprovedForAll(address owner , address opertor)external returns(bool operatorApprove);

    function safeTransferFromm(address from, address to, uint256 tokenId, bytes calldata data)external;

}