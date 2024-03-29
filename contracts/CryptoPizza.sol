//SPDX-License-Identifier: 	MIT
pragma solidity ^0.8.15;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

import "./libraries/Base64.sol";

//@author: r-drg
//@title: A contract for buying pizza
contract CryptoPizza is ERC721, Ownable {
    //Structure of a pizza
    struct Pizza {
        string name;
        string description;
        uint256 price;
        string image;
    }

    string public imageURI;

    // Map of each order to the pizzaIds it contains
    mapping(uint256 => uint256[]) public orders;

    mapping(uint256 => bool) public pizzaClaims;

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    Pizza[] public pizzas;

    event PizzaOrderCreated(
        uint256 orderId,
        uint256[] pizzaIds,
        address customer
    );

    constructor(
        string[] memory pizzaNames,
        string[] memory pizzaDescriptions,
        uint256[] memory pizzaPrices,
        string[] memory pizzaImages,
        string memory _imageURI
    ) ERC721("CryptoPizza", "CPZ") {
        for (uint256 i = 0; i < pizzaNames.length; i++) {
            Pizza memory pizza;
            pizza.name = pizzaNames[i];
            pizza.description = pizzaDescriptions[i];
            pizza.price = pizzaPrices[i];
            pizza.image = pizzaImages[i];
            pizzas.push(pizza);
        }
        imageURI = _imageURI;
         _tokenIds.increment();
    }

    /*
    This function is used to calculated the total price of a pizza order.
    @param pizzaIds: The ids of the pizzas in the order.
    @return: The total price of the order.
    */
    function calculatePrice(uint256[] memory pizzaIds)
        public
        view
        returns (uint256)
    {
        uint256 totalPrice = 0;
        for (uint256 i = 0; i < pizzaIds.length; i++) {
            totalPrice += pizzas[pizzaIds[i]].price;
        }
        return totalPrice;
    }

    /*
    This function is used to create a new pizza order.
    @param pizzaIds: The ids of the pizzas in the order.
    @dev: The function emits a PizzaOrderCreated event.
    */
    function mintPizza(uint256[] memory pizzaIds) external payable {
        uint256 totalPrice = calculatePrice(pizzaIds);
        require(
            totalPrice <= msg.value,
            "Total price of pizzas is greater than the amount sent"
        );

        uint256 newItemId = _tokenIds.current();

        // Add pizzas to the new pizza order
        orders[newItemId] = pizzaIds;

        // Mint the new token
        _safeMint(msg.sender, newItemId);

        orders[newItemId] = pizzaIds;

        _tokenIds.increment();

        pizzaClaims[newItemId] = false;

        emit PizzaOrderCreated(newItemId, pizzaIds, msg.sender);
    }

    function claimPizza(uint256 tokenId) external onlyOwner {
        require(
            pizzaClaims[tokenId] == false,
            "Pizza has already been claimed"
        );
        pizzaClaims[tokenId] = true;
    }

    function withdrawFunds() external onlyOwner {
        payable(owner()).transfer(address(this).balance);
    }

    function tokenURI(uint256 orderId)
        public
        view
        override
        returns (string memory)
    {
        uint256[] memory pizzaIds = orders[orderId];
        string memory orderAttributes = string.concat(
            '"attributes": [ { "trait_type": "Pizza #1", "value": "',
            pizzas[pizzaIds[0]].name,
            '"} '
        );
        for (uint256 i = 1; i < pizzaIds.length; i++) {
            orderAttributes = string.concat(
                orderAttributes,
                ', {"trait_type": "Pizza #',
                Strings.toString(i + 1),
                '", "value": "',
                pizzas[pizzaIds[i]].name,
                '"} '
            );
        }
        orderAttributes = string.concat(orderAttributes, ' ,{"trait_type": "Claimed" , "value": "', pizzaClaims[orderId] ? "True" : "False" , '"} ]');
        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "CryptoPizza #',
                Strings.toString(orderId),
                '", "description": "This is an NFT of a cryptopizza order!", "image": "',
                imageURI,
                '", ',
                orderAttributes,
                " }"
            )
        );
        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );
        return output;
    }

    function getAllPizzas() public view returns (Pizza[] memory) {
        return pizzas;
    }
}
