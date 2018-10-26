pragma solidity ^0.4.0;

// mappning son asignaciones en la cual asocioa un valor a una clave
// Se pueden pensar como hash tables
// mapping(address => uint) public balances;
// tambien se pueden utilizar struct en lugar uint

contract MappingExample {
    mapping(address => uint) public balances;

    function update(uint newBalance) {
        balances[msg.sender] = newBalance;
    }
}

contract MappingUser {
    function f() returns (uint) {
        MappingExample m = new MappingExample();
        m.update(100);
        return m.balances(this);
    }
}