//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract functions {
    // Funciones de tipo pure (no se accede a la Blockchain)
    function getName() public pure returns(string memory) {
        return "Enzo";
    }

    // Funciones de tipo view (sí accede a la Blockchain y guarda un valor)
    uint256 x = 100;
    function getNumber() public view returns(uint256) {
        return x*2;
    }
}

//-------------------

