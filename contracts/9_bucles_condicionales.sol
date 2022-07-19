//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract loops_conditionals {
    // suma de los 10 primeros numeros a partir de un nro introducido
    function sum(uint _number) public pure returns(uint) {
        uint aux_sum = 0;

        //bucle for
        for(uint i =_number; i < (_number + 10); i++) {
            aux_sum = aux_sum + i;
        }
        return aux_sum;
    }

    // suma de los 10 primeros numeros impares
    function odd() public pure returns(uint) {
        uint aux_sum = 0;
        uint counter = 0;
        uint counter_odd = 0;

        while(counter_odd < 10) {
            if(counter % 2 != 0) {
                aux_sum = aux_sum + counter;
                counter_odd++;
            }
            counter++;
        }
        return aux_sum;
    }

    //Funcion para hacer operaciones segun lo que desee el usuario
    function operations(string memory _operation, uint a, uint b) public pure returns(uint) {

        //para hacer comparacion con un string primero hay que hacer el hash del mismo
        bytes32 hash_operation = keccak256(abi.encodePacked(_operation));
        if(hash_operation == keccak256(abi.encodePacked("suma"))) {
            return a + b;
        } else if (hash_operation == keccak256(abi.encodePacked("resta"))){
            return a - b;

        } else if (hash_operation == keccak256(abi.encodePacked("multiplicar"))){
            return a*b;

        } else if (hash_operation == keccak256(abi.encodePacked("dividir"))) {
            return a/b;
        } else {
            return 0;
        }


    }

}