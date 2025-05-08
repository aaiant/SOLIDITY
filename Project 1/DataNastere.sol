// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;
/*
    Se realizeaza o data de nastere avand 3 intregi (uint); exempu: 5,2,2001 (metoda seteazaDataNasterii). Dupa ce a fost creata data nasterii, aceasta poate fi doar modificata (metoda modificaDataNasterii) 
& exista si un buton in Smart Contract pt. a vizualiza in permanenta data nasterii (metoda verificaDataNasterii).
    Un utilizator poate avea mai multe contracte de tip portofel. In cadrul lui, poate seta un anumit tip de bancnota, iar daca nu corespunde, atunci o sa primeasca
o eroare. Dupa ce a fost creat si portofelul, daca persoana care a dat deploy incearca sa mai realizez un portofel in cadrul aceluiasi contract, atunci o sa apara un mesaj
 precum ca, contul poate sa fie doar sters.
    Dupa ce a facut o data de nastere si un portofel, tocmai dupa aceea poate sa-si creeze un cont de utilizator, ca mai departe sa realizeze un McDonald's si sa comande un 
meniu*/
contract Data_Nastere {
    //  Zona de variabile
    struct DataNastere {
        uint8 Zi;
        uint8 Luna;
        uint16 An;
    }

    mapping(address => DataNastere) internal DataNasterii;

    //  Zona de modificatori
    modifier DataNastereCreata() {
        require(verificaDataNasterii(), "Nu ai creat o data de nastere!");
        _;
    }

    //  Zona de functii
    //  Functia care creeaza o data de nastere
    function seteazaDataNasterii(uint8 _zi, uint8 _luna, uint16 _an) public {
        // Verificam daca datele introduse se afla in intervalele corespunzatoare
        require(_an >= 1910 && _an <= 2024, "Anul introdus nu se afla in intervalul 1910-2024.");
        require(_luna >= 1 && _luna <= 12, "Luna introdusa nu se afla in intervalul 1-12.");
        require(_zi >= 1 && _zi <= zileleLunii(_luna, _an), "Ziua nu se afla in intervalul corespunzator lunii si anului.");

        //  Daca datele au fost stocate, persoana nu mai are dreptul sa acceseze inca o data seteazaDataNastere()
        require(DataNasterii[msg.sender].Zi == 0 && DataNasterii[msg.sender].Luna == 0 && DataNasterii[msg.sender].An == 0, "Daca doriti sa va modificati data nasterii, atunci va rugam sa mergeti in sectiunea \"modificaDataNasterii\"!");

        DataNasterii[msg.sender] = DataNastere(_zi, _luna, _an);
    }

    //  Functia care modifica o data de nastere existenta
    function modificaDataNasterii(uint8 _zi, uint8 _luna, uint16 _an) external DataNastereCreata{

        // Verificam daca datele introduse se afla in intervalele corespunzatoare
        require(_an >= 1910 && _an <= 2024, "Anul introdus nu se afla in intervalul 1910-2024.");
        require(_luna >= 1 && _luna <= 12, "Luna introdusa nu se afla in intervalul 1-12.");
        require(_zi >= 1 && _zi <= zileleLunii(_luna, _an), "Ziua nu se afla in intervalul corespunzator lunii si anului.");

        DataNasterii[msg.sender] = DataNastere(_zi, _luna, _an);
    }

    //  Functia care verifica daca a exista o data de nastere
    function verificaDataNasterii() internal view returns (bool) {
        DataNastere memory DataNastere_Curenta = DataNasterii[msg.sender];
        if(DataNastere_Curenta.Zi != 0 && DataNastere_Curenta.Luna != 0 && DataNastere_Curenta.An != 0) 
        {
            return true;
        } else {
            return false;
        }
    }

    function zileleLunii(uint8 _luna, uint16 _an) internal pure returns (uint8) {
        if(_luna == 2) {
            if(_an % 4 == 0 && (_an % 100 != 0 || _an % 400 == 0)) {
                return 29;
            } else {
                return 28;
            }
        } else if(_luna == 4 || _luna == 6 || _luna == 9 || _luna == 11) {
            return 30;
        } else {
            return 31;
        }
    }

    function vizualizareDataNasterii(address _cont) external view returns (DataNastere memory) {
        return DataNasterii[_cont];
    }
}