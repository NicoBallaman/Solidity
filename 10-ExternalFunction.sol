pragma solidity ^0.4.11;

contract Oracle {
  struct Request {
    bytes data;
    function(bytes memory) external callback;
  }
  Request[] requests;
  event NewRequest(uint);

  function query(bytes data, function(bytes memory) external callback) {
    requests.push(Request(data, callback));
    NewRequest(requests.length - 1);
  }

  function reply(uint requestID, bytes response) {
    // Aquí se comprueba que la respuesta proviene de una fuente de confianza 
    requests[requestID].callback(response);
  }
}

contract OracleUser {
  Oracle constant oracle = Oracle(0x1234567); // contrato reconocido

  function buySomething() {
    oracle.query("USD", this.oracleResponse);
  }
  
  function oracleResponse(bytes response) {
    require(msg.sender == address(oracle));
    // Usar los datos
  }
}