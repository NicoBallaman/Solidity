pragma solidity ^0.4.0;

contract ArrayContract {
    uint[2**20] m_aLotOfIntegers;

    // Observe que lo siguiente no es un par de matrices dinámicas sino una
    // matriz dinámica de pares (es decir, matrices de tamaño fijo de longitud dos).
    bool[2][] m_pairsOfFlags;


    // newPairs se almacena en la memoria - el valor predeterminado para los argumentos de la función
    function setAllFlagPairs(bool[2][] newPairs) {
        // la asignación a una matriz de almacenamiento reemplaza la matriz completa 
        m_pairsOfFlags = newPairs;
    }

    function setFlagPair(uint index, bool flagA, bool flagB) {
        // el acceso a un índice no existente lanzará una excepción 
        m_pairsOfFlags[index][0] = flagA;
        m_pairsOfFlags[index][1] = flagB;
    }

    function changeFlagArraySize(uint newSize) {
        // si el nuevo tamaño es menor, los elementos de matriz eliminados se borrarán 
        m_pairsOfFlags.length = newSize;
    }

    function clear() {
        // estos borran  los arrays completamente
        delete m_pairsOfFlags;
        delete m_aLotOfIntegers;
        // efecto idéntico aquí 
        m_pairsOfFlags.length = 0;
    }

    bytes m_byteData;

    function byteArrays(bytes data) {
        // matrices de bytes ( "bytes") son diferentes, ya que se almacenan sin relleno,
        // pero se pueden tratar idéntica a "uint8 []" 
        m_byteData = data;
        m_byteData.length += 7;
        m_byteData[3] = 8;
        delete m_byteData[2];
    }

    function addFlag(bool[2] flag) returns (uint) {
        return m_pairsOfFlags.push(flag);
    }

    function createMemoryArray(uint size) returns (bytes) {
        // Los arrays de memoria dinámica se crean usando `new`:
        uint[2][] memory arrayOfPairs = new uint[2][](size);
        // Crear una matriz de bytes dinámicos: 
        bytes memory b = new bytes(200);
        for (uint i = 0; i < b.length; i++)
            b[i] = byte(i);
        return b;
    }
}