pragma solidity ^0.4.0;

contract Coin {
    address public minter;
    // asocia un address a un uint
    // esta variable no permite obtener una lista de todas las claves de un mapeo (en casos mas complejos utilizar listas)
    mapping (address => uint) public balances;

    // (Llamado al final)
    // La interfaz de usuario puede escuchar los eventos que se disaparan en una cadena de bloques sin mucho costo
    // Hace facil poder realizar un seguimiento de las transacciones
    event Sent (address from, address to, uint amount);
    
    // (Constructor) function Coin()
    // solo se ejecuta cuando se crea el contrato
    function Coin() {
        // msg.sender = direccion de donde proviene la llamada
        minter = msg.sender;
    }

    function mint (address reciver, uint amount) {
        if (msg.sender != minter) return;
        balances[reciver] += amount;
    }

    function send (address reciver, uint amount){
        if (balances[msg.sender] < amount) return;
        balances[msg.sender] -= amount;
        balances[reciver] += amount;
        Sent(msg.sender, reciver, amount);
        // emit Sent(msg.sender, reciver, amount);
    }
}


// desde la interfaz de usuario
/*
Coin.Sent().watch({}, '', function(error, result) {
    if (!error) {
        console.log("Coin transfer: " + result.args.amount +
            " coins were sent from " + result.args.from +
            " to " + result.args.to + ".");
        console.log("Balances now:\n" +
            "Sender: " + Coin.balances.call(result.args.from) +
            "Receiver: " + Coin.balances.call(result.args.to));
    }
})
*/
