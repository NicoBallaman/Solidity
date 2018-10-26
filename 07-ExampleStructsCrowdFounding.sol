pragma solidity ^0.4.11;

contract CrowdFunding {
    // Define un nuevo tipo con dos campos.
    struct Funder {
        address addr;
        uint amount;
    }

    struct Campaign {
        address beneficiary;                // benficiario
        uint fundingGoal;                   // monto objetivo
        uint numFunders;                    // cantidad de contribuidores
        uint amount;                        // monto recibido
        mapping (uint => Funder) funders;   // contribuidores
    }

    uint numCampaigns;
    mapping (uint => Campaign) campaigns;

    function newCampaign(address beneficiary, uint goal) returns (uint campaignID) {
        campaignID = numCampaigns++; // campaign ID es la variable de retorno
        // Crea nueva estructura y guarda en almacenamiento. Dejamos de lado el tipo de mapeo..
        campaigns[campaignID] = Campaign(beneficiary, goal, 0, 0);
    }

    function contribute(uint campaignID) payable {
        Campaign storage c = campaigns[campaignID];
        // Crea una nueva estructura de memoria temporal, inicializada con los valores dados 
        // y la copia en el almacenamiento.
        // Observe que también puede usar Funder (msg.sender, msg.value) para inicializar. 
        c.funders[c.numFunders++] = Funder({addr: msg.sender, amount: msg.value});
        c.amount += msg.value;
    }

    function checkGoalReached(uint campaignID) returns (bool reached) {
        Campaign storage c = campaigns[campaignID];
        if (c.amount < c.fundingGoal)
            return false;
        uint amount = c.amount;
        c.amount = 0;
        c.beneficiary.transfer(amount);
        return true;
    }
}
