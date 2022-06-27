//SPDX-License-Identifier: 	MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract CryptoPizza is ERC721 {

    struct Pizza {
        string name;
        string description;
        uint8 price;
    }

    struct Order {
        address customer;
        Pizza[] pizzas;
    }

    Pizza[] public pizzas;

    constructor(
        string[] memory pizzaNames,
        string[] memory pizzaDescriptions,
        uint8[] memory pizzaPrices
    )
    ERC721("CryptoPizza", "CPZ")
    {
        for (uint8 i = 0; i < pizzaNames.length; i++) {
            Pizza memory pizza;
            pizza.name = pizzaNames[i];
            pizza.description = pizzaDescriptions[i];
            pizza.price = pizzaPrices[i];
            pizzas.push(pizza);
        }
    }

    function calculatePrice(uint8[] memory pizzaIds) public view returns (uint8){
        uint8 totalPrice = 0;
        for (uint8 i = 0; i < pizzaIds.length; i++) {
            totalPrice += pizzas[pizzaIds[i]].price;
        }
        return totalPrice;
    }

    


}
