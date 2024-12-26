// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/// @title Decentralized Marketplace
/// @dev A contract to list and purchase items on a decentralized platform
contract Marketplace {
    struct Item {
        uint256 id;
        string name;
        uint256 price;
        address payable seller;
        address buyer;
    }

    uint256 public itemCount;
    mapping(uint256 => Item) public items;

    event ItemListed(uint256 id, string name, uint256 price, address seller);
    event ItemPurchased(uint256 id, address buyer);

    /// @notice List an item for sale
    /// @param _name Name of the item
    /// @param _price Price of the item in wei
    function listItem(string memory _name, uint256 _price) public {
        require(_price > 0, "Price must be greater than zero");

        itemCount++;
        items[itemCount] = Item({
            id: itemCount,
            name: _name,
            price: _price,
            seller: payable(msg.sender),
            buyer: address(0)
        });

        emit ItemListed(itemCount, _name, _price, msg.sender);
    }

    /// @notice Purchase an item
    /// @param _id ID of the item to purchase
    function purchaseItem(uint256 _id) public payable {
        Item storage item = items[_id];
        require(item.id > 0, "Item does not exist");
        require(item.price == msg.value, "Incorrect price");
        require(item.buyer == address(0), "Item already sold");
        require(item.seller != msg.sender, "Seller cannot buy their own item");

        item.seller.transfer(msg.value);
        item.buyer = msg.sender;

        emit ItemPurchased(_id, msg.sender);
    }

    /// @notice Get details of an item
    /// @param _id ID of the item
    function getItem(uint256 _id) public view returns (Item memory) {
        return items[_id];
    }
}
