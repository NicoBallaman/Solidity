pragma solidity ^0.4.0;
   contract C {

// cambiando el valor de la variable Array.lenght se le cambia el tamaño al array
// siempre y cuando sean array con longtud variable, utilizando la palabra clave "new"
// Si el nuevo tamaño es menor, los elementos de matriz eliminados se borrarán 
// m_pairsOfFlags.length = newSize;

    function f(uint len) {
        uint[] memory a = new uint[](7);
        bytes memory b = new bytes(len);
        // Aquí tenemos a .length == 7 y b.length == len
        a[6] = 8;
    }
}

// Array literales
// son arrays que se escriben como una expresion y no se asignan a una variable de inmediato
// [uint(1), 2, 3] 2 y 3 son los valores y 1 el tamaño
pragma solidity ^0.4.0;

contract C {
    function f() {
        g([uint(1), 2, 3]);
    }
    function g(uint[3] _data) {
 
    }
}


// Esto no compilará.
// no se puede asignar una array de tamaño fijo a un array de tamaño dinamico
pragma solidity ^0.4.0;

contract C {
    function f() {
        // La siguiente línea crea un error de tipo porque uint [3] memory 
        // no se puede convertir en uint [] memory. 
        uint[] x = [uint(1), 3, 4];
    }
}

// Eliminar un array completamente
    // delete m_aLotOfIntegers;
// Tambien se puede hacer
    // m_aLotOfIntegers.length = 0;