// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract EcommercePlatform {
    address payable public owner;
    mapping(string => uint256) public productPrices; 
    mapping(string => mapping(address => uint256)) public productQuantities;

    event ProductPurchased(string  product, address indexed buyer, uint256 quantity, uint256 totalPrice); 
    event ProductAdded(string  product, uint256 quantity, uint256 price); 

    error InsufficientFunds();
    error ProductNotAvailable();

    constructor() {
        owner = payable(msg.sender);
    }

    /**
     * @dev Function to purchase a product
     * @param product The name of the product
     * @param quantity The quantity of the product to purchase
     */
    function purchaseProduct(string memory product, uint256 quantity) public payable {
        uint256 totalPrice = productPrices[product] * quantity;
        require(msg.value >= totalPrice, "Insufficient funds");

        if (productQuantities[product][msg.sender] < quantity) {
            revert ProductNotAvailable();
        }

        owner.transfer(totalPrice);

        productQuantities[product][msg.sender] -= quantity;

        emit ProductPurchased(product, msg.sender, quantity, totalPrice);
    }

    /**
     * @dev Function to add product quantities
     * @param product The name of the product
     * @param quantity The quantity of the product to add
     * @param price The price of the product
     */
    function addProductQuantity(string memory product, uint256 quantity, uint256 price) public {
        productQuantities[product][msg.sender] += quantity;
        productPrices[product] = price;
        emit ProductAdded(product, quantity, price);
    }

    /**
     * @dev Function to withdraw the contract balance
     */
    function withdraw() public {
        require(msg.sender == owner, "Only the owner can withdraw");
        owner.transfer(address(this).balance);
    }

    /**
     * @dev Function to get the contract balance
     */
    function getBalance() public view returns (uint256) {
        return address(this).balance;
    }

    /**
     * @dev Fallback function to receive Ether
     */
    receive() external payable {}
}
