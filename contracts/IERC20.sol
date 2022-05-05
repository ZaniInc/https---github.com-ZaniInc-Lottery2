// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

interface IERC20 {

    function balanceOfTokens (address account) external view returns (uint256);

    function approve (address owner , address _spender , uint256 amount) external ;

    function totalSupply () external view returns (uint256);

    function transfer (address to , uint256 amount) external ;

    function transferFrom (address from , address to , uint256 amount) external ;

    function allowance(address owner, address spender) external view returns (uint256);




}