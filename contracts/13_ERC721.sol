//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

// Importacion de Smart Contracts desde Openzeppelin
import "@openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.5.0/utils/Counters.sol";

contract erc721 is ERC721 {
    

    //Contadores para los IDs de los NFTs
    using Counters for Counters.Counter;
    Counters.Counter private _tokensIds;

    //Constructor del smart contract
    constructor(string memory _name, string memory _symbol) ERC721(_name, _symbol) {}

    //Envio de NFTs
    function sendNFT(address _account) public {
        _tokensIds.increment();
        uint256 newItemId = _tokensIds.current();
        _safeMint(_account, newItemId);

    }

}