// SPDX-License-Identifier: MIT

pragma solidity ^0.8.7;

import "./IERC20.sol";

contract ERC20 is IERC20 {

    mapping(address => uint256) internal _balancesOfToken;

    mapping(address => mapping(address => uint256)) private _allowances;

    uint256 private _totalSupply;

    string private constant _name = "LotteryCoin";
    string private constant _symbol = "LTC";

    function name () public pure returns (string memory) {
        return _name;
    }

     function symbol () public pure returns (string memory) {
        return _symbol;
    }

    function decimals() public pure returns (uint8) {
        return 8;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    /**
    SHOW TOKEN BALANCE
    */

     function balanceOfTokens(address _account) public view override returns (uint256) {
        return _balancesOfToken[_account];
    }
    /**
    WRAP OF _transfer , always transfer tokens from msg.sender
    */
    function transfer(address _to, uint256 _amount) public override {

        address owner = msg.sender;
        _transfer(owner, _to, _amount);
       
    }

    /**
    WRAP OF _transfer , transferFrom you to send token with 3 arguments :
    address of sender , address of receiver , amount of tokens
    */
    function transferFrom(address _from,address _to,uint256 _amount) public virtual override {

      _transfer(_from, _to, _amount);
       
    }

    /**
    This show you available transfers from owner to spender
    */
    function allowance(address _owner, address _spender) public view override returns (uint256) {

        require(_owner != address(0), "transfer from the zero address");
        require(_spender != address(0), "transfer to the zero address");
        return _allowances[_owner][_spender];

    }

    /**
    Use for verify your transaction , if transaction not approve transaction will revert
    */
    function approve (address _owner , address _spender , uint256 _amount) public override {

        require(_owner != address(0), "transfer from the zero address");
        require(_spender != address(0), "transfer to the zero address");
        require(_balancesOfToken[_owner] >= _amount , "not enough tokens");
        _allowances[_owner][_spender] += _amount;

    }
    
    /**
    This function transfer tokens between accounts
    */
    function _transfer(address _from,address _to,uint256 _amount) internal virtual {

        require(_from != address(0), "transfer from the zero address");
        require(_to != address(0), "transfer to the zero address");
        require(_allowances[_from][_to] >= _amount);
        _spendAllowance(_from,_to,_amount);
        require(_balancesOfToken[_from] >= _amount, "transfer amount exceeds balance");
        _balancesOfToken[_from] -= _amount;
        _balancesOfToken[_to] += _amount;

    }

    /**
    This function change available transaction
    */
    function _spendAllowance(address _owner,address _spender,uint256 _amount) private {

        _allowances[_owner][_spender] -= _amount;
        
    }

    /**
    This function minting new tokens
    */
    function mintToken (address _to , uint _value) internal virtual {

         require(_to!= address(0),"Error");
         require(_value!= 0 , "to low amount");
         _balancesOfToken[_to] += _value;
         _totalSupply += _value;
     }


}