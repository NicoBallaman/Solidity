pragma solidity ^0.4.11;

// st1 = this.getSignature();   así se llama a una funcion externa
// st1 = getSignature();        y así a una interna


contract testModifier {
    address public seller;

    function testModifier (){
        seller = msg.sender;
    }

    function getValueString() returns(string st1){
        st1 = getSignature();
    }

    // se puede omitir el returns para que no devuelva nada
    //internal | external
    function getSignature() internal returns(string x) {
        x = 'Hola mundo. Signed by Nicolás';
    }
}