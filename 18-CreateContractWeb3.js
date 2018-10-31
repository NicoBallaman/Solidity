// Necesita especificar alguna fuente incluyendo el nombre del contrato para el parámetro de datos debajo
var source = "contract CONTRACT_NAME { function CONTRACT_NAME(uint a, uint b) {} }";

// El json array abi generado por el compilador 
var abiArray = [{
        "inputs": [
            { "name": "x", "type": "uint256" },
            { "name": "y", "type": "uint256" }
        ],
        "type": "constructor"
    },
    {
        "constant": true,
        "inputs": [],
        "name": "x",
        "outputs": [{ "name": "", "type": "bytes32" }],
        "type": "function"
    }
];

var MyContract_ = web3.eth.contract(source);
MyContract = web3.eth.contract(MyContract_.CONTRACT_NAME.info.abiDefinition);
// desplegar nuevo contrato 
var contractInstance = MyContract.new(
    10,
    11, { from: myAccount, gas: 1000000 }
);