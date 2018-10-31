pragma solidity ^0.4.0;

contract Test {
    // Esta función se llama para todos los mensajes enviados a
    // este contrato (no hay otra función). 
    // Enviar Ether a este contrato causará una excepción,
    // porque la función fallback no tiene el modificador 
    // "payable".
    function() { x = 1; }
    uint x;
}


// Este contrato mantiene a todo Ether enviado a él sin ninguna manera 
// para recuperarlo.
contract Sink {
    function() payable { }
}

contract Caller {
    function callTest(Test test) {
        test.call(0xabcdef01); // hash does not exist
        // resulta en test.x becoming == 1.

        // Lo siguiente no compilará, pero incluso
        // si alguien envía ether a ese contrato,
        // la transacción fallará y rechazará
        // el ether.
        //test.send(2 ether);
    }
}