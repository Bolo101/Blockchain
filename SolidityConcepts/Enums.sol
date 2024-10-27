//Creation de nouveau type par l'utilisateur
pragma solidity 0.8.7;
contract Enums{
    enum etape{commande,expedition,livraison}//no semicolon ; after an enum
    /**
    With enum we do not get back a string but a uint index
    This way commande is worth 0, expedition 1 and livraison 2
    */
    struct produit{
        uint _SKU; //identifiant
        Enums.etape _etape;//_etape is a enum etape variable contained is the Enums contract
    }
    mapping(address => produit) CommandeClient; //an address can only purchase one product

    function commander(address _client, uint _SKU) public {
        produit memory p = produit(_SKU, etape.commande);
        CommandeClient[_client] = p;
    }
    function expedier(address _client) public {//no SKU as a client may only have one order
        CommandeClient[_client]._etape = etape.expedition; 
    }
    function getSKU(address _client) public view returns(uint){
        return CommandeClient[_client]._SKU;
    }
    function getEtape(address _client) public view returns(etape){
        return CommandeClient[_client]._etape;
    }

}