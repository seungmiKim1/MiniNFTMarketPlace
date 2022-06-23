// SPDX-License-Identifier:MIT 

pragma solidity ^0.8.0;
import "MintAnimalToken.sol";

//판매함수 

contract SaleAnimalToken { 
    MintAnimalToken public mintAnimalTokenAddress; 

    constructor(address _mintAnimalTokenAddress){
        mintAnimalTokenAddress = MintAnimalToken(_mintAnimalTokenAddress); 
    } 

    mapping(uint256 => uint256) public animalTokenPrices; 
    
    uint256[] public onSaleAnimalTokenArray;  // 현재 판매되고 있는 작품들 

    // 판매 함수(Owner가 누군지에 대한 판별도 중요) 

    function setForSaleAnimalToken(uint256 _animalTokenId, uint256 _price) public {
        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId); 

        require(animalTokenOwner == msg.sender, "Caller is not animal Token Owner"); 
        require(_price>0, "Price is zero or lower"); 
        require(animalTokenPrices[_animalTokenId]==0, "This animal Token is already on sale"); 
        require(mintAnimalTokenAddress.isApprovedForAll(animalTokenOwner,address(this)),"Animal Token onwer did not approve Token");

        animalTokenPrices[_animalTokenId]=_price; 

        onSaleAnimalTokenArray.push(_animalTokenId);
    }

    // 구매함수 
    // payable은 폴리곤 matic 관련 
    function purchaseAnimalToken(uint256 _animalTokenId) public payable { 
        uint256 price = animalTokenPrices[_animalTokenId];
        address animalTokenOwner = mintAnimalTokenAddress.ownerOf(_animalTokenId); 

        require(price >0, "Animal token not sale"); 
        require(price <= msg.value, "Caller sent lower than price");
        require(animalTokenOwner != msg.sender, "Caller is animal Token Onwer");

        payable(animalTokenOwner).transfer(msg.value);
        mintAnimalTokenAddress.safeTransferFrom(animalTokenOwner, msg.sender, _animalTokenId); 

        animalTokenPrices[_animalTokenId]=0; 

        for(uint256 i=0; i<onSaleAnimalTokenArray.length;i++){
            if(animalTokenPrices[onSaleAnimalTokenArray[i]]==0){
                onSaleAnimalTokenArray[i]=onSaleAnimalTokenArray[onSaleAnimalTokenArray.length-1];
                onSaleAnimalTokenArray.pop();
            }
        }
    }


    //프론트엔드단에서 현재 판매중인 NFT 아이템 출력 (길이만 출력되면 위에서 변수 선언한 onSaleAnimalTokenArray for문 돌림 
        function getOnSaleAnimalTokenArrayLength() view public returns (uint256) { 
            return onSaleAnimalTokenArray.length; 
        }
    }
