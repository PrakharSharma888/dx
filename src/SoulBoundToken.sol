// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

error NotASoulBoundSeller();
error NotAOwner();

contract SoulBoundToken is ERC721, ERC721URIStorage, ERC721Burnable, Ownable {
    uint256 private _nextTokenId;
    address public admin;
    address public developer;

    constructor(address initialOwner)
        ERC721("SOULSELLER", "SSR")
        Ownable(initialOwner)
    {
        admin = msg.sender;
    }

    function registerAsDeveloper(address _address) public{
        developer = _address;
    }

    function registerAsSeller(address _address) public{
        admin = _address;
    }

    modifier isItAdmin(
    ) {
        require(msg.sender == admin);
        _;
    }

    modifier isDeveloper(
    ) {
        require(msg.sender == developer);
        _;
    }


    function safeMint(address to, string memory uri) public onlyOwner isItAdmin {
        uint256 tokenId = _nextTokenId++;
        _safeMint(to, tokenId);
        _setTokenURI(tokenId, uri);
    }

    function burn(uint256 tokenId) public override isItAdmin {
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenId)
        public
        view
        override(ERC721, ERC721URIStorage) isItAdmin
        returns (string memory)
    {
        return super.tokenURI(tokenId);
    }

    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, ERC721URIStorage)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
