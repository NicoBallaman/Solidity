pragma solidity ^0.4.11;

// Valores por defecto:
// parametros de funcion y de retorno: memory
// variables locales: storage

// ver ejemplo en archivo nro 11-ExampleStorageMemory.sol

contract testModifier {
    address public seller;

    function testModifier (){
        seller = msg.sender;
    }

    function getValue() returns(uint storage x) {
        x = 5;
        uint storage y = 4;
        uint memory z = 2;
    }
}