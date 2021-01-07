// Bcoin ICO

// Version of compiler
pragma solidity ^0.5.16;

contract Bcoin_ICO {
    
    // Introducing the maximum number of Bcoins available for sale
    uint public max_Bcoins = 1000000;
    
    // Introducing the USD to Bcoins convertion rate
    uint public USD_to_Bcoins =1000;
    
    // Introducing the total number of Bcoins that have been bought by the investors
    uint public total_Bcoins_bought = 0;
    
    // Mapping from the investor address to its equity in Bcoins and USD
    mapping(address => uint) equity_Bcoins;
    mapping(address => uint) equity_usd;
    
    // Check if an investor can buy Bcoins
    modifier can_buy_bcoins(uint usd_invested) {
        require (usd_invested * USD_to_Bcoins + total_Bcoins_bought <= max_Bcoins);
        
    }
    
    // Getting the equity in Bcoins of an investor
    function equity_in_bcoins(address investor) external view returns (uint) {
        return equity_Bcoins[investor];
    }
    
    // Getting the equity in USD of an investor
    function equity_in_usd(address investor) external view returns (uint) {
        return equity_usd[investor];
    }
    
    // Buying Bcoins
    function buy_bcoins(address investor, uint usd_invested) external
    can_buy_bcoins(usd_invested) {
        uint bcoins_bought = usd_invested * USD_to_Bcoins;
        equity_Bcoins[investor] += bcoins_bought;
        equity_usd[investor] = equity_Bcoins[investor] / 1000;
        total_Bcoins_bought += bcoins_bought;
    }
    
    // Selling Bcoins
    function sell_bcoins(address investor, uint bcoins_sold) external {
        equity_Bcoins[investor] -= bcoins_sold;
        equity_usd[investor] = equity_Bcoins[investor] / 1000;
        total_Bcoins_bought -= bcoins_sold;
    }
    
}
