//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.5.0/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts@4.5.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@4.5.0/access/Ownable.sol";

contract loteria is ERC20, Ownable {

    //================================
    //Gestion de tokens
    //================================

    //Direccion del contrato NFT del proyecto
    address public nft;


    //Constructor
    constructor() ERC20("Loteria", "ED") {
        _mint(address(this), 1000);
        //Al hacerse el deploy de este contrato, se hará automáticamente
        //el deploy del mainERC721
        nft = address(new mainERC721());

    }

    //Ganador del premio de la loteria
    address public ganador;

    //Registro del usuario
    mapping(address => address) public usuario_contract;

    //Precio de los tokens ERC20
    function precioTokens(uint256 _numTokens) internal pure returns (uint256) {
        return _numTokens * (1 ether);

    }

    //Visualizacion del balance de tokens ERC20 de un usuario
    function balanceTokens(address _account) public view returns (uint256) {
        return balanceOf(_account);
    }

    //Visualizacion del balance de tokens del Smart Contract
    function balanceTokensSC() public view returns (uint256) {
        return balanceOf(address(this));
    }

    //Visualizacion del balance de ethers del Smart Contract
    // 1 ether = 10**18 weis
    function balanceOfEthersSC() public view returns (uint256) {
        return address(this).balance / 10**18;
    }

    //Generacion de nuevos tokens ERC20
    function mint(uint256 _cantidad) public onlyOwner {
        _mint(address(this), _cantidad);
    }

    //Registro de usuarios
    function registrar() internal {
        address addr_personal_contract = address(new boletosNFTs(msg.sender, address(this), nft));
        usuario_contract[msg.sender] = addr_personal_contract;
    }

    //Informacion de un usuario
    function usersInfo(address _account) public view returns (address) {
        return usuario_contract[_account];

    }

    //Compra de tokens ERC20
    function compraToken(uint256 _numTokens) public payable {
        //Registro del usuario
        if(usuario_contract[msg.sender] == address(0)) {
            registrar();
        }
        //Establecimiento del costo de los tokens a comprar
        uint256 coste = precioTokens(_numTokens);
        //Evaluacion del dinero que el cliente paga por los tokens
        require(msg.value >= coste, "Compra menos tokens o paga con mas ethers");
        //Obtencion del numero de tokens ERC20 disponibles
        uint256 balance = balanceTokensSC();
        require(_numTokens <= balance, "COmpra menos tokens");
        uint256 returnValue = msg.value - coste;
        //El smart contract devuelve la cantidad restante 
        //Funcion interna que envia ethers
        payable(msg.sender).transfer(returnValue);
        //Envio de tokens al cliente/usuario (envia tokens)
        _transfer(address(this), msg.sender, _numTokens);

    }
    //Devolucion de tokens al smart contract
    function devolverTokens(uint _numTokens) public payable {
        //El numero de tokens deber ser mayor a cero
        require(_numTokens > 0, "Necesitas devolver un numero de tokens mayor a cero");
        //El usuario debe acreditar que tiene los tokens que quiere devolver
        require(_numTokens <= balanceTokens(msg.sender), "No tienes los tokens que deseas devolver");
        //El usuario transfiere los tokens al smart contract
        _transfer(msg.sender, address(this), _numTokens);
        //El smart contract envia los ethers al usuario
        payable(msg.sender).transfer(precioTokens(_numTokens));
    }

    //================================
    //Gestion de la loteria
    //================================

    //Precio del boleto de loteria (pagado en tokens ERC20)
    uint public precioBoleto = 5;
    //Relacionar persona que compra el boleto con el numero del boleto
    mapping(address => uint[]) idPersona_boletos;
    //Relacion boleto => ganador
    mapping(uint => address) ADNBoleto;
    uint randNonce = 0;
    //Boletos de loteria generados
    uint [] boletosComprados;
    //Compra de boletos
    function compraBoleto(uint _numBoletos) public {
        //Precio total de los boletos a comprar
        uint precioTotal = _numBoletos * precioBoleto;
        //Verificacion de los tokens del usuario
        require(precioTotal <= balanceTokens(msg.sender),
        "No tienes tokens suficientes");
        //transferencia de tokens del usuario al smart contract
        _transfer(msg.sender, address(this), precioTotal);
          /* Recoge la marca de tiempo (block.timestamp), msg.sender y un Nonce
        (un numero que solo se utiliza una vez, para que no ejecutemos dos veces la misma 
        funcion de hash con los mismos parametros de entrada) en incremento.
        Se utiliza 'keccak256 'para convertir estas entradas a un hash aleatorio, 
        convertir ese hash a un uint y luego utilizamos % 10000 para tomar los ultimos 4 digitos,
        dando un valor aleatorio entre 0 - 9999. */
        for(uint i=0; i<_numBoletos; i++) {
            uint random = uint(keccak256(abi.encodePacked(block.timestamp, msg.sender, randNonce))) % 10000;
            randNonce++;
            //Almacenamiento de los datos del boleto enlazados al usuario
            idPersona_boletos[msg.sender].push(random);
            //Almacenamiento de los datos de los boletos
            boletosComprados.push(random);
            //Asignacion del ADN de un boleto para la generacion de un ganador
            ADNBoleto[random] = msg.sender;
            //Creacion de un nuevo NFT para el numero de boleto
            boletosNFTs(usuario_contract[msg.sender]).mintBoleto(msg.sender, random);

        }
    }

    //Visualizacion de los boletos del usuario
    function tusBoletos(address _propietario) public view returns (uint [] memory) {
        return idPersona_boletos[_propietario];

    }

    //Generacion del ganador de la loteria
    function generarGanador() public onlyOwner {
        //Declaracion de la longitud del array
        uint longitud = boletosComprados.length;
        //Verificacion de la compra de al menos un boleto
        require(longitud > 0, "No hay boletos comprados");
        //Eleccion aleatoria entre [0 - longitud]
        uint random = uint(uint(keccak256(abi.encodePacked(block.timestamp))) % longitud);
        //Seleccion del numero aleatorio
        uint eleccion = boletosComprados[random];
        //Direccion del ganador de la loteria
        ganador = ADNBoleto[eleccion];
        //Envio del 95% del premio al ganador
        payable(ganador).transfer(address(this).balance * 95 / 100);
        //Envio del 5% al propietario
        payable(owner()).transfer(address(this).balance * 5 / 100);



    }


}

//Hay que hacer esto porque si se heredaran los dos contratos juntos
// habría conflicto con las funciones que tienen el mismo nombre
//Contrato de NFTs
contract mainERC721 is ERC721 {
 
    address public direccionLoteria;
   
    constructor() ERC721("Loteria", "STE"){
        //El owner es la direccion del contrato principal 
        //(porque se desplego automaticamente)
        direccionLoteria = msg.sender;
    }

    //Creacion de tokens NFT
    function safeMint(address _propietario, uint256 _boleto) public {
        require(msg.sender == loteria(direccionLoteria).usersInfo(_propietario), 
        "No tienes permisos para ejecutar esta funcion");
        _safeMint(_propietario, _boleto);

    }

}

contract boletosNFTs {
    //Datos relevantes del propietario
    struct Owner {
        address direccioPropietario;
        address contratoPadre;
        address contratoNFT;
        address contratoUsuario;

    }
    //Estructura de datos de tipo Owner
    Owner public propietario;

    //Constructor del Smart Contract (Hijo)
    constructor(address _propietario, address _contratoPadre, address _contratoNFT) {
        propietario = Owner(_propietario, 
                           _contratoPadre, 
                           _contratoNFT, 
                           address(this));

    }

    //Conversion de los numeros de los boletos de loteria
    function mintBoleto(address _propietario, uint _boleto) public {
        require(msg.sender == propietario.contratoPadre, 
        "No tienes permisos para ejecutar esta funcion");

        mainERC721(propietario.contratoNFT).safeMint(_propietario, _boleto);
    }
}
