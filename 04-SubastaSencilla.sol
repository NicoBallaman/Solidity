pragma solidity ^0.4.11;

contract SimpleAuction {

    // Parámetros de la subasta. Los tiempos son 
    // absoluto unix timestamps (segundos desde 1970-01-01)
    // o períodos de tiempo en segundos. 
    address public beneficiary;
    uint public auctionStart;
    uint public biddingTime;

    // Estado actual de la subasta.
    address public highestBidder;
    uint public highestBid;

    // Saldo de ofertas superadas que faltan de retirar
    mapping(address => uint) pendingReturns;

    // Se establece en true al final, no permite ningún cambio
    bool ended;

    // Eventos que se dispararán en los cambios.
    event HighestBidIncreased(address bidder, uint amount);
    event AuctionEnded(address winner, uint amount);

    /// Crear una subasta simple con `_biddingTime` segundos de tiempo de licitación
    /// Y el nombre de la dirección beneficiaria` _beneficiary`.
    /// (Constructor)
    function SimpleAuction(uint _biddingTime, address _beneficiary) {
        beneficiary = _beneficiary;
        auctionStart = now;
        biddingTime = _biddingTime;
    }


    /// Oferta en la subasta con el valor enviado junto con esta transacción.
    /// El valor sólo se reembolsará si la subasta no se gana. 
    function bid() payable {
  
		// No hay argumentos necesarios, 
        // toda la información ya forma parte de la transacción.

        // Revertir la llamada si el período de licitación ha terminado.
        require(now <= (auctionStart + biddingTime));

        // Si la oferta no es superior, envíe el dinero de vuelta.
        require(msg.value > highestBid);

        if (highestBidder != 0) {
            // devolver el dinero por el simple uso
            // highestBidder.send(highestBid) es un riesgo de seguridad 
            // ya que podría ejecutar un contrato que no es de confianza.
            // Siempre es más seguro dejar que los beneficiarios 
            // retiren su dinero ellos mismos. 
            pendingReturns[highestBidder] += highestBid;
        }
        highestBidder = msg.sender;
        highestBid = msg.value;
        HighestBidIncreased(msg.sender, msg.value);
    }

    /// Retirar una oferta que fue sobrepasada. 
    function withdraw() returns (bool) {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // Es importante poner esto a cero porque el destinatario 
            // puede volver a llamar a esta función como parte de la llamada de recepción 
            // antes de que `send` devuelva.
            pendingReturns[msg.sender] = 0;

            if (!msg.sender.send(amount)) {
                // Si no se puede enviar el dinero se cancela
                // No hay necesidad de llamar a tirar aquí, sólo restablecer la cantidad adeudada
                pendingReturns[msg.sender] = amount;
                return false;
            }
        }
        return true;
    }

    /// Finalizar la subasta y enviar la oferta más alta al beneficiario.
    function auctionEnd() {
        // Es una buena guía para estructurar funciones que interactúan
        // con otros contratos (es decir, que llaman a funciones o enviar Ether) 
        // en tres fases: 
        // 1. Condiciones de chequeos 
        // 2. realizar acciones ( Potencialmente cambiando las condiciones) 
        // 3. interactuando con otros contratos
        // Si estas fases se mezclan, el otro contrato podría llamar 
        // de nuevo al contrato actual y modificar el estado o causar 
        // efectos (pago de ether) a realizar múltiples veces.
        // Si las funciones llamadas internamente incluyen interacción con
        // contratos, también deben ser considerados como interacción con
        // contratos externos.

        // 1. Condiciones
        require(now >= (auctionStart + biddingTime)); 
		// la subasta no terminó todavía 
        require(!ended); 
		// esta función ya ha sido llamada

        // 2. Efectos
        ended = true;
        AuctionEnded(highestBidder, highestBid);

        // 3. Interaccion
        beneficiary.transfer(highestBid);
    }
}
