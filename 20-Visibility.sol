// Esto no compilará
pragma solidity ^0.4.0;

contract C {
    uint private data;

    function f(uint a) private returns(uint b) { return a + 1; }
    function setData(uint a) { data = a; }
    function getData() public returns(uint) { return data; }
    function compute(uint a, uint b) internal returns (uint) { return a+b; }
}


contract D {
    function readData() {
        C c = new C();
        uint local = c.f(7); // error: el miembro "f" no es visible
        c.setData(3);
        local = c.getData();
        local = c.compute(3, 5); // error: el miembro "compute" no es visible
    }
}


contract E is C {   // <----------------------------------------- Contrato E es derivado del contrato C, por eso permite los siguiente
    function g() {
        C c = new C();
        uint val = compute(3, 5);  // acceso al miembro interno (del contrato derivado al contrato principal) 
    }
}