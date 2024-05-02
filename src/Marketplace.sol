// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

// Make sure this interface is correctly defined based on the actual SoulboundToken contract
interface SoulboundToken {
    function isSeller(address _seller) external view returns (bool);
}

contract Marketplace is ERC721URIStorage, ReentrancyGuard, Ownable {
    uint private _itemIds;
    uint private _itemsSold;

    address payable marketplaceOwner;
    address public soulboundAddress;

    struct Product {
        uint itemId;
        address payable seller;
        string name;
        string description;
        uint price;
        uint stock;
        bool isActive;
    }

    mapping(uint => Product) private idToProduct;
    mapping(address => uint[]) private sellerToProducts;
    mapping(address => uint[]) private buyerToPurchases;

    constructor(address _soulboundAddress) ERC721("MarketplaceItems", "MPI") Ownable(msg.sender) {
        marketplaceOwner = payable(msg.sender);
        soulboundAddress = _soulboundAddress;
    }

    // Event declarations
    event ProductAdded(uint indexed itemId, address indexed seller, string name, uint stock);
    event ProductUpdated(uint indexed itemId, string name, uint stock);
    event ProductDeleted(uint indexed itemId);
    event ProductPurchased(uint indexed itemId, address indexed buyer, uint quantity);

    // Modifier to check if the caller is a verified seller
    modifier onlyVerifiedSeller() {
        require(SoulboundToken(soulboundAddress).isSeller(msg.sender), "Caller is not a verified seller");
        _;
    }

    // Add a new product to the marketplace
    function addProduct(string memory name, string memory description, uint price, uint stock) public onlyVerifiedSeller {
        uint itemId = _itemIds++;
        idToProduct[itemId] = Product({
            itemId: itemId,
            seller: payable(msg.sender),
            name: name,
            description: description,
            price: price,
            stock: stock,
            isActive: true
        });

        sellerToProducts[msg.sender].push(itemId);

        _mint(msg.sender, itemId);
        _setTokenURI(itemId, "URI placeholder");

        emit ProductAdded(itemId, msg.sender, name, stock);
    }

    // List all products a seller has listed
    function listProductsBySeller(address seller) public view returns (Product[] memory) {
        uint[] memory productIds = sellerToProducts[seller];
        Product[] memory products = new Product[](productIds.length);

        for (uint i = 0; i < productIds.length; i++) {
            products[i] = idToProduct[productIds[i]];
        }

        return products;
    }

    // List all products a user has purchased
    function listPurchasesByBuyer(address buyer) public view returns (Product[] memory) {
        uint[] memory productIds = buyerToPurchases[buyer];
        Product[] memory products = new Product[](productIds.length);

        for (uint i = 0; i < productIds.length; i++) {
            products[i] = idToProduct[productIds[i]];
        }

        return products;
    }

    // List all unsold products
    function listUnsoldProducts() public view returns (Product[] memory) {
        uint count;
        for (uint i = 0; i < _itemIds; i++) {
            if (idToProduct[i].stock > 0 && idToProduct[i].isActive) {
                count++;
            }
        }

        Product[] memory unsold = new Product[](count);
        uint index = 0;
        for (uint i = 0; i < _itemIds; i++) {
            if (idToProduct[i].stock > 0 && idToProduct[i].isActive) {
                unsold[index] = idToProduct[i];
                index++;
            }
        }

        return unsold;
    }

    // Purchase a product
    function purchaseProduct(uint itemId, uint quantity) public payable nonReentrant {
        Product storage product = idToProduct[itemId];
        require(product.isActive, "Product is not active");
        require(product.stock >= quantity, "Insufficient stock");
        require(msg.value == product.price * quantity, "Incorrect amount sent");

        product.stock -= quantity;
        _itemsSold++;

        product.seller.transfer(msg.value);
        buyerToPurchases[msg.sender].push(itemId);

        emit ProductPurchased(itemId, msg.sender, quantity);
    }
}
