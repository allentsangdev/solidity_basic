//--------------------------
// Marking assignment related comment with @dev prefix
//--------------------------

// SPDX-License-Identifier: MIT
pragma solidity ^0.4.17;

contract Supplier {
    // Comment...
    // @dev declaring two events.
    event ItemAdded(uint256 idItem);
    event ProcessAnOrder(uint256 idOfCustomer, uint256 idOrder, bool status);

    // Comment...
    // @dev declarig structure "Item". Contains 3 variables:
    // @dev 1. Item id (uint256)
    // @dev 2. Item Name (string)
    // @dev 3. Price (uint256)
    struct Item {
        uint256 idItem;
        string itemName;
        uint256 price;
    }
    // @dev declarig structure "Orderlog". Contains 3 variables:
    // @dev 1. Customer id (uint256)
    // @dev 2. Order id (uint256)
    // @dev 3. Status (bool)
    struct Orderlog {
        uint256 idOfCustomer;
        uint256 idOrder;
        bool status;
    }

    // Comment...
    // @dev declaring state variables.
    // @dev numItemsForSale is used to keep track of how many items available for sale.
    // @dev Will increment by 1 when function addItem is called. 
    uint256 numItemsForSale;
    // @dev numOrdersProcessed is used to keep track of how many items are provessed.
    // @dev Will increment by 1 when function "processOrder" is called. 
    uint256 numOrdersProcessed;
    // @dev declaring a mapping to store Item.
    // @dev will append 1 record to the mapping when function "addItem" is called
    mapping(uint256 => Item) items;
    // @dev declaring a mapping to store OrderLog. Processed order will be added to this mapping
    // @dev will append 1 record to the mapping when function "processOrder" is called
    mapping(uint256 => Orderlog) orderLogs;

    // Comment...
    // @dev declaring a function to add item. Takes item name and price as argument.
    // @dev the function will assign item id by using the numItemsForSales variable
    // @dev the function will emits a ItemAdded event at the end of the function
    // @dev Note that the first item id will be 0
    function addItem(string memory _itemName, uint256 _price) public {
        uint256 idItem = numItemsForSale++;
        items[idItem] = Item(idItem, _itemName, _price);
        emit ItemAdded(idItem);
    }

    // Comment...
    // @dev declaring a function to process order. Takes order id and customer id as arguments.
    // @dev the function will increase the numOrdersProcessed by 1 after appending record to the orderLog mapping
    // @dev the function will emits a ProcessAnOrder event at the end of the function
    function processOrder(uint256 _idOrder, uint256 _idCustomer) public {
        orderLogs[_idOrder] = Orderlog(_idCustomer, _idOrder, true);
        numOrdersProcessed++;
        emit ProcessAnOrder(_idCustomer, _idOrder, true);
    }

    // Comment...
    // @dev declaring a view function to obtain item name and item price by item id.
    function getItem(uint256 _idItem) public view returns (string memory, uint256) {
        return (items[_idItem].itemName, items[_idItem].price);
    }

    // @dev declaring a view function to obtain number of item available for sales. 
    // @dev returning the "numItemsForSales" variable
    function getTotalNumberOfItemsForSale() public view returns (uint256) {
        return numItemsForSale;
    }
    // @dev declaring a view function to obtain number of provessed order
    // @dev returning the "numOrdersProcessed" variable
    function getTotalNumberOfOrdersProcessed() public view returns (uint256) {
        return numOrdersProcessed;
    }
}
