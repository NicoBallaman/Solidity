pragma solidity ^0.4.11;

contract owned {
    function owned() 
    { 
        owner = msg.sender; 
        
    }
    address owner;
}