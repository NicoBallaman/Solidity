pragma solidity ^0.4.0;
contract DeleteExample {
    uint data;
    uint[] dataArray;

    function f() {
        uint x = data;
        delete x; // establece x en 0, no afecta data
        delete data; // establece a data en 0, no afecta a x que todavía tiene una copia
        uint[] y = dataArray;
        delete dataArray; // esto establece dataArray.length a cero, pero como uint [] es un objeto complejo, también 
        // se afecta a "y" es un alias al objeto de almacenamiento 
        // Por otro lado: "delete y" no es válido, como asignaciones a variables locales 
        // referenciar objetos de almacenamiento sólo puede hacerse a partir de objetos de almacenamiento existentes.
    }
}