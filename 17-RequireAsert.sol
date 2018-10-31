pragma solidity ^0.4.0;

contract Sharer {
    function sendHalf(address addr) payable returns (uint balance) {
        require(msg.value % 2 == 0); 
		// Sólo permite números pares
        uint balanceBeforeTransfer = this.balance;
        addr.transfer(msg.value / 2);
        // Dado que la transferencia genera una excepción en caso de fallo y 
        // no puede volver a llamar aquí, no debería haber manera para nosotros de
        // tener todavía la mitad del dinero.
        assert(this.balance == balanceBeforeTransfer - msg.value / 2);
        return this.balance;
    }
}