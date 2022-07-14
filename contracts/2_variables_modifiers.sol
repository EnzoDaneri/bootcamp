// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract variables_modifiers {

// TIPOS DE VARIABLES Y MODIFICADORES EN SOLIDITY
// Enteros sin signo
    uint256 var_1;
    uint8 public var_2 = 3;

// Enteros con signo (int)
    int256 var_3;
    int8 public var_4 = -32;
    int var_5 = 65;

// String
    string name;
    string public public_name = "This is public";
    string private private_name = "This is private";

// Boolean
    bool public is_active = true;
    bool private is_public = false;   

// Bytes
    bytes32 first_byte;
    bytes4 second_byte;
    bytes1 public one_byte;

// Algoritmo de hash usando bytes
    bytes32 public hashing = keccak256(abi.encodePacked("Hello world"));

// Address
    address public my_address;
    address public address_1 = 0x5B38Da6a701c568545dCfcB03FcB875f56beddC4;
    address public address_2 = msg.sender;  

// enum    
enum options {ON, OFF}
options state;
options constant defaultChoice = options.OFF;

function turnON() public {
    state = options.ON;
}

function turnOFF() public {
    state = options.OFF;
}

function displayState() public view returns (options) {
    return state;
}

}