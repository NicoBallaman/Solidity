// Esto no compilará
pragma solidity ^0.4.0;

contract ScopingErrors {
    function scoping() {
        uint i = 0;

        while (i++ < 1) {
            uint same1 = 0;
        }

        while (i++ < 2) {
            uint same1 = 0;
			// Ilegal, segunda declaración del mismo1 
        }
    }

    function minimalScoping() {
        {
            uint same2 = 0;
        }

        {
            uint same2 = 0;
			// Ilegal, segunda declaración del mismo2
        }
    }

    function forLoopScoping() {
        for (uint same3 = 0; same3 < 1; same3++) {
        }

        for (uint same3 = 0; same3 < 1; same3++) {
		// Ilegal, segunda declaración del mismo3
        }
    }
}

// compilará, pero estará mal escrito

function foo() returns (uint) {
    // baz se inicializa implícitamente como 0
    uint bar = 5;
    if (true) {
        bar += baz;
    } else {
        uint baz = 10;
		// nunca se ejecuta
    }
    return bar;// devuelve 5
}