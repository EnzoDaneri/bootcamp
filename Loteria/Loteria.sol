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
