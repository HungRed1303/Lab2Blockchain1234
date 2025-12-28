// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "hardhat/console.sol";
import "./ExampleExternalContract.sol";

contract Staker {
  ExampleExternalContract public exampleExternalContract;

  // Mapping để track balance của từng address
  mapping(address => uint256) public balances;
  
  // Threshold cần đạt được
  uint256 public constant threshold = 1 ether;
  
  // Deadline để stake
  uint256 public deadline = block.timestamp + 72 hours;
  
  // Track xem đã execute chưa
  bool public openForWithdraw = false;

  // Event để track stakes
  event Stake(address indexed staker, uint256 amount);

  constructor(address exampleExternalContractAddress) {
    exampleExternalContract = ExampleExternalContract(exampleExternalContractAddress);
  }

  // TODO: Implement stake function
  function stake() public payable {
    // Cập nhật balance của user
    balances[msg.sender] += msg.value;
    
    // Emit event
    emit Stake(msg.sender, msg.value);
  }

  // Function để check time còn lại
  function timeLeft() public view returns (uint256) {
    if (block.timestamp >= deadline) {
      return 0;
    }
    return deadline - block.timestamp;
  }
  // Modifier để check external contract chưa complete
  modifier notCompleted() {
    require(!exampleExternalContract.completed(), "Already completed");
    _;
  }

  // Execute function - gọi sau khi hết deadline
  function execute() public notCompleted {
    // Check đã hết deadline chưa
    require(block.timestamp >= deadline, "Deadline not reached");

    // Check đã đủ threshold chưa
    if (address(this).balance >= threshold) {
      // Đủ threshold → gửi sang external contract
      exampleExternalContract.complete{value: address(this).balance}();
    } else {
      // Không đủ → cho phép withdraw
      openForWithdraw = true;
    }
  }
  function withdraw() public notCompleted {
    require(openForWithdraw, "Not open for withdraw");
    
    uint256 userBalance = balances[msg.sender];
    require(userBalance > 0, "No balance to withdraw");
    
    // Reset balance trước khi transfer (prevent reentrancy)
    balances[msg.sender] = 0;
    
    // Transfer ETH về cho user
    (bool sent, ) = msg.sender.call{value: userBalance}("");
    require(sent, "Failed to send Ether");
  }
}