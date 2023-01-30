//--------------------------
// Marking assignment related comment with @dev prefix
//--------------------------

// SPDX-License-Identifier: MIT
pragma solidity ^0.4.17;

contract CustomerDB {
    // Comment...
    // @dev declaring two events. Each take a usigned integer idOrder as argument
    event OrderPurchased(uint256 idOrder);
    event OrderShipped(uint256 idOrder);

    // Comment...
    // @dev declaring a Structure "Customer". "Customer" contains 2 variables.
    // @dev 1. customer id (uint256)
    // @dev 2. customer name (string)
    struct Customer {
        uint256 idCustomer;
        string customerName;
    }
    // @dev declaring a Structure "Order". "Order" contains 5 variables.
    // @dev 1. order id (uint256)
    // @dev 2. customer id (uint256)
    // @dev 3. item name (string)
    // @dev 4. quantity (uint256)
    // @dev 5. shipped (boolean)
    struct Order {
        uint256 idOrder;
        uint256 idCustomer;
        string itemName;
        uint256 quantity;
        bool shipped;
    }

    // Comment...
    // @dev declaring and initializeing state variable idOrder as 0.
    uint256 idOrder = 0;
    // @dev declaring a mapping "customers". A uint256 as key and "Customer" as value.
    mapping(uint256 => Customer) customers;
    // @dev declaring a mapping "orders". A uint256 as key and "Order" as value.
    mapping(uint256 => Order) orders;

    // Comment...
    // @dev Adding customer to the customers with constructor.
    /* @dev Commenting out the constructor and leverage function "addCustomer" to add new customer to the mapping.
    constructor() public {
        // Currently adding customers in the constructor.
        // ***
        // *** NOTE: As part of the assignment commenting all the code to show your understanding,
        // *** you need to write a function to add Customers through the Remix interface instead of in the constructor, and delete the constructor.

        customers[0] = Customer(0, "John Smith");
        customers[1] = Customer(1, "Sarah Webster");
        customers[2] = Customer(2, "Dev Patel");
    }
    */

    // @dev declaring a function to add Customers to the customers mapping through the Remix interface.
    function addCustomer(uint256 _idCustomer,string memory _customerName) public {
        customers[_idCustomer] = Customer(_idCustomer, _customerName);
    }

    // Comment...
    // @dev declaring a function to purchase item. It takes 3 arguments. 1. customer id 2. item name 3. quantity
    function purchaseItem( uint256 _custId, string _itemName, uint256 _quantity) public {
        // @dev since idOrder initialized as 0 above, order id within the orders mppaing will starts at 1.
        // @dev It will increament idOrder before appending records to the orders mapping
        idOrder++; 
        orders[idOrder] = Order(idOrder, _custId, _itemName, _quantity, false); // @dev adding one record to the orders mapping
        emit OrderPurchased(idOrder); // emits a OrderPurchased event after appending record to the mapping.
    }

    // Comment...
    // @dev declaring a function to update the shipping status. Its takes the order id as argument.
    function shipItem(uint256 _idOrder) public {
        orders[_idOrder].shipped = true; // @dev update the shipped variable within the Orders structure to true. 
        emit OrderShipped(_idOrder); // emits a OrderShipped event after updating the shipping status.
    }

    // Comment...
    // @dev declaring a view function to obtain order detail by order id.
    function getOrderDetails(uint256 _idOrder) public view returns (uint256, string, string, uint256, bool) {
        uint256 cust = orders[_idOrder].idCustomer;
        return (cust, customers[cust].customerName, orders[_idOrder].itemName,
                orders[_idOrder].quantity, orders[_idOrder].shipped
        );
    }
}
