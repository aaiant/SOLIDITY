// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

contract Portofel {
    //  Zona de variabile
    struct Wallet {
        address Proprietar;
        string Bancnota;
        uint256 Sold;
        uint256 DataInfiintariiContului;
    }

    mapping(address => Wallet) internal ContPlata;

    //  Zona de eveniment
    event creareCont(address _Proprietar, string _Bancnota, uint256 _DataInfiintareCont);

    //  Zona de functii
    //  Functia care creeaza un Portofel
    function creazaPortofel(string memory _bancnota) public {
        //  Verificam daca bancnota corespunde cu cele adevarate
        require(keccak256(abi.encodePacked(_bancnota)) == keccak256(abi.encodePacked("USD")) ||
        keccak256(abi.encodePacked(_bancnota)) == keccak256(abi.encodePacked("EUR")) ||
        keccak256(abi.encodePacked(_bancnota)) == keccak256(abi.encodePacked("RON")) ||
        keccak256(abi.encodePacked(_bancnota)) == keccak256(abi.encodePacked("GBP")) ||
        keccak256(abi.encodePacked(_bancnota)) == keccak256(abi.encodePacked("CHF")), "Bancnota introdusa nu este de tipul: RON / USD /  GBP / EUR / CHF");
        Wallet memory Wallet_Nou = Wallet({
            Proprietar: msg.sender,
            Bancnota: _bancnota, 
            Sold: 100,
            DataInfiintariiContului: block.timestamp
        });
        //  Daca o persoana a creat un cont, atunci nu mai are cum sa modifice bancnota
        require(bytes(ContPlata[msg.sender].Bancnota).length == 0, "Ati creat deja contul! Daca doriti, puteti sa contactati echipa de suport pentru a va sterge contul! Multumim pentru intelegere!");
        ContPlata[msg.sender] = Wallet_Nou;
        emit creareCont(Wallet_Nou.Proprietar, Wallet_Nou.Bancnota, Wallet_Nou.DataInfiintariiContului);
    }

    //  Functia folosita pentru a verifica datele contului creat
    function dateContPlata(address _proprietar) external view returns (Wallet memory) {
        return ContPlata[_proprietar];
    }
    //  Functia folosita pentru a verifica sold-ul actual
    function Sold(address _proprietar) external view returns (uint256) {
        return ContPlata[_proprietar].Sold;
    }
}