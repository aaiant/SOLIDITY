// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

interface DataNasterii {
    // Zona de variabile
    struct DataNastere {
        uint8 Zi;
        uint8 Luna;
        uint16 An;
    }

    // Zona de functii
    function vizualizareDataNasterii(address _cont) external view returns (DataNastere memory);
}

interface Portofel {
    struct Wallet {
        address Proprietar;
        string Bancnota;
        uint256 Sold;
        uint256 DataInfiintariiContului;
    }

    //  Zona de functii
    function dateContPlata(address _proprietar) external view returns (Wallet memory);
    function Sold(address _proprietar) external view returns (uint256);
}

contract Utilizator {
    // Zona de variabile
    DataNasterii internal DataNastereContract;
    Portofel internal PortofelContract;

    struct Cont {
        string NumeDeFamilie;
        string Prenume;
        string AdresaEmail;
        DataNasterii.DataNastere DataNastereUtilizator;
        string Gen;
        Portofel.Wallet Portofel;
    }

    mapping(address => Cont) internal ContActiv;

    // Zona de evenimente
    event creareCont(string NumeFamilie, string Prenume, string AdresaEmail);
    event modificareCont(string NumeFamilie, string Prenume, string AdresaEmail);

    // Zona de modificatori
    //  Modificatorul care verifica daca un utilizator are o data de nastere, inainte sa-si creeze un cont
    modifier InregistrareDataNastere() {
        DataNasterii.DataNastere memory _dataNastereUtilizator = DataNastereContract.vizualizareDataNasterii(msg.sender);
        require(_dataNastereUtilizator.Zi != 0 && _dataNastereUtilizator.Luna != 0 && _dataNastereUtilizator.An != 0, "Nu ati completat data nasterii!...");
        _;
    }

    //  Modificatorul care verifica daca un utilizator are un portofel creat, inainte sa-si creeze un cont
    modifier InregistrarePortofel() {
        Portofel.Wallet memory _portofelulUtilizatorului = PortofelContract.dateContPlata(msg.sender);
        require(bytes(_portofelulUtilizatorului.Bancnota).length == 3, "Nu ati completat bancnota in care doriti sa fie deschis contul portofelului!");
        _;
    }

    // Zona de functii
    constructor(address _DataNastere, address _Portofel) {
        DataNastereContract = DataNasterii(_DataNastere);
        PortofelContract = Portofel(_Portofel);
    }

    // Functia folosita pentru a crea contului utilizatorului
    function creazaCont(string memory _NumeDeFamilie, string memory _Prenume, string memory _AdresaDeEmail, string memory _Gen) public InregistrareDataNastere InregistrarePortofel{
        //  Verificarea campurilor, daca acestea au fost sau nu introduse
        require(bytes(_NumeDeFamilie).length != 0, "Completati numele de familie!");
        require(bytes(_Prenume).length != 0, "Completati prenumele!");
        require(bytes(_AdresaDeEmail).length != 0, "Completati adresa de email!");
        require(bytes(_Gen).length != 0, "Completati genul!");


        DataNasterii.DataNastere memory _dataNastereUtilizator = DataNastereContract.vizualizareDataNasterii(msg.sender);
        Portofel.Wallet memory _portofelulUtilizatorului = PortofelContract.dateContPlata(msg.sender);

        require(bytes(ContActiv[msg.sender].NumeDeFamilie).length == 0, "Numele de familie a fost deja completat!");
        require(bytes(ContActiv[msg.sender].Prenume).length == 0, "Prenumele a fost deja completat!");
        require(bytes(ContActiv[msg.sender].AdresaEmail).length == 0, "Adresa de email a fost deja completata!");
        require(bytes(ContActiv[msg.sender].Gen).length == 0, "Genul a fost deja completat!");

        Cont memory contNou = Cont({
            NumeDeFamilie: _NumeDeFamilie,
            Prenume: _Prenume,
            AdresaEmail: _AdresaDeEmail,
            DataNastereUtilizator: _dataNastereUtilizator,
            Gen: _Gen,
            Portofel: _portofelulUtilizatorului
        });

        ContActiv[msg.sender] = contNou;
        emit creareCont(_NumeDeFamilie, _Prenume, _AdresaDeEmail);
    }

    // Functia folosita pt. vizualizarea datei de nastere a utilizatorului curent
    function vizualizareDataNasterii() external view returns (DataNasterii.DataNastere memory) {
        return DataNastereContract.vizualizareDataNasterii(msg.sender);
    }

    //  Functia folosita pt. vizualizarea datelor portofelului utilizatorului curent
    function dateContPlata() external view returns (Portofel.Wallet memory) {
        return PortofelContract.dateContPlata(msg.sender);
    }

    //  Functia folosita pt. vizualizarea sold-ului din portofelul utilizatorului curent
    function Sold() external view returns (uint256) {
        return PortofelContract.Sold(msg.sender);
    }

    //  Functia folosita pt. vizualizarea datelor contului
    function ContUtilizator(address _cont) external view returns (Cont memory){
        return ContActiv[_cont];
    }

    //  Functia folosita pt. a reverifica datele din celelalte contracte
    function Refresh() external {
        DataNasterii.DataNastere memory _dataNastereUtilizator = DataNastereContract.vizualizareDataNasterii(msg.sender);
        Portofel.Wallet memory _portofelulUtilizatorului = PortofelContract.dateContPlata(msg.sender);

        ContActiv[msg.sender].DataNastereUtilizator = _dataNastereUtilizator;
        ContActiv[msg.sender].Portofel = _portofelulUtilizatorului;
    }
}
