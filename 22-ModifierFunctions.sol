pragma solidity ^0.4.11;

 // Este contrato sólo define un modificador (onlyOwner) pero no lo usa se utilizará en contratos derivados.
contract owned {
    function owned() { owner = msg.sender; }
    address owner;

    // Se inserta el cuerpo de la función donde está el símbolo especial
    // en la definición de un modificador aparece "_;" .
    // Esto significa que si el propietario llama a esta función, 
    // se ejecuta la función y, de lo contrario, se produce 
    // una excepción.
    modifier onlyOwner {
        require(msg.sender == owner);
        _;
    }
}
contract mortal is owned {
    // Este contrato hereda el modificador "onlyOwner" de
    // "owned" y lo aplica a la función "close",que
    // hace que las llamadas a "close" solo tengan un efecto si 
    // son realizadas por el propietario almacenado. 
    function close() onlyOwner {
        selfdestruct(owner);
    }
}

// Este contrato sólo define un modificador (costs) que recibe un argumento
contract priced {
    // Los modificadores pueden recibir argumentos:
    modifier costs(uint price) {
        if (msg.value >= price) {
            _;
        }
    }
}


contract Register is priced, owned {
    mapping (address => bool) registeredAddresses;
    uint price;

    function Register(uint initialPrice) { price = initialPrice; }
    // Es importante también proporcionar la
    // palabra clave "payable" aquí, de lo contrario la función
    // rechazará automáticamente todo el ether que se le envíe. 
    function register() payable costs(price) {
        registeredAddresses[msg.sender] = true;
    }

    function changePrice(uint _price) onlyOwner {
        price = _price;
    }
}

contract Mutex {
    bool locked;
    modifier noReentrancy() {
        require(!locked);
        locked = true;
        _;
        locked = false;
    }

    /// Esta función está protegida por un mutex, lo que significa que 
    /// llamadas reentrantes desde dentro de msg.sender.call no se puede llamar a f de nuevo.
    /// La sentencia `return 7` asigna 7 al valor devuelto pero todavía
    /// ejecuta la instrucción` locked = false` en el modificador.
    function f() noReentrancy returns (uint) {
        require(msg.sender.call());
        return 7;
    }
}