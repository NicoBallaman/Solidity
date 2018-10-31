pragma solidity ^0.4.0;


contract C {
    uint public data;
    function x() {
        data = 3; // acceso interno
        uint val = this.data(); // acceso externo
    }
}



//// otro ej mas complejo

contract Complex {
    struct Data {
        uint a;
        bytes3 b;
        mapping (uint => uint) map;
    }
    mapping (uint => mapping(bool => Data[])) public data;
}