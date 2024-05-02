The Marketplace contract allows sellers to list products for sale, manages the purchase of these products, and tracks ownership through ERC721 tokens. It also employs a non-reentrancy guard for transaction security and ownership management via the Ownable contract. A soulbound token mechanism is utilized to verify seller credentials, ensuring that only approved sellers can list products.

# Contract Features

**NFT-based Product Listings**: Products are represented as NFTs, providing clear ownership and provenance.
Seller Verification: Only verified sellers can add products, using an external SoulboundToken for authentication.
Product Lifecycle Management: Products can be added, listed, and purchased. The stock is managed through the contract, ensuring that sales cannot exceed available inventory.

**Transaction Security**: The contract uses non-reentrancy checks to prevent re-entrant attacks during financial transactions.
Ownership and Administrative Control: Utilizes OpenZeppelin’s Ownable to manage contract ownership, providing administrative functions restricted to the owner.

# Contract Functions
# Constructor
Parameters:
_soulboundAddress: The address of the SoulboundToken contract used for seller verification.
Description: Initializes the contract, setting up the marketplace owner and linking to the SoulboundToken for seller verification.

# Events
ProductAdded: Triggered when a new product is added.
ProductUpdated: Triggered when a product's details are updated.
ProductDeleted: Triggered when a product is deleted.
ProductPurchased: Triggered when a product is purchased.

# Modifiers
onlyVerifiedSeller: Ensures that the function caller is a verified seller by checking their status via the SoulboundToken contract.

# Public Functions

**addProduct**:
Parameters: name, description, price, stock
Modifiers: onlyVerifiedSeller
Description: Allows verified sellers to list a new product on the marketplace. Each product is assigned a unique item ID and represented as an NFT.
**listProductsBySeller**:
Parameters: seller (address of the seller)
Returns: Array of products listed by the specified seller.
Description: Provides a list of all products associated with a given seller.
**listPurchasesByBuyer**:
Parameters: buyer (address of the buyer)
Returns: Array of products purchased by the specified buyer.
Description: Retrieves all products that a specific buyer has purchased.
**listUnsoldProducts**:
Returns: Array of all products that are still available for purchase.
Description: Lists all products that have not yet been sold out.
**purchaseProduct**:
Parameters: itemId (ID of the product), quantity (number of units to purchase)
Modifiers: nonReentrant
Description: Allows buyers to purchase a specified quantity of a product. The transaction requires sending sufficient funds and decrements the stock of the product.

# Usage and Interaction Flow
Deployment: Deploy the contract with the address of the SoulboundToken contract.
Seller Verification: Sellers must be verified through the SoulboundToken mechanism to list products.
Product Listing: Verified sellers can add products, which are then available for purchase by any buyer.
Purchasing: Buyers can purchase products by calling purchaseProduct, sending the correct amount of Ether.
Tracking: Both buyers and sellers can track their transactions and product statuses through the various listing functions.