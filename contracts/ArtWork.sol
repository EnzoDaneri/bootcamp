//SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts@4.4.2/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.4.2/access/Ownable.sol";

contract ArtToken is ERC721, Ownable {
    //===============================================
    // Initial Statements
    //===============================================

    // Smart Contract Constructor
    constructor(string memory _name, string memory _symbol) 
    ERC721(_name, _symbol){}

    //NFT Token Counter
    uint256 COUNTER;

    //Pricing of NFTtokens (price of artwork)
    uint256 fee = 5 ether;

    //Data structure with the properties of the artwork
    struct Art{
        string name;
        uint256 id;
        uint256 dna;
        uint8 level;
        uint8 rarity;
    }

    //Storage structure for keeping artworks
    Art[] public art_works;

    //Declaration of an Event
    event NewArtWork(address indexed owner, uint256 id, uint256 dna);

    //===============================================
    // Help Functions
    //===============================================

    //Creation of a random number (required for the NFT token properties)
    function _createRandomNum(uint256 _mod) internal view returns(uint256) {
        bytes32 hash_RandomNum = keccak256(abi.encodePacked(block.timestamp, msg.sender));
        uint256 randomNum = uint256(hash_RandomNum);
        return randomNum % _mod;
    }

    //NFT Token creation (artWork)
    function _createArtWork(string memory _name) internal {
        uint8 randRarity = uint8(_createRandomNum(1000));
        uint256 randDna = _createRandomNum(10**16);
        Art memory newArtWork = Art(_name, COUNTER, randDna, 1, randRarity);
        art_works.push(newArtWork);
        _safeMint(msg.sender, COUNTER);
        emit newArtWork(msg.sender, COUNTER, randDna);
        COUNTER++;
    }

    //NFT Token price update
    function updateFee(uint256 _fee) external onlyOwner {
        fee = _fee;
    }

    //Visualize the balance of the Smart Contract (ethers)
    function infoSmartContract() public view returns(address, uint256) {
        address SC_address = address(this);
        uint256 SC_money = address(this).balance / 10**18;
        return (SC_address, SC_money);
    }

    //Obtaining all created NFT tokens (artWorks)
    function getArtWorks() public view returns (Art [] memory) {
        return art_works;
    }

    //Obtaining a user NFTs tokens
    function getOwnerArtWorks(address _owner) public view returns (Art [] memory) {
        Art[] memory art = new Art[] (balanceOf(_owner));
        uint256 counter_owner = 0;
        for(uint256 i = 0; art_works.length; i++) {
            if(ownerOf(i) == _owner) {
                result[counter_owner] = art_works[i];
                counter_owner++;
            }
        }
        return result;
    }

    //===============================================
    // NFT Token Development
    //===============================================








}