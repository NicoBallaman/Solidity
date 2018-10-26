pragma solidity ^0.4.11;


contract testModifier {
    address public seller;

    enum state {active, inactive, locked, created}      // se crea el enum

    state States;                                       // variable para guardar el estado del contrato

    modifier onlySeller(){
        require(msg.sender == seller);
        _; // resto del a funcion
    }

    function testModifier (){
        States = state.created;                         // se le asigna el estado creado al contrato
        seller = msg.sender;
    }

    function getValue() onlySeller returns(uint x){
        if (States == state.created) {                  // cuando se llama a esta funcion se pregunta por el estado
            x = 5;
        }
        else
        {
            x = 7;
        }
    }
}