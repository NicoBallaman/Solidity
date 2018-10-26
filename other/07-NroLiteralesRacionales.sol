pragma solidity ^0.4.11;

// Cada numero racional solidity tiene su tipo de numero literal, los siguientes:
// Numeros literales, secuencia de numero en el rango 0-9  (5, 56, 89)
// Numeros literales de fraccion, formados por un . decimal (0.5, .8, 7.4)
// Numeros literales notacion cientifica (-2e10, 2e10, 2.5e1)

contract testModifier {
    address public seller;
    uint amount;
    function testModifier() payable
    {
        amount = msg.value;
        seller = msg.sender;
    }

    function transferValue() returns(uint x){
        // Así no funciona.
        // 2.5 + a no es aprobada por ser de diferentes tipos
        // uint128 a = 1;
        // uint128 b = 2.5 + a + .5;
        
        uint128 a = 1;
        uint128 b = 2.5 + 1 + .5;
        
        x = a + b;
    }
    
}