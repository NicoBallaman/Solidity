pragma solidity ^0.4.0;

// Algunas conversiones inplicitas
// uint8 ==> uint16
// int128 ==> int256
// int8 !!> uint256 (no es posible porque uint no soporta valores -)
// uint160 ==> address

// Conversiones explicitas, posible comportamiento inesperado si no se sabe lo que se esta haciendo
int8 y = -3;
uint x = uint(y);
// x tendra el valor 0xfffff..fd(64 caracteres exadecimales), que representan el -3

