// SPDX-License-Identifier:MIT 

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";

contract MintAnimalToken is ERC721Enumerable { 
    constructor() ERC721("brandy","BTK") {}

    mapping(uint256 => uint256) public animalTypes; 
    
    function mintAnimalToken() public { 
        uint256 animalTokenId = totalSupply() + 1; 

        //+1을 했기 때문에 1부터 5까지의 값이 나옴. 
        uint256 animalType = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender, animalTokenId)))%5 +1; 

        animalTypes[animalTokenId]=animalType;

        _mint(msg.sender, animalTokenId);
    }
}
