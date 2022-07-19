//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract padre {
    //Almacenamiento de la informacion del factory
    mapping(address => address) public personal_contract;

    //Emision de los nuevos smart contracts
    function Factory() public {
        //msg.sender es el owner(persona que cliquea el factory) y la direccion del contrato padre es address(this)
        address adr_personal_contract = address(new hijo(msg.sender, address(this)));
        personal_contract[msg.sender] = adr_personal_contract;
    }

}

contract hijo {
    Owner public propietario;
    //Estructura de datos del propietario
    struct Owner {
        address _owner;
        address _smartContractPadre;

    }
    // Recibe en el constructor datos del padre
    constructor(address _account, address _accountSC){
        propietario._owner = _account;
        propietario._smartContractPadre = _accountSC;
    }

}