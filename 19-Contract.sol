pragma solidity ^0.4.0; 
contract OwnedToken {
    // TokenCreator es un tipo de contrato que se define a continuación. 
    // Está bien hacer referencia siempre y cuando no se use 
    // para crear un nuevo contrato.
    TokenCreator creator;
    address owner;
    bytes32 name;

    // Este es el constructor que registra el 
    // creador y el nombre asignado.
    function OwnedToken(bytes32 _name) {
        // Se accede a las variables de estado a través de su nombre 
        // y no a través de, por ejemplo, this.owner. Esto también se aplica 
        // a las funciones y especialmente en los constructores, 
        // sólo se puede llamar así ("internamente"), porque el contrato en sí no existe todavía.    <--------------------------------
        owner = msg.sender;
        // Hacemos una conversión de tipo explícita de `address` 
        // a `TokenCreator` y asumimos que el tipo de 
        // el contrato que llama es TokenCreator,
        // no hay manera real de comprobar eso.
        creator = TokenCreator(msg.sender);
        name = _name;
    }

    function changeName(bytes32 newName) {
        // Sólo el creador puede alterar el nombre --
        // la comparación es posible ya que los contratos 
        // son implícitamente convertibles en direcciones.
        if (msg.sender == address(creator))
            name = newName;
    }

    function transfer(address newOwner) {
        // Sólo el propietario actual puede transferir el token.
        if (msg.sender != owner) return;
        // También queremos preguntar al creador si la transferencia 
        // está bien. Tenga en cuenta que esto llama una función del 
        // contrato definido a continuación. Si la llamada falla (por ejemplo,
        // debido a la falta de gas), la ejecución aquí se detiene
        // inmediatamente. 
        if (creator.isTokenTransferOK(owner, newOwner))
            owner = newOwner;
    }
}
contract TokenCreator {
    function createToken(bytes32 name) returns (OwnedToken tokenAddress) {
        // Crea un nuevo contrato Token y devuelve su dirección. 
        // Del lado de JavaScript, el tipo de retorno es simplemente 
        // "address", ya que éste es el tipo más cercano disponible en
        // el ABI.
        return new OwnedToken(name);
    }

    function changeName(OwnedToken tokenAddress, bytes32 name) {
        // De nuevo, el tipo externo de "tokenAddress" es
        // simplemente "address".
        tokenAddress.changeName(name);
    }

    function isTokenTransferOK(address currentOwner, address newOwner) returns (bool ok) {
        // Check some arbitrary condition.
        address tokenAddress = msg.sender;
        return (keccak256(newOwner) & 0xff) == (bytes20(tokenAddress) & 0xff);
    }
}