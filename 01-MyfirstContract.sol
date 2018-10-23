pragma solidity ^0.4.0;

contract MyFirstContract {
    uint storeData;

    // asigna valor a la variable
    function set (uint x) {
         storeData = x;
     }
     
    // obtiene valor de la variable
    function get() constant returns (uint){
         return storeData;
     }
     
}