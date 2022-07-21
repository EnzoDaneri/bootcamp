//SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;
//import "@openzeppelin/contracts@4.5.0/token/ERC20/ERC20.sol";

//Interface
interface IERC20 {
    //Total de tokens
    function totalSupply() external view returns (uint256);

    //Balance de tokens de cada cuenta
    function balanceOf(address account) external view returns (uint256);

    //Transferencia hacia una dirección de una cantidad
    function transfer(address to, uint256 amount) external returns (bool);

    //Permitir que una cuenta que designe pueda gastar una cierta cantidad de tokens (prestamo)
    function allowance(address owner, address spender) external view returns (uint256);

    //Establecer la cantidad que le permitiremos gastar a esa cuenta a la que le prestamos
    function approve(address spender, uint256 amount) external  returns (bool);

    //Indicar emisor de la transferencia
    function transferFrom(
        address from,
        address to, 
        uint256 amount
         ) external returns (bool);


    //El parametro indexado permite buscar estos eventos utilizando 
    //los parametros indexados como filtros
    //Filtramos por la persona que emite la transferencia o por quien la recibe
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed ownwer, address indexed spender, uint256 value);     
 
}

     contract ERC20  is IERC20 {
    //Mapping de una cuenta y su balance
    mapping(address => uint256) private _balances;
    //Mapping de un owner y su spender con la cantidad
    mapping(address => mapping(address => uint256)) private _allowences;

    //Cantidad de tokens que tiene el smart contract
    uint256 private _totalSupply;
    string private _name;
    string private _symbol;

    constructor(string memory name_, string memory symbol_) {
        _name = name_;
        _symbol = symbol_;
    }

    // la palabra virtual se aplica cuando se crea una funcion fuera de la interfaz sin implementacion
    // dentro de la interfaz todas las funciones se consideran automáticamente virtual
    function name() public view virtual returns (string memory) {
        return _name;
    }

     function symbol() public view virtual returns (string memory) {
        return _symbol;
    }

    //Devolver el numero de decimales utilizados para obtener una representacion de los tokens ERC-20
    function decimals() public view virtual returns (uint8) {
        //Lo establecemos a 18 como en el estandar - Los tokens ERC-20 son divisibles a diferencia de los NFT que no lo son.
        //Ej: 505 unidades (si fueran 2 decimales en vez de 18)serían representadas como => 5.05 (505/10**2)
        return 18;
    }

    //Virtual y override se utilizan juntos. Virtual indica que una funcion se puede sobreescribir mas adelante 
    // y override sobreescribe la funcion definida anteriormente 
    function totalSupply() public view virtual override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(address account) public view virtual override returns (uint256) {
        return _balances[account];

    }

    function transfer(address to, uint amount) public virtual override returns (bool) {
       address owner = msg.sender;
       //Llamado a funcion interna
       _transfer(owner, to, amount);
       return true;

    }

    function allowance(address owner, address spender) public view virtual override returns (uint256) {
        return _allowences[owner] [spender];

    }

    function approve(address spender, uint256 amount) public virtual override returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, amount);
        return true;

    }

    function transferFrom(
        address from,
        address to, 
        uint256 amount
    ) public virtual override returns (bool) {
        address spender = msg.sender;
        _spendAllowance(from, spender, amount);
        _transfer(from, to, amount);
        return true;
    }

    //Modificar la cantidad de tokens a gastar
    function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
        address owner = msg.sender;
        _approve(owner, spender, _allowences[owner] [spender] + addedValue);
        return true;
    }

    function decreaseAllowance(address spender, uint256 substractedValue) public virtual returns (bool) {
        address owner = msg.sender;
        uint256 currentAllowance =  _allowences [owner] [spender];
        require(currentAllowance >= substractedValue, "ERC20: Decreased allowance below zero");
        //Unchecked sirve para ahorrar gas en comprobaciones internas de Solidity
        unchecked {
            _approve(owner, spender, currentAllowance - substractedValue);
        }
        return true;
    }
    //Funciones internas
    function _transfer(
        address from,
        address to,
        uint256 amount
    ) internal virtual {
        require(from != address(0), "ERC20: Transfer from the zero address");
        require(to != address(0), "ERC20: Transfer to the zero address");
        //Hacer algo antes de la transferencia (Hooks)
        _beforeTokenTransfer(from, to, amount);
        uint256 fromBalance = _balances[from];
        require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
        unchecked {
            //Actualizar el balance del usuario restando lo que tranfiere
            _balances[from] = fromBalance - amount;
        }
        //Incrementar balance del que recibe
        _balances[to] += amount;
        emit Transfer(from, to, amount);

        //Hacer algo despues de la transferencia (Hooks)
        _afterTokenTransfer(from, to, amount);
        
    }

    //Crear tokens y asignar
    function _mint(address account, uint amount) internal virtual {
        require(account != address(0), "ERC20: mint to the zero address");
        _beforeTokenTransfer(address(0), account, amount);
        _totalSupply += amount;
        _balances[account] += amount;
        emit Transfer(address(0), account, amount);
        _afterTokenTransfer(address(0), account, amount);
    }

    //Quemar (destruir tokens)
    function _burn(address account, uint amount) internal virtual{
        require(account != address(0), "ERC20: burn from the zero address");
        //Enviar esos tokens a un lugar donde no puedan ser usados (address (0))
        //Address(0) es una cuenta que nunca sera asignada a nadie 
        _beforeTokenTransfer(account, address(0), amount);
        uint256 accountBalance = _balances[account];
        require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
        unchecked {
            _balances[account] = accountBalance - amount;

        }

        _totalSupply -= amount;
        emit Transfer(account, address(0), amount);
        _afterTokenTransfer(account, address(0), amount);

    }

    function _approve(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        require(owner != address(0), "ERC20: approve from the zero address");
        require(spender != address(0), "ERC20: approve to the zero address");
        _allowences[owner] [spender] = amount;
        emit Approval(owner, spender, amount);
        
    }

    function _spendAllowance(
        address owner,
        address spender,
        uint256 amount
    ) internal virtual {
        uint256 currentAllowance = allowance(owner, spender);
        if(currentAllowance != type(uint256).max) {
            require(currentAllowance >= amount, "ERC20: Insufficiente allowance");
            unchecked {
                _approve(owner, spender,currentAllowance - amount);
            }
        }
          

    }

    //Esta funcion es un hook que puede ser llamado desde un contrato que herede de este
    //no se programa nada aca porque es para que al heredarse se pueda sobreescribir con override y 
    //establecer condiciones antes de que se realice la transferencia 
    function _beforeTokenTransfer(
        address from, 
        address to,
        uint256 amount
    ) internal virtual {}    

    //Lo mismo para cuando se haya realizado la transferencia    
    function _afterTokenTransfer(
        address from, 
        address to,
        uint256 amount
    ) internal virtual {}    

}
