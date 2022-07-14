//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract data_structures {

//Estructura de datos de un cliente
struct Customer {
    uint256 id;
    string name;
    string email;
}

//Variable de tipo cliente
Customer customer_1 = Customer(1, "Enzo", "enzo@test.com");

//Array de uints de longitud fija
uint256 [6] public fixed_list_uints = [1,2,3,4,5];

//Array dinámico de uints
uint256 [] dynamic_list_uints;

//Array dinámico de tipo cliente
Customer [] public dynamic_list_customer;

//Nuevos datos en un array
function array_modification (uint256 _id, string memory _name, string memory _email) public {
  Customer memory random_customer = Customer(_id, _name, _email);
  dynamic_list_customer.push(random_customer);
}

//Mappings (relaciones clave-valor)
//declarar una direccion con un saldo
mapping (address => uint256) public address_uint;

//relacionar una clave string con una lista de uints
mapping (string => uint256[]) public string_list_uints;

//relacionar un address con una estructura de datos
mapping (address => Customer) public address_data_structure;

//Asignamos valores a esos mappings
//Asignar un numero a una direccion 
function assignNumber(uint256 _number) public {
  address_uint[msg.sender] = _number;
}

//Asignar varios numeros a una direccion
function assignList(string memory _name, uint256 _number) public {
    string_list_uints[_name].push(_number);
}

//Asignar una estructura de datos a una direccion
function assignDataStructure(uint _id, string memory _name, string memory _email) public {
    address_data_structure[msg.sender] = Customer(_id, _name, _email);
    
}
}