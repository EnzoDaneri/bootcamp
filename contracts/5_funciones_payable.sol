//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

contract ethSend {
    constructor() payable {}
    receive() external payable {}

    //Eventos
    event sendStatus(bool);
    event callStatus(bool, bytes);

      //transfer (envia 2300 unidades de gas)
     function sendViaTransfer(address payable _to) public payable{
          _to.transfer(1 ether);
     }

     //send (envia 2300 unidades de gas)
     //(devuelve un boolean que indica si fue enviado correctamente)
     function sendViaSend(address payable _to) public payable {
         bool sent = _to.send(1 ether);
         emit sendStatus(sent);
         //si el evento emite false detengo la ejecución
         require(sent == true, "El envio ha fallado");
     }

     //call (envia todo el gas sin restricciones)
     // devuelve un boolean e informacion de la transaccion
     function sendViaCall(address payable _to) public payable {
         (bool success, bytes memory data) = _to.call{value: 1 ether}("");
         emit callStatus(success, data);
         require(success == true, "El envio ha fallado");
     }
    
}

contract ethReciever {
    event log(uint ammount, uint gas);
    receive() external payable {
        //emitimos evento con el balance de la direccion y el gas restante
        emit log(address(this).balance, gasleft());
    }

   
}