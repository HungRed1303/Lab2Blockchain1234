// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

/**
 * @title DEX - Automated Market Maker
 * @notice Simple AMM using x*y=k formula
 */
contract DEX {
    
    /* ========== STATE VARIABLES ========== */
    
    IERC20 token;
    uint256 public totalLiquidity;
    mapping(address => uint256) public liquidity;
    
    /* ========== EVENTS ========== */
    
    event EthToTokenSwap(address swapper, uint256 tokenOutput, uint256 ethInput);
    event TokenToEthSwap(address swapper, uint256 tokensInput, uint256 ethOutput);
    event LiquidityProvided(address liquidityProvider, uint256 liquidityMinted, uint256 ethInput, uint256 tokensInput);
    event LiquidityRemoved(address liquidityRemover, uint256 liquidityWithdrawn, uint256 tokensOutput, uint256 ethOutput);
    
    /* ========== CONSTRUCTOR ========== */
    
    constructor(address token_addr) {
        token = IERC20(token_addr);
    }
    
    /* ========== MUTATIVE FUNCTIONS ========== */
    
    /**
     * @notice Initialize DEX với liquidity ban đầu
     * @param tokens Số lượng tokens để init
     */
    function init(uint256 tokens) public payable returns (uint256) {
        require(totalLiquidity == 0, "DEX: init - already has liquidity");
        totalLiquidity = address(this).balance;
        liquidity[msg.sender] = totalLiquidity;
        require(token.transferFrom(msg.sender, address(this), tokens), "DEX: init - transfer failed");
        return totalLiquidity;
    }
    
    /**
     * @notice Tính giá swap dựa trên AMM formula x*y=k
     * @param xInput Số lượng input asset
     * @param xReserves Reserve của input asset
     * @param yReserves Reserve của output asset
     * @return yOutput Số lượng output asset
     */
    function price(
        uint256 xInput,
        uint256 xReserves,
        uint256 yReserves
    ) public pure returns (uint256 yOutput) {
        uint256 xInputWithFee = xInput * 997; // 0.3% fee
        uint256 numerator = xInputWithFee * yReserves;
        uint256 denominator = (xReserves * 1000) + xInputWithFee;
        return (numerator / denominator);
    }
    
    /**
     * @notice Lấy liquidity của một address
     */
    function getLiquidity(address lp) public view returns (uint256) {
        return liquidity[lp];
    }
    
    /**
     * @notice Swap ETH → $BAL tokens
     */
    function ethToToken() public payable returns (uint256 tokenOutput) {
        require(msg.value > 0, "Cannot swap 0 ETH");
        uint256 ethReserve = address(this).balance - msg.value;
        uint256 tokenReserve = token.balanceOf(address(this));
        tokenOutput = price(msg.value, ethReserve, tokenReserve);
        
        require(token.transfer(msg.sender, tokenOutput), "ethToToken: transfer failed");
        emit EthToTokenSwap(msg.sender, tokenOutput, msg.value);
        return tokenOutput;
    }
    
    /**
     * @notice Swap $BAL tokens → ETH
     * @param tokenInput Số lượng tokens muốn swap
     */
    function tokenToEth(uint256 tokenInput) public returns (uint256 ethOutput) {
        require(tokenInput > 0, "Cannot swap 0 tokens");
        require(token.balanceOf(msg.sender) >= tokenInput, "Insufficient token balance");
        require(token.allowance(msg.sender, address(this)) >= tokenInput, "Insufficient allowance");
        
        uint256 tokenReserve = token.balanceOf(address(this));
        ethOutput = price(tokenInput, tokenReserve, address(this).balance);
        
        require(token.transferFrom(msg.sender, address(this), tokenInput), "tokenToEth: transfer failed");
        (bool sent, ) = msg.sender.call{value: ethOutput}("");
        require(sent, "tokenToEth: ETH transfer failed");
        
        emit TokenToEthSwap(msg.sender, tokenInput, ethOutput);
        return ethOutput;
    }
    
    /**
     * @notice Deposit liquidity vào DEX
     * @dev User phải approve tokens trước
     */
    function deposit() public payable returns (uint256 tokensDeposited) {
        require(msg.value > 0, "Must send ETH when depositing");
        
        uint256 ethReserve = address(this).balance - msg.value;
        uint256 tokenReserve = token.balanceOf(address(this));
        
        uint256 tokenDeposit = (msg.value * tokenReserve / ethReserve) + 1;
        require(token.balanceOf(msg.sender) >= tokenDeposit, "Insufficient token balance");
        require(token.allowance(msg.sender, address(this)) >= tokenDeposit, "Insufficient allowance");
        
        uint256 liquidityMinted = msg.value * totalLiquidity / ethReserve;
        liquidity[msg.sender] += liquidityMinted;
        totalLiquidity += liquidityMinted;
        
        require(token.transferFrom(msg.sender, address(this), tokenDeposit), "deposit: transfer failed");
        emit LiquidityProvided(msg.sender, liquidityMinted, msg.value, tokenDeposit);
        return tokenDeposit;
    }
    
    /**
     * @notice Withdraw liquidity từ DEX
     * @param amount Số lượng liquidity tokens muốn withdraw
     */
    function withdraw(uint256 amount) public returns (uint256 ethAmount, uint256 tokenAmount) {
        require(liquidity[msg.sender] >= amount, "Insufficient liquidity");
        
        uint256 ethReserve = address(this).balance;
        uint256 tokenReserve = token.balanceOf(address(this));
        
        uint256 ethWithdrawn = amount * ethReserve / totalLiquidity;
        tokenAmount = amount * tokenReserve / totalLiquidity;
        
        liquidity[msg.sender] -= amount;
        totalLiquidity -= amount;
        
        (bool sent, ) = payable(msg.sender).call{value: ethWithdrawn}("");
        require(sent, "withdraw: ETH transfer failed");
        require(token.transfer(msg.sender, tokenAmount), "withdraw: token transfer failed");
        
        emit LiquidityRemoved(msg.sender, amount, tokenAmount, ethWithdrawn);
        return (ethWithdrawn, tokenAmount);
    }
}