// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract SharedWallet {
    string public walletName;
    uint256 public walletBalance;
    mapping(address => bool) private walletOwner;

    constructor() {
        walletOwner[msg.sender] = true;
    }

    modifier isWalletOwner(address addrCaller)
    {
        require(walletOwner[addrCaller] == true,"You must be the owner to call this function");
        _;
    }

    function depositMoney() public payable isWalletOwner(msg.sender) {        
        walletBalance += msg.value;
    }

    function setWalletName(string memory _name) external isWalletOwner(msg.sender) {
        walletName = _name;
    }

    function withDrawMoney(address payable _to, uint256 _total) public payable isWalletOwner(msg.sender) {
        walletBalance -= _total;
        _to.transfer(_total);
    }

    function getWalletBalance() external view returns (uint256) {
        return walletBalance;
    }

    //Adds Wallet Owner
    function addWalletOwner(address addrNewOwner) public isWalletOwner(msg.sender)
    {
        walletOwner[addrNewOwner] = true;
    }

    //allows the frontend to check if the current address is wallet owner
    function chkWalletOwner() public view returns (bool)
    {
        if (walletOwner[msg.sender] == true)
        {
            return true;
        }
        return false;
    }
}

