//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

//fallback y receive son funciones internas propias de Solidity 
contract Fallback_Receive {
   event log(string _name, address _sender, uint _amount, bytes _data);

// si msg.data no esta vacio => fallback()
// si msg.data esta vacio y no hay receiver => fallback()
   fallback() external payable {
     emit log("fallback", msg.sender, msg.value, msg.data);
   }

// si msg.data esta vacio y existe receive => receive()
   receive() external payable {
       emit log("receive", msg.sender, msg.value, "");
   }
}