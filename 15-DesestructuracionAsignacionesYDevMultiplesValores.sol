pragma solidity ^0.4.0;

contract C {
    uint[] data;

    function f() returns (uint, bool, uint) {
        return (7, true, 2);
    }

    function g() {
        // Declara y asigna las variables. Especificar el tipo explícitamente no es posible.
        var (x, b, y) = f();
        // Asigna a una variable preexistente.
        (x, y) = (2, 7);
        // Truco común para intercambiar valores - no funciona para tipos de almacenamiento sin valor. 
        (x, y) = (y, x);
        // Los componentes se pueden omitir (también para las declaraciones de variables).
        // Si la tupla termina en un componente vacío,
        // el resto de los valores se descartan. 
        (data.length,) = f(); // Establece la longitud a 7 
        // Lo mismo se puede hacer en el lado izquierdo.
        (,data[3]) = f(); // Sets data[3] to 2
        // Los componentes sólo se pueden omitir a la izquierda de las asignaciones, con
        // una excepcion:
        (x,) = (1,);
        // ((1,) es la única manera de especificar una tupla de 1 componente, porque (1) es
        // equivalente a 1.
    }
}