pragma solidity ^0.4.11;

contract BlindAuction {
    struct Bid {
        bytes32 blindedBid;
        uint deposit;
    }

    address public beneficiary;
    uint public auctionStart;
    uint public biddingEnd;
    uint public revealEnd;
    bool public ended;

    mapping(address => Bid[]) public bids;

    address public highestBidder;
    uint public highestBid;

    // Permitieron los retiros de la asignación de ofertas anteriores
    mapping(address => uint) pendingReturns;

    event AuctionEnded(address winner, uint highestBid);

    /// Los modificadores son una manera conveniente de validar las entradas a las funciones,
    /// `onlyBefore` se aplica a` bid` a continuación:
    /// El nuevo cuerpo de la función es el cuerpo del modificador donde
    /// `_` es reemplazado por el cuerpo de la antigua función.
    modifier onlyBefore(uint _time) { require(now < _time); _; }
    modifier onlyAfter(uint _time) { require(now > _time); _; }


    // (Constructor)
    function BlindAuction(uint _biddingTime, uint _revealTime, address _beneficiary) {
        beneficiary = _beneficiary;
        auctionStart = now;
        biddingEnd = now + _biddingTime;
        revealEnd = biddingEnd + _revealTime;
    }

    /// Coloca una puja ciega con `_blindedBid` = keccak256 (valor, falso, secreto).
    /// El ether enviado sólo se devuelve si la oferta es correcta
    /// revelada en la fase reveladora. La oferta es válida si el
    /// el ether enviado junto con la oferta es al menos "value" y
    /// "fake" si no es cierto. Establecer "fake" a true y enviar
    /// no la cantidad exacta son formas de ocultar la oferta real pero
    /// sigue haciendo el depósito requerido. La misma dirección puede 
    /// realizar varias pujas. 
    function bid(bytes32 _blindedBid) payable onlyBefore(biddingEnd)
    {
        bids[msg.sender].push(Bid({
            blindedBid: _blindedBid,
            deposit: msg.value
        }));
    }
   
    /// Revelar sus ofertas ciegas. Obtendrá un reembolso por todas las 
    /// pujas inválidas correctamente ocultas y para todas las pujas excepto para
    /// la más alta.
    function reveal(uint[] _values, bool[] _fake, bytes32[] _secret) onlyAfter(biddingEnd) onlyBefore(revealEnd) {
        uint length = bids[msg.sender].length;
        require(_values.length == length);
        require(_fake.length == length);
        require(_secret.length == length);

        uint refund;
        for (uint i = 0; i < length; i++) {
            var bid = bids[msg.sender][i];
            var (value, fake, secret) = (_values[i], _fake[i], _secret[i]);
            if (bid.blindedBid != keccak256(value, fake, secret)) {
           
				// La oferta no fue realmente revelada.
                // No devuelve el depósito. 
                continue;
            }
            refund += bid.deposit;
            if (!fake && bid.deposit >= value) {
                if (placeBid(msg.sender, value))
                    refund -= value;
            }
            // Hacer imposible que el remitente reclame
            // el mismo depósito.
            bid.blindedBid = bytes32(0);
        }
        msg.sender.transfer(refund);
    }

    // Esta es una función "interna" significa que
    // sólo se puede llamar desde el propio contrato (o de
    // contratos derivados).
    // Ofertar
    function placeBid(address bidder, uint value) internal returns (bool success)
    {
        if (value <= highestBid) {
            return false;
        }
        if (highestBidder != 0) {
            // reembolsará el postor más alto previamente.
            pendingReturns[highestBidder] += highestBid;
        }
        highestBid = value;
        highestBidder = bidder;
        return true;
    }

    /// Retirar una oferta que fue sobrepasada.
    function withdraw() {
        uint amount = pendingReturns[msg.sender];
        if (amount > 0) {
            // Es importante establecer esto a cero porque el destinatario 
            // puede volver a llamar esta función como parte de la llamada de recepción
            // antes de que `send` termine
            pendingReturns[msg.sender] = 0;

            msg.sender.transfer(amount);
        }
    }

    /// Finalizar la subasta y enviar la oferta más alta
    /// al beneficiario.
    function auctionEnd() onlyAfter(revealEnd) {
        require(!ended);
        AuctionEnded(highestBidder, highestBid);
        ended = true;
       
		// Enviamos todo el dinero que tenemos, porque algunos
        // de los reembolsos pudieron haber fallado.
        beneficiary.transfer(this.balance);
    }
}