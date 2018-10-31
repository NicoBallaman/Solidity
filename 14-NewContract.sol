pragma solidity ^0.4.0;

contract D {
    uint x;
    function D(uint a) payable {
        x = a;
    }
}

contract C {
    D d = new D(4); // se ejecutará como parte del constructor de C

    function createD(uint arg) {                            // crea un contrato de tipo D
        D newD = new D(arg);
    }

    function createAndEndowD(uint arg, uint amount) {       // crea y envia un pago al contrato creado
        // Envía ether junto con la creación 
        D newD = (new D).value(amount)(arg);
    }
}