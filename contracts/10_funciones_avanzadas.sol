//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//Funciones avanzadas
 contract Food {

     //Estructura de datos
     struct dinnerPlate {
         string name;
         string ingredients;
     }

     //Menu del dia
     dinnerPlate [] public menu;

     //Creacion de un nuevo menu
     function newMenu(string memory _name, string memory _ingredients) internal {
         menu.push(dinnerPlate(_name, _ingredients));
     }

 }

//Nuevo contrato que hereda del anterior
 contract Hamburguer is Food {

     address public owner;

     constructor() {
         owner = msg.sender;
     }

     //Hacer una hamburguesa desde el smart contract principal
     function doHamburguer(string memory _ingredients, uint _units) external {
         //Limitar a 5 la cantida máxima
         require(_units <= 5, "No puedes pedir tanta cantidad :)");
         newMenu("Hamburguer", _ingredients);
     }

     //Modifier para permitir el acceso solamente al ownwer
     modifier onlyOwner() {
         require(owner == msg.sender, "No tienes permisos para ejecutar esta funcion");
         _;
     }

     //Funcion para probar la restriccion del modifier y que solo el owner la pueda ejecutar
     function hashPrivateNumber(uint _number) public view onlyOwner returns (bytes32){
         return keccak256(abi.encodePacked(_number));

     }


 }