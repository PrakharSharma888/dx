// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract SoulboundToken is ERC721Enumerable, Ownable {
    uint private sellerTokenId = 1;
    uint private adminTokenId = 10001;

    constructor() ERC721("SoulboundToken", "SBT") Ownable(msg.sender) {}

    // Mint a new Soulbound Token for sellers
    function mintSeller(address to) public onlyOwner {
        _mint(to, sellerTokenId);
        sellerTokenId++;
    }

    // Mint a new Soulbound Token for admins
    function mintAdmin(address to) public onlyOwner {
        _mint(to, adminTokenId);
        adminTokenId++;
    }

    // Prevent transferring of tokens to make them soulbound
    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId); // Call the parent function
        require(from == address(0), "SoulboundToken: tokens are non-transferable");
    }

    function supportsInterface(bytes4 interfaceId) public view override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    // Check if a user is an admin
    function isAdmin(address user) public view returns (bool) {
        return balanceOf(user) > 0 && tokenOfOwnerByIndex(user, 0) >= 10001;
    }

    // Check if a user is a seller
    function isSeller(address user) public view returns (bool) {
        return balanceOf(user) > 0 && tokenOfOwnerByIndex(user, 0) < 10001;
    }
}
