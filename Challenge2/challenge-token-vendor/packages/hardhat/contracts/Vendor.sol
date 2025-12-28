// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./YourToken.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Vendor is Ownable {
    
    YourToken public yourToken;
    uint256 public constant tokensPerEth = 100;
    
    event BuyTokens(address buyer, uint256 amountOfETH, uint256 amountOfTokens);
    event SellTokens(address seller, uint256 amountOfTokens, uint256 amountOfETH);
    
    constructor(address tokenAddress) Ownable(msg.sender) {
        yourToken = YourToken(tokenAddress);
    }
    
    function buyTokens() public payable {
        require(msg.value > 0, "Send ETH to buy tokens");
        uint256 amountOfTokens = msg.value * tokensPerEth;
        yourToken.transfer(msg.sender, amountOfTokens);
        emit BuyTokens(msg.sender, msg.value, amountOfTokens);
    }
    
    function sellTokens(uint256 amount) public {
        require(amount > 0, "Amount must be greater than 0");
        uint256 amountOfETH = amount / tokensPerEth;
        require(amountOfETH > 0, "Amount too small");
        require(address(this).balance >= amountOfETH, "Vendor has insufficient ETH");
        
        yourToken.transferFrom(msg.sender, address(this), amount);
        
        (bool sent, ) = msg.sender.call{value: amountOfETH}("");
        require(sent, "Failed to send ETH");
        
        emit SellTokens(msg.sender, amount, amountOfETH);
    }
    
    function withdraw() public onlyOwner {
        uint256 balance = address(this).balance;
        require(balance > 0, "Vendor has no ETH");
        (bool sent, ) = owner().call{value: balance}("");
        require(sent, "Failed to send ETH");
    }
}