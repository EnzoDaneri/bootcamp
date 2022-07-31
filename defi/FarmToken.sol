//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./JamToken.sol";
import "./StellartToken.sol";

contract TokenFarm {

    //Declaraciones iniciales
    string public name = "Stelart Token Farm";
    address public owner;
    JamToken public jamToken;
    StellartToken public stellarToken;

    //Estructuras de datos
    address [] public stakers;
    mapping(address => uint) public stakingBalance;
    mapping(address => bool) public hasStaked;
    mapping(address => bool) public isStaking;

    //Constructor
    constructor(StellartToken _stellartToken, JamToken _jamToken) {
        stellarToken = _stellartToken;
        jamToken = _jamToken;
        owner = msg.sender;
    }

    //Stake de tokens
    function stakeTokens(uint _amount) public {
        //Se requiere una cantidad superior a cero
        require(_amount > 0, "the amount cannot be less than 0");

        //Transferir tokens JAM al Smart Contract principal
        jamToken.transferFrom(msg.sender, address(this), _amount);

        //Actualizar el saldo del staking
        stakingBalance[msg.sender] += _amount;

        //Guardar el staker
        if(!hasStaked[msg.sender]) {
            stakers.push(msg.sender);

        }
        //Actualizar el estado del staking
        isStaking[msg.sender] = true;
        hasStaked[msg.sender] = true;

    }

    //Quitar el staking de los tokens
    function unstakeTokens() public {
        //Saldo del staking de un usuario
        uint balance = stakingBalance[msg.sender];
        //Se requiere una cantidad superior a cero
        require(balance > 0, "Staking balance is 0");
        //Transferencia de los tokens al usuario
        jamToken.transfer(msg.sender, balance);
        //Resetear el balance de staking del usuario
        stakingBalance[msg.sender] = 0;
        //Actualizar el estado del staking
        isStaking[msg.sender] = false;
    }

    //Emision de tokens (recompensas)
    function issueTokens() public {
        //Unicamente ejecutable por el owner
        require(msg.sender == owner, "you are not the owner");
        //Emitir tokens a todos los stakers
        for(uint i=0; i < stakers.length; i++) {
            address recipient = stakers[i];
            uint balance = stakingBalance[recipient];
            if(balance > 0) {
                stellarToken.transfer(recipient, balance);

            }

        }
    }

}

