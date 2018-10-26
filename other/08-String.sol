pragma solidity ^0.4.11;


contract testModifier {
    address public seller;

    function testModifier (){
        seller = msg.sender;
    }

    function getValueString() returns(string st1){
        st1 = 'Hola Mundossssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss';
        
    }

    function getValueBytes() returns(bytes32 st2){
        st2 = 'Hola Mundos';
        
    }
}