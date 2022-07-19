//SPDX-Identifier-License: MIT
/*

//Propiedades de los bloques y transacciones:

//blockhash:  devuelve el hash de un bloque(cuando es uno de los 256 bloques más recientes, de lo contrario devuelve cero).
blockhash(uint blockNumber) returns(bytes32);

//basefee: devuelve la tarifa base del bloque actual.
block.basefee(uint);

//chainId: devuelve el id de la cadena actual
block.chainid(uint);

//coinbase: devuelve la dirección del minero que ha minado ese bloque.
block.coinbase();

//difficulty: devuelve la dificultad del bloque actual como un uint;
block.difficulty(uint);

//gaslimit: devuelve el límite de gas del bloque actual.
block.gaslimit(uint);

//number: devuelve el número de bloque actual.
block.number(uint);

//timestamp: devuelve la marca de tiempo del bloque actual en segundos desde la creación de UNIX (1 de enero de 1970). Antes se llamaba block.now.
block.timestamp(uint);

//gasleft: devuelve el gas restante.
gasleft() returns (uint256);

msg.data(): devuelve información con los datos completos de la llamada.

msg.sender(address): devuelve el remitente del mensaje.

msg.sig(bytes4): devuelve los primeros cuatro bytes de los datos de llamada (identificador de función).

msg.value(uint): devuelve el número de wei o ethers enviados con el mensaje.

tx.gasprice(uint): devuelve el precio del gas de la transacción.

tx.origin(address): devuelve el remitente de la transacción.  

*/