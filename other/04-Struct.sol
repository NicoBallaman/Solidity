pragma solidity ^0.4.11;


contract testModifier {
    
    struct seller {
        uint amount;
        address seller;
        string product;
    }
    seller Vendedor;

    modifier onlySeller(){
        require(msg.sender == Vendedor.seller);
        _; // resto del a funcion
    }

    function testModifier (string product) payable {
        Vendedor.amount = msg.value;
        Vendedor.seller = msg.sender;
        Vendedor.product = product;

    }

    function getValue() onlySeller returns(string){ // funcion solo disponible para seller; 
        return Vendedor.product;
    }
}