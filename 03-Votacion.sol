pragma solidity ^0.4.11;
/// @title Votación con delegación.
contract Ballot {
    // Esto declara un nuevo tipo complejo que se utilizará para las variables más adelante.
    // Representará a un solo votante. 
    struct Voter {
        uint weight; // weight se acumula votos por delegación
        bool voted;  // si es true, esa persona ya votó
        address delegate; // persona delegada a
        uint vote;   // índice de la propuesta votada
    }

    // Este es un tipo para una propuesta(Caracteristicas de cada propuesta). 
    struct Proposal {
        bytes32 name;   // nombre abreviado (hasta 32 bytes) 
        uint voteCount; // número de votos acumulados 
    }

    // Creador
    address public chairperson;

    // Esto declara una variable de estado que almacena una estructura `Voter` para cada dirección(address) posible.
    // Cada address con su voter
    mapping(address => Voter) public voters;

    // Una matriz(array) de tamaño dinámico de estructuras de 'Propuesta'.
    Proposal[] public proposals;
	
    // Cree una nueva votacion para elegir uno de `proposalNames` (nombres propuestos).
    function Ballot(bytes32[] proposalNames) {
        chairperson = msg.sender;
        voters[chairperson].weight = 1;
        // Para cada uno de los nombres de propuesta proporcionados, crea un nuevo objeto de propuesta y agrega al final de la matriz(array). 
        for (uint i = 0; i < proposalNames.length; i++) {
            // Se crea un un objeto temporal Propuesta y se anexa al final de las «propuestas».
            proposals.push(
                Proposal({
                name: proposalNames[i],
                voteCount: 0
                })
            );
        }
    }
    
    // Dar al votante el derecho a votar en esta votacion electoral. 
    // Sólo puede ser llamado por `chairperson`.
    function giveRightToVote(address voter) {
        // Si el argumento de `` require` evalúa a false`,termina y revierte todos los cambios del estado y los Ether balances. 
        // Son a menudo una buena idea usar si las funciones se llaman incorrectamente.
        // Pero ten cuidado, este consumirá actualmente todos los gases suministrados (esto está previsto que cambie en el futuro).
        require((msg.sender == chairperson) && !voters[voter].voted && (voters[voter].weight == 0));
        // ej:      autor    !no voto    sin delegaciones
        //          true     !falso      true
        voters[voter].weight = 1;
    }

    /// Delegar su voto al votante `to`.
    function delegate(address to) {
        // asigna la referencia
        // se obtiene el votante de la lista de votantes
        Voter storage sender = voters[msg.sender];
        // no tiene que haber votado
        require(!sender.voted);
        //  La autodelegacion no está permitida.
        require(to != msg.sender);
        // Reenviar la delegación siempre y cuando `to` también se delegue.
        // En general, estos bucles son muy peligrosos, porque si pasan demasiado tiempo, podrían necesitar más gas del que está disponible en un bloque.
        // En este caso, la delegación no se ejecutará, pero en otras situaciones, tales bucles podrían hacer que un contrato se "atasque" completamente.
        while (voters[to].delegate != address(0)) {
            to = voters[to].delegate;

            // Encontramos un bucle en la delegación, no permitido. 
            require(to != msg.sender);
        }

        // Puesto que `sender` es una referencia,
        // modifica el `voters[msg.sender].voted`
        sender.voted = true;
        sender.delegate = to;
        Voter storage delegate = voters[to];
        if (delegate.voted) {
         
		    // Si el delegado ya votó, añadir directamente con el número de votos 
            proposals[delegate.vote].voteCount += sender.weight;
        } else {
            // Si el delegado no votó todavía, agrega su weight.
            delegate.weight += sender.weight;
        }
    }

    /// Da su voto (incluidos los votos delegados) a la propuesta `proposals[proposal].name`.
    function vote(uint proposal) {
        Voter storage sender = voters[msg.sender];
        require(!sender.voted);
        sender.voted = true;
        sender.vote = proposal;
        // Si `proposal` está fuera del rango de la matriz o array, esto lanzará automáticamente y revertirá todos los cambios.
        proposals[proposal].voteCount += sender.weight;
    }

    /// @dev Calcula la propuesta ganadora teniendo en cuenta todos los votos anteriores.
    function winningProposal() constant returns (uint winningProposal) {
        uint winningVoteCount = 0;
        for (uint p = 0; p < proposals.length; p++) {
            if (proposals[p].voteCount > winningVoteCount) {
                winningVoteCount = proposals[p].voteCount;
                winningProposal = p;
            }
        }
    }

    // Llama a la función winningProposal () para obtener el índice
    // del ganador contenido en la matriz de propuestas y luego 
    // devuelve el nombre del ganador
    function winnerName() constant returns (bytes32 winnerName) {
        winnerName = proposals[winningProposal()].name;
    }
}




///////////////////////////////////////////////////////////
/* 
Falencias:
 Se requieren muchas transacciones para asignar los derechos de voto
*/
///////////////////////////////////////////////////////////
