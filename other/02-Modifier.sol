pragma solidity ^0.4.11;


contract testModifier {
    address public seller;

    modifier onlySeller(){
        require(msg.sender == seller);
        _; // resto del a funcion
    }

    function testModifier (){
        seller = msg.sender;
    }

    function getValue() onlySeller returns(uint x){ // funcion solo disponible para seller; 
        x = 5;
    }
}