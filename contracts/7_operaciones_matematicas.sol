//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract maths {
    //suma
    function suma(uint a, uint b) public pure returns (uint) {
       return a + b;
    }

    //resta
    function resta(uint a, uint b) public pure returns (uint) {
       return a - b;
    }

    //producto
     function prod(uint a, uint b) public pure returns (uint) {
       return a * b;
    }

    //division
     function div(uint a, uint b) public pure returns (uint) {
       return a/b;
    }

    //exponenciacion
     function expon(uint a, uint b) public pure returns (uint) {
       return a**b;
    }

    //modulo
     function mod(uint a, uint b) public pure returns (uint) {
       return a%b;
    }

    // (x + y)%k
    function _addMod(uint x, uint y, uint k) public pure returns(uint) {
        return addmod(x, y, k);
    }

     // (x * y)%k
    function _mulMod(uint x, uint y, uint k) public pure returns(uint) {
        return mulmod(x, y, k);
    }

}