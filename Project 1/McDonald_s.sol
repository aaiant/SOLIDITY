// SPDX-License-Identifier: MIT
pragma solidity ^0.8.25;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";

interface Portofel {
    struct Wallet {
        address Proprietar;
        string Bancnota;
        uint256 Sold;
        uint256 DataInfiintariiContului;
    }
}

interface DataNasterii {
    // Zona de variabile
    struct DataNastere {
        uint8 Zi;
        uint8 Luna;
        uint16 An;
    }
}

interface ContUtilizat {
    struct Cont {
        string NumeDeFamilie;
        string Prenume;
        string AdresaEmail;
        DataNasterii.DataNastere DataNastereUtilizator;
        string Gen;
        Portofel.Wallet Portofel;
    }
    function ContUtilizator(address _cont) external view returns (Cont memory);
}


contract McDonald_s is Ownable{
    //  Zona de variabile
    ContUtilizat internal ContFolosit;

    //  Structura folosita pt. a tine evidenta tuturor produselor dintr-o categorie
    struct Subcategorie {
        string Denumire;
        string Descriere;
        uint256 Cal;
        uint256 Pret;
    }
    
    //  Proprietarul McDonald's-ului
    struct Proprietar {
        address Persoana;
        uint256 DataInfiintare;
    }

    struct MeniuComplet {
        Subcategorie[] Burgers;
        Subcategorie[] Breakfast;
    }
    
    // Realizarea mapării
    mapping(address => mapping(string => Subcategorie[])) internal Meniu;
    mapping(address => Proprietar) internal CEO;

    //  Zona de modificatori
    //  Modificatorul care verifica daca un utilizator a fost inregistrat
    modifier InregistrareCont(address _contActiv) {
        ContUtilizat.Cont memory _cont = ContFolosit.ContUtilizator(_contActiv);
        require(bytes(_cont.NumeDeFamilie).length != 0 && bytes(_cont.Prenume).length != 0 && bytes(_cont.AdresaEmail).length != 0
        && bytes(_cont.Gen).length != 0 && (_cont.DataNastereUtilizator.Zi != 0 && _cont.DataNastereUtilizator.Luna != 0 && _cont.DataNastereUtilizator.An != 0) 
        && (bytes(_cont.Portofel.Bancnota).length == 3 && _cont.Portofel.DataInfiintariiContului > 0), "Contul nu a fost inregistrat!");
        _;
    }

    // Constructor care adaugă datele inițiale în mapare
    constructor(address _cont) Ownable(msg.sender){
        //  Realizarea conexiunilor
        ContFolosit = ContUtilizat(_cont);
        
        /*  
        * Adaugarea meniurilor & submeniurilor pt. McDondald's-ul proprietarului
        * Adica pt. persoana care a emis contractul */

        //  Meniul principal -> Burgeri
        Meniu[owner()]["Burgeri"].push(
        Subcategorie("BIG MAC", "Te-ai intrebat vreodata ce este pe un Big Mac? McDonald's Big Mac este un burger de vita 100%, cu un gust ca nimeni altul. Perfectiunea delicioasa incepe cu doua chiftele de vita 100% pure si sos Big Mac sandwich intre o chifla cu seminte de susan. Este completat cu muraturi, salata verde crocanta, ceapa tocata marunt si o felie de branza americana. Nu contine arome artificiale, conservanti sau coloranti adaugati din surse artificiale. Muratura noastra contine un conservant artificial, asa ca sariti-l daca doriti.", 590, 37));
        Meniu[owner()]["Burgeri"].push(
            Subcategorie("QUARTER POUNDER WITH CHEESE", "Fiecare burger Quarter Pounder with Cheese are o jumatate de 1/4 lb. * de carne de vita 100% proaspata, fierbinte, delicioasa suculenta si gatita atunci cand comandati. Ce vine pe un sfert Pounder? Fiecare burger proaspat de vita este condimentat cu doar un varf de sare si piper, sfarait pe un gratar plat de fier, apoi acoperit cu ceapa taiata, muraturi picante si doua felii de branza americana topita pe o chifla de seminte de susan. QPC-ul nostru nu contine arome artificiale, conservanti sau coloranti adaugati din surse artificiale.^ Muraturile noastre contin un conservant artificial, asa ca sariti-l daca doriti. Un sfert de pounder cu branza are 520 de calorii.", 520, 14));
        Meniu[owner()]["Burgeri"].push(
            Subcategorie("DOUBLE QUARTER POUNDER WITH CHEESE", "Fiecare Double Quarter Pounder cu branza are doua sferturi de kilogram* Chiftele de burger de vita 100% proaspete, care sunt fierbinti, delicioase suculente si gatite atunci cand comandati. Chiftelele de vita McDonald's sunt condimentate doar cu un varf de sare si piper, sfaraite pe un gratar plat de fier, apoi acoperite cu ceapa taiata, muraturi picante si doua felii de branza topita pe o chifla de seminte de susan. Nu contine arome artificiale, conservanti sau coloranti adaugati din surse artificiale.** Muraturile noastre contin un conservant artificial, asa ca sariti-l daca doriti.", 740, 36));
        Meniu[owner()]["Burgeri"].push(
            Subcategorie("QUARTER POUNDER WITH CHEESE DELUXE", "McDonald's Quarter Pounder cu branza Deluxe este o abordare proaspata a unui burger clasic Quarter Pounder. Salata verde maruntita crocanta si trei felii de rosii rome acopera 1/4 lb. * de carne de vita proaspata McDonald's 100%, fierbinte, delicioasa si gatita atunci cand comandati. Asezonat doar cu un varf de cutit de sare si piper si sfarait pe gratarul nostru plat de fier. Stratificat cu doua felii de branza americana topita, maioneza cremoasa, ceapa taiata si muraturi picante pe o chifla moale si pufoasa de hamburger cu seminte de susan. Exista 630 de calorii intr-un sfert de pounder cu branza Deluxe. Luati-va QPC Deluxe prin drive thru sau cu preluarea de la bordura McDonald's atunci cand comandati si platiti mobil! Este necesara descarcarea si inregistrarea aplicatiei McDonald's.", 630, 36));
        Meniu[owner()]["Burgeri"].push(
            Subcategorie("MCDOUBLE", "Burgerul clasic McDouble stivuieste doua chiftele de vita 100% pure, condimentate cu doar un varf de sare si piper. Va intrebati care este diferenta dintre un McDouble si un Double Cheeseburger? O felie de branza! Ce vine pe un McDouble? Ei bine, este acoperit cu muraturi picante, ceapa tocata, ketchup, mustar si o felie topita de branza americana. Exista 400 de calorii intr-un McDouble. McDouble nu contine arome artificiale, conservanti sau coloranti adaugati din surse artificiale.* Muraturile noastre contin un conservant artificial, asa ca sariti-l daca doriti.", 400, 22));
        Meniu[owner()]["Burgeri"].push(
            Subcategorie("QUARTER POUNDER WITH CHEESE BACON", "Fiecare burger Quarter Pounder with Cheese Bacon contine slanina afumata din lemn de mar taiata gros deasupra unei 1/4 lb. * de carne de vita proaspata 100% McDonald's, gatita atunci cand comandati. Este un cheeseburger fierbinte, delicios de suculent, condimentat cu doar un varf de sare si piper si sfarait pe gratarul nostru plat de fier. Stratificat cu doua felii de branza americana topita, ceapa taiata si muraturi picante pe o chifla moale si pufoasa de hamburger cu seminte de susan. Exista 630 de calorii intr-un sfert de bacon Pounder cu branza. Ridicati-va Bacon QPC in drive thru sau cu ridicarea de la bordura McDonald's atunci cand comandati si platiti mobil! Este necesara descarcarea si inregistrarea aplicatiei McDonald's.", 0, 25));
        Meniu[owner()]["Burgeri"].push(
            Subcategorie("CHEESEBURGER", "Bucurati-va de deliciile branzoase ale unui cheeseburger McDonald's! Cheeseburgerul nostru simplu, clasic incepe cu o chifteluta de burger de vita 100% pura, asezonata cu doar un varf de sare si piper. McDonald's Cheeseburger este acoperit cu o muratura picanta, ceapa tocata, ketchup, mustar si o felie de branza americana topita. Nu contine arome artificiale, conservanti sau coloranti adaugati din surse artificiale.* Muraturile noastre contin un conservant artificial, asa ca sariti-l daca doriti. Pentru mai multe variante delicioase de burgeri, explorati meniul de burgeri McDonald's.", 300, 19));
        Meniu[owner()]["Burgeri"].push(
            Subcategorie("DOUBLE CHEESEBURGER", "McDonald's Double Cheeseburger contine doua chiftele de vita 100% pure, condimentate cu doar un varf de sare si piper. Este acoperit cu muraturi picante, ceapa tocata, ketchup, mustar si doua felii de branza americana topita. Va intrebati care este diferenta dintre McDouble si Double Cheeseburger? Este felia suplimentara de branza americana din Double Cheeseburger.", 450, 18));
        Meniu[owner()]["Burgeri"].push(
            Subcategorie("HAMBURGER", "Hamburgerul clasic McDonald's incepe cu o chifteluta de vita 100% pura, asezonata cu doar un varf de sare si piper. Apoi, burgerul McDonald's este acoperit cu o muratura picanta, ceapa tocata, ketchup si mustar. Care este diferenta dintre un hamburger si un cheeseburger, va intrebati? O felie de branza in acesta din urma! Exista 250 de calorii intr-un hamburger McDonald's. Nu contine arome artificiale, conservanti sau coloranti adaugati din surse artificiale.* Muraturile noastre contin un conservant artificial, asa ca sariti-l daca doriti.", 250, 2));
        
        //  Meniu principal -> Breakfast
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("BACON, Egg & Cheese Biscuit", "Sandvisul de mic dejun McDonald's Bacon, Egg & Cheese Biscuit contine un biscuit cald, cu lapte batut, uns cu unt adevarat, slanina afumata Applewood taiata gros, un ou pufos impaturit si o felie de branza americana topita. Exista 460 de calorii intr-un biscuit cu sunca, oua si branza la McDonald's. Incercati unul astazi cu o cafea prajita premium si comandati cu Mobile Order & Pay in aplicatia McDonald's!", 460, 36));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("EGG MCMUFFIN", "Satisfaceti-va pofta de mic dejun McDonald's cu sandvisul nostru pentru micul dejun Egg McMuffin - este o sursa excelenta de proteine si atat de delicioasa. Reteta McDonald's Egg McMuffin contine un ou proaspat crapat de gradul A asezat pe o briosa englezeasca prajita, acoperita cu unt adevarat, slanina canadiana slaba si branza americana topita. Exista 310 calorii intr-o briosa cu ou de la McDonald's.", 360, 43));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("SAUSAGE MCMUFFIN", "Reteta McDonald's Sawheel McMuffin contine o briosa englezeasca calda, proaspat prajita, acoperita cu o chifteluta savuroasa de carnati fierbinti si o felie de branza americana topita. Exista 400 de calorii intr-o briosa cu carnati la McDonald's. Incercati acest sandvis de mic dejun McDonald's astazi cu o cafea prajita premium si comandati cu Mobile Order & Pay in aplicatia McDonald's!", 400, 9));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("SAUSAGE MCMUFFIN WITH EDGG", "Incepeti-va ziua cu un McDonald's Sausage McMuffin cu sandwich de mic dejun cu oua. Reteta noastra de briose cu oua de carnati contine un carnat fierbinte savuros, o felie de branza americana topita si un ou delicios, proaspat crapat, toate pe o briosa englezeasca proaspat prajita. Exista 480 de calorii in carnati McMuffin cu ou la McDonald's.mandati cu Mobile Order & Pay in aplicatia McDonald's!", 480, 35));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("SAUSAGE BISCUIT", "McDonald's Sausage Biscuit este sandvisul perfect pentru micul dejun cu carnati pentru a va incepe ziua! Reteta noastra de biscuiti cu carnati este facuta cu carnati fierbinti sfaraind pe un biscuit cald cu lapte batut, acoperit cu unt adevarat si copt la perfectiune. Asociaza-l cu o mica cafea prajita McCafe Premium pentru a-ti completa masa!", 460, 1));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("SAUSAGE BISCUIT WITH EGG", "Sandvisul McDonald's Sausage and Egg Biscuit contine un biscuit cald, fulgi, uns cu unt adevarat, o chifteluta fierbinte de carnati de porc si un ou clasic impaturit McDonald's. Este sandvisul perfect pentru micul dejun cu biscuiti atunci cand cautati un mic dejun rapid si usor.", 530, 32));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("BACON, EGG & CHEESE MCGRIDDLES", "Reteta McDonald's Bacon, Egg &Cheese McGriddles contine bacon afumat Applewood taiat gros, un ou pufos impaturit si o felie de branza americana topita, toate pe prajituri moi si calde, cu gust dulce de artar. Este sandvisul perfect pentru micul dejun McGriddles! Prajiturile McGriddles nu au conservanti sau arome artificiale si nici culori din surse artificiale.", 430, 36));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("SAUSAGE MCGRIDDLES", "McDonald's Sausage McGriddles este sandvisul perfect pentru micul dejun cu carnati pentru a incepe ziua! Reteta noastra de carnati McGriddles contine prajituri moi si calde - cu gust de artar dulce - care contin carnatii nostri fierbinti savurosi si sfaraitori. Prajiturile McGriddles nu au conservanti sau arome artificiale si nici culori din surse artificiale.", 430, 17));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("SAUSAGE, EGG & CHEESE MCGRIDDLES", "Sausage, Egg & Cheese McGriddles prezinta prajituri moi, calde - cu gustul dulce al artarului - care contin un ou pliat pufos, carnati sarati si branza americana topita. Prajiturile McGriddles nu au conservanti sau arome artificiale si nici culori din surse artificiale. Exista 550 de calorii intr-un carnati, ou si branza McGriddles. Ridicati-va in conditiile dvs. prin drive thru sau cu preluarea de la bordura McDonald's atunci cand comandati si platiti mobil!*", 550, 17));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("BIG BREAKFAST", "Micul dejun nostru mare plin si satisfacator este perfect pentru orice dimineata. Te-ai intrebat vreodata ce este intr-un McDonald's Big Breakfast? Treziti-va pentru o masa de mic dejun cu un biscuit cald, oua amestecate pufoase, carnati sarati McDonald's si Hash Browns auriu crocant. Exista 760 de calorii in Big Breakfast la McDonald's.", 700, 40));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("BIG BREAKFAST WITH HOTCAKES", "McDonald's Big Breakfast with Hotcakes satisface atat micul dejun dulce, cat si cel sarat. Umpleti cu un biscuit cald, carnati fierbinti sarate, oua amestecate pufoase, maro hash crocant si prajituri calde maro auriu cu o parte de unt adevarat si aroma dulce de artar. Exista 1.340 de calorii in McDonald's Big Breakfast with Hotcakes. Nu vrei sa astepti la coada? Comandati micul dejun cu clatite din meniul nostru complet din aplicatie, folosind comanda mobila contactless si plata * pentru ridicare sau McDelivery!", 1340, 47));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("HOTCAKES", "Daca va plac clatitele calde, trebuie sa incercati McDonald's Hotcakes cu o garnitura de unt adevarat si sirop Hotcake cu aroma dulce de artar. Acest mic dejun McDonald's include 3 prajituri calde maro auriu. Exista 580 de calorii in McDonald's Hotcakes. Comandati-le cu o cafea prajita premium pentru combinatia perfecta pentru micul dejun.", 580, 25));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("HOTCAKES AND SAUSAGE", "Cand aveti pofta de clatite si carnati, McDonald's va ofera micul dejun cu prajituri calde si carnati. Contine 3 prajituri calde maro auriu si unt adevarat, acoperit cu sirop de hotcake cu aroma de artar dulce. Pe lateral, veti obtine o chifteluta fierbinte de carnati McDonald's. Exista 770 de calorii intr-un mic dejun cu prajituri calde si carnati. Combina-l cu o cafea prajita premium pentru o combinatie perfecta de clatite si carnati pentru micul dejun.", 770, 43));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("SAUSAGE BURRITO", "Incepeti-va ziua libera cu un Burrito cu oua si carnati incarcat din meniul de mic dejun McDonald's Reteta McDonald's Breakfast Burrito este incarcata cu omleta pufoasa, carnati de porc, branza topita, ardei iute verde si ceapa! Este invelit intr-o tortilla moale, ceea ce il face perfect pentru micul dejun. Exista 310 calorii intr-un burrito de mic dejun cu carnati McDonald's. Bucurati-va de ea ca gustare sau luati o masa Burrito cu carnati cu un Hash Browns auriu crocant si o mica cafea prajita McCafe Premium.", 310, 38));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("HASH BROWNS", "Hash Brown-urile noastre sunt delicioase si perfect crocante. Aceasta reteta crocanta Hash Brown contine chiftele maro hash de cartofi maruntite, care sunt pregatite astfel incat sa fie pufoase in interior si crocante si prajite la exterior. Exista 140 de calorii in McDonald's Hash Browns. Asociati Hash Browns cu elementele preferate din meniul de mic dejun McDonald's.", 140, 8));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("FRUIT & MAPLE OATMEAL", "Reteta McDonald's Fruit and Maple Oatmeal contine doua portii complete de ovaz integral, cu o nota de smantana si zahar brun. Incarcati cu mere rosii si verzi, afine si doua soiuri de stafide, fulgii nostri de ovaz sunt un mic dejun consistent si sanatos cu cereale integrale si fructe. Exista 320 de calorii intr-un fulgi de ovaz cu fructe si artar de la McDonald's. Bucurati-va de acest fulgi de ovaz integral la micul dejun cu o cafea prajita McCafe Premium pentru a va incepe ziua sanatos. Comandati un fulgi de ovaz cu fructe si artar cu Mobile Order & Pay * sau livrati-l cu McDelivery! De asemenea, puteti comanda unul din meniul nostru complet din aplicatie cu preluare Curbside.", 320, 47));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("EGG MCMUFFIN MEAL", "Ia mai mult pentru micul dejun cu McDonald's Egg McMuffin Meal. Aceasta masa de mic dejun McDonald's include o briosa McMuffin cu ou, McDonald's Hash Browns crocant si o mica cafea prajita McCafe Premium - tot ce aveti nevoie pentru a incepe ziua libera! Exista 455 de calorii intr-o masa de oua McMuffin la McDonald's cu o cafea mica si Hash Browns. Obtineti astazi aceasta masa de mic dejun McDonald's Egg McMuffin din meniul nostru complet din aplicatie, folosind contactless Mobile Order & Pay* pentru ridicare sau McDelivery!", 455, 8));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("SAUSAGE MCMUFFIN WITH EGG MEAL", "Treziti-va cu o briosa cu carnati cu oua la micul dejun, servita cu maro hash auriu crocant si o mica cafea prajita premium. Exista 625 de calorii intr-o briosa cu carnati cu faina de oua la McDonald's. Comandati-l astazi din meniul nostru complet din aplicatie folosind contactless Mobile Order & Pay* pentru ridicare sau McDelivery!", 625, 2));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("SAUSAGE BISCUIT WITH EGG MEAL", "McDonald's Sausage Biscuit with Egg Meal include un sandvis cu biscuiti fulgi cu ou impaturit McDonald's si o chifteluta cu carnati de porc. Exista 670 de calorii intr-un biscuit cu carnati cu faina de oua cu maro hash McDonald's crocant si o mica cafea prajita McCafe Premium la McDonald's. Incepeti-va ziua cu aceasta masa de mic dejun McDonald's si satisfaceti-va foamea de dimineata! Obtineti unul astazi cu Mobile Order & Pay sau livrati-l cu McDelivery!", 675, 6));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("BACON, EGG & CHEESE BISCUIT MEAL", "Masa delicioasa de biscuiti cu oua si branza Bacon, modul maro-auriu de a va incepe ziua, servita cu hash browns McDonald's si o mica cafea prajita McCafe Premium. Aceasta masa de mic dejun McDonald's este disponibila in meniul combinat McDonald's. Exista 600 de calorii intr-o masa de biscuiti cu sunca, oua si branza la McDonald's, cu o mica cafea prajita McCafe Premium si Hash Browns. Obtineti unul livrat folosind McDelivery sau comandati ridicarea la bord folosind Mobile Order & Pay!", 605, 25));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("BACON, EGG & CHEESE MCGRIDDLES MEAL", "Masa McGriddles cu bacon, ou si branza are gustul dulce al clatitelor si siropului si gustul de slanina sarata, taiata gros, oua pufoase pliate si branza perfect topita. Aceasta masa de mic dejun McDonald's include clasicul McGriddles cu sunca, ou si branza si este servita cu maro hash auriu, crocant si cafea mica McCafe Premium Roast proaspat preparata. Exista 570 de calorii intr-o masa McGriddles cu sunca, ou si branza la McDonald's cu cafea mica si hash browns. Ia-l astazi cu McDelivery sau comanda-l pentru ridicare la bord cu Mobile Order & Pay!", 575, 1));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("SAUSAGE, EGG & CHEESE MCGRIDDLES MEAL", "Dulcele intalneste saratul cu gustul carnatilor, oualor si branzei McGriddles. Acest favorit pentru micul dejun este facut cu o chifteluta fierbinte de carnati, branza americana pasteurizata si oua pufoase pliate intre doua prajituri cu tava. Aceasta masa de mic dejun McDonald's este completata cu un sandvis de mic dejun McDonald's McGriddles, maro hash auriu crocant si o mica cafea prajita McCafe Premium. Exista 690 de calorii intr-o masa McGriddles cu carnati, oua si branza la McDonald's, cu o mica cafea McCafe Premium Roast si Hash Browns. Obtineti unul astazi folosind Mobile Order & Pay pentru ridicarea la bord sau livrati-l folosind McDelivery!", 695, 42));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("SAUSAGE MCGRIDDLES MEAL", "Masa noastra McDonald's Sausage McGriddles include prajituri moi, calde, cu o nota de dulceata si carnati sarati, cu Hash Browns aurii crocante si o mica cafea prajita McCafe Premium. Exista 575 de calorii intr-o masa McGriddles cu carnati McGriddles sandwich mic dejun, cafea mica si hash browns.", 575, 14));
        Meniu[owner()]["Breakfast"].push(
            Subcategorie("SAUSAGE BURRITO MEAL", "Adaugati niste condimente in dimineata dvs. cu McDonald's Sausage Burrito Combo Meal. Aceasta masa combinata burrito pentru micul dejun include doua burritos cu carnati pe tortilla calde din faina, plus Hash Browns aurii crocante si o mica cafea McCafe. Exista 765 de calorii intr-o masa combinata Burrito cu carnati la McDonald's cu 2 burritos de carnati, o cafea mica si Hash Browns.", 455, 25));

        //  Formarea CEO-ului
        Proprietar memory _proprietar = Proprietar({
            Persoana: owner(),
            DataInfiintare: block.timestamp
        });
        CEO[owner()] = _proprietar;

    }
    
    //  Functia care afiseaza datele firmei
    function Date_Firma() external view returns (Proprietar memory) {
        return CEO[owner()];
    }

    //  Functia care afiseaza meniurile McDonald's-ului (proprietarului)
    function Meniuri() external view returns (MeniuComplet memory) {
        MeniuComplet memory _meniu = MeniuComplet({
            Burgers:  Meniu[owner()]["Burgeri"],
            Breakfast: Meniu[owner()]["Breakfast"]
        });
        return _meniu;
    }

    //  Functia care verifica ca numele meniului introdus exista si cod
    function verificareMeniu(string memory _produsVerificare) internal pure returns (bool) {
        return keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("BIG MAC")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("QUARTER POUNDER WITH CHEESE")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("DOUBLE QUARTER POUNDER WITH CHEESE")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("QUARTER POUNDER WITH CHEESE DELUXE")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("MCDOUBLE")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("QUARTER POUNDER WITH CHEESE BACON")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("CHEESEBURGER")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("DOUBLE CHEESEBURGER")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("HAMBURGER")) ||
            
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("BACON")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("EGG MCMUFFIN")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("SAUSAGE MCMUFFIN")) ||
            keccak256(abi.encodePacked(_produsVerificare)) ==  keccak256(abi.encodePacked("SAUSAGE MCMUFFIN WITH EDGG")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("SAUSAGE BISCUIT")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("SAUSAGE BISCUIT WITH EGG")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("BACON, EGG & CHEESE MCGRIDDLES")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("SAUSAGE MCGRIDDLES")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("SAUSAGE, EGG & CHEESE MCGRIDDLES")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("BIG BREAKFAST")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("BIG BREAKFAST WITH HOTCAKES")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("HOTCAKES")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("HOTCAKES AND SAUSAGE")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("SAUSAGE BURRITO")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("HASH BROWNS")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("FRUIT & MAPLE OATMEAL")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("EGG MCMUFFIN MEAL")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("SAUSAGE MCMUFFIN WITH EGG MEAL")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("BACON, EGG & CHEESE BISCUIT MEAL")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("BACON, EGG & CHEESE MCGRIDDLES MEAL")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("SAUSAGE, EGG & CHEESE MCGRIDDLES MEAL")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("SAUSAGE MCGRIDDLES MEAL")) ||
            keccak256(abi.encodePacked(_produsVerificare)) == keccak256(abi.encodePacked("SAUSAGE BURRITO MEAL"));

    }

    //  Functia care este folosita pt. a plasa comenzile
    function Comanda(string memory _produs) external view InregistrareCont(msg.sender) returns (Subcategorie memory) {
        require(verificareMeniu(_produs), "Va rugam sa alegeti unul din meniurile pe care McDondald's-ul vi le pune la dispozitie!");
        if(
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("BIG MAC")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("QUARTER POUNDER WITH CHEESE")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("DOUBLE QUARTER POUNDER WITH CHEESE")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("QUARTER POUNDER WITH CHEESE DELUXE")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("MCDOUBLE")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("QUARTER POUNDER WITH CHEESE BACON")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("CHEESEBURGER")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("DOUBLE CHEESEBURGER")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("HAMBURGER")) 
        ) {
            for(uint i = 0; i < Meniu[owner()]["Burgeri"].length; i++) {
                if(keccak256(abi.encodePacked(Meniu[owner()]["Burgeri"][i].Denumire)) == keccak256(abi.encodePacked(_produs)))
                    return Meniu[owner()]["Burgeri"][i];
            }
            /*  
                * Nu se va ajunge la aceasta returnare pt. ca exista validatoarele de existenta & for-ul de mai sus gaseste egalitatea 
                * Return-ul este doar pt. a nu genera erori*/
            return Meniu[owner()]["Burgeri"][0];
        } 
        else if(
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("BACON")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("EGG MCMUFFIN")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("SAUSAGE MCMUFFIN")) ||
            keccak256(abi.encodePacked(_produs)) ==  keccak256(abi.encodePacked("SAUSAGE MCMUFFIN WITH EDGG")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("SAUSAGE BISCUIT")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("SAUSAGE BISCUIT WITH EGG")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("BACON, EGG & CHEESE MCGRIDDLES")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("SAUSAGE MCGRIDDLES")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("SAUSAGE, EGG & CHEESE MCGRIDDLES")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("BIG BREAKFAST")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("BIG BREAKFAST WITH HOTCAKES")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("HOTCAKES")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("HOTCAKES AND SAUSAGE")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("SAUSAGE BURRITO")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("HASH BROWNS")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("FRUIT & MAPLE OATMEAL")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("EGG MCMUFFIN MEAL")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("SAUSAGE MCMUFFIN WITH EGG MEAL")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("BACON, EGG & CHEESE BISCUIT MEAL")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("BACON, EGG & CHEESE MCGRIDDLES MEAL")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("SAUSAGE, EGG & CHEESE MCGRIDDLES MEAL")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("SAUSAGE MCGRIDDLES MEAL")) ||
            keccak256(abi.encodePacked(_produs)) == keccak256(abi.encodePacked("SAUSAGE BURRITO MEAL"))
        ) {
            for(uint i = 0; i < Meniu[owner()]["Breakfast"].length; i++) {
                if(keccak256(abi.encodePacked(Meniu[owner()]["Breakfast"][i].Denumire)) == keccak256(abi.encodePacked(_produs)))
                    return Meniu[owner()]["Breakfast"][i];
            }
            /*  
                * Nu se va ajunge la aceasta returnare pt. ca exista validatoarele de existenta & for-ul de mai sus gaseste egalitatea 
                * Return-ul este doar pt. a nu genera erori*/
            return Meniu[owner()]["Breakfast"][0];
        }
        else {return Meniu[owner()]["Burgeri"][0];}
    }
}
