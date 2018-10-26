pragma solidity ^0.4.11;


// Send es la contraparte de bajo nivel de transfer. si la ejecucion falla, el contrato actual no se detendrá con una excepcion,
// pero con send retornará false.


contract testModifier {
    address public seller;
    uint amount;

    modifier onlySeller(){
        require(msg.sender == seller);
        _; // resto del a funcion
    }

    function testModifier() payable
    {
        amount = msg.value;
        seller = msg.sender;
    }

    function transferValue() onlySeller returns(uint x){
        amount -= 1;
        seller.transfer(1);
        x = amount;
    }

    function sendValue() onlySeller returns(uint y){
        amount -= 1;
        seller.send(1);
        y = amount;
    }
}