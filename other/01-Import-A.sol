pragma solidity ^0.4.11;


import "./01-Import-B.sol";

contract mortal is owned{
    function kill() {
        selfdestruct(owner);
    }
}