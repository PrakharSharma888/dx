// // SPDX-License-Identifier: MIT
// pragma solidity ^0.8.0;

// import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
// import "@openzeppelin/contracts/access/Ownable.sol";
// import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

// contract GoldBackedToken is ERC20, Ownable, ReentrancyGuard {
//     uint256 public goldReserve; // in milligrams

//     // Token value against gold in milligrams per token
//     uint256 public constant goldBackingPerToken = 1;

//     constructor(uint256 initialReserve) ERC20("GoldBackedToken", "GBT") {
//         goldReserve = initialReserve;
//     }

//     // Mint new tokens and increase the gold reserve accordingly
//     function mint(address to, uint256 amount) public onlyOwner nonReentrant {
//         require(to != address(0), "Cannot mint to the zero address");
//         require(amount > 0, "Mint amount must be greater than zero");
//         uint256 requiredGold = amount * goldBackingPerToken;
//         require(goldReserve + requiredGold <= goldReserve, "Gold reserve overflow");
//         _mint(to, amount);
//         goldReserve += requiredGold;
//     }

//     // Burn tokens and decrease the gold reserve accordingly
//     function burn(address from, uint256 amount) public onlyOwner nonReentrant {
//         require(from != address(0), "Cannot burn from the zero address");
//         require(amount > 0, "Burn amount must be greater than zero");
//         require(balanceOf(from) >= amount, "Insufficient balance to burn");
//         uint256 goldToDeduct = amount * goldBackingPerToken;
//         require(goldReserve - goldToDeduct >= 0, "Insufficient gold reserve");
//         _burn(from, amount);
//         goldReserve -= goldToDeduct;
//     }

//     // Update the gold reserve (only in case of audit adjustments or physical gold changes)
//     function setGoldReserve(uint256 newReserve) public onlyOwner {
//         require(newReserve >= totalSupply() * goldBackingPerToken, "New reserve must cover all tokens");
//         goldReserve = newReserve;
//     }

//     // Get the current gold reserve
//     function getGoldReserve() public view returns (uint256) {
//         return goldReserve;
//     }
// }