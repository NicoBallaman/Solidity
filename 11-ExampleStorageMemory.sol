pragma solidity ^0.4.0;

contract C {

    uint[] x; // la ubicación de datos de x es storage 

    // la ubicación de los datos es memoryArray es memory por defecto
    function f(uint[] memoryArray) {

        x = memoryArray; // funciona, copia toda la matriz a la variable x en storage 

        var y = x;      // asigna un puntero, la localización de datos de "y" es storage
        y[7];           // devuelve el octavo elemento
        y.length = 2;   // modifica x a través de y 
        delete x;       // fino, borra la matriz, también modifica "y"

        // Lo siguiente no funciona; necesitaría crear una nueva matriz temporal
        // sin nombre en storage, pero el almacenamiento está "estáticamente" asignado:
        // y = memoryArray;

        // Esto tampoco funciona, ya que restablecerá "reset" el puntero, pero no
        // hay ninguna ubicación razonable a la que pueda apuntar.
        // delete y;
        
        g(x); // llama g, entregando una referencia a x 
        h(x); // llama h y crea una copia independiente y temporal en la memoria
    }

    function g(uint[] storage storageArray) internal {

    }
    function h(uint[] memoryArray) {

    }
}