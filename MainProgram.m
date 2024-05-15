% Difficulty: ★☆☆☆☆

% Code made by Roman Kuruc. Any sharing or copying this code is 
% understandable, since im hella good at this
%--------------------------------------------------------------------------
% COPYRIGHT © 2023 Roman Kuruc, student of University of Zilina, faculty of
% Electrical Engineering and Information Technology, field of study
% Communication and information technologies
% All rights reserved
%--------------------------------------------------------------------------


%vymazanie workspacu a command window
clc, clearvars

%otvorenie suboru
load("tesla.mat");

%Zobrazenie menu
HlavneMenu()

%jednoduche konzolove menu
endLoop = 1;
while(endLoop ~= 0)
    vstup = input("Zadaj vstup (HLAVNE MENU): ");
    switch vstup
        case 1
            vstup = MoznostiGrafov();
            VytvorGraf(tesla(:,1), tesla(:,2), tesla(:,3),tesla(:,3), vstup)
        case 2
            vstup = MoznostiGrafov();
            zobrazenieCasOkna(TSLA(:,1),tesla(:,1), tesla(:,2), tesla(:,3),tesla(:,3), vstup)
        case 3
            kladneDni(TSLA(:,1), tesla(:,1), tesla(:,4))
        case 4
             Median(TSLA(:,1),tesla(:,1), tesla(:,2), tesla(:,3), tesla(:,4))
        case 5
            sucetMedianAleboPH(TSLA(:,1),tesla(:,1), tesla(:,2), tesla(:,3), tesla(:,4))
        case 6
            najhorCasSeg(tesla(:, 1), tesla(:,4))
        case 7
            najlepCasSeg(tesla(:, 1), tesla(:,4))
        case 8 
            maxRozptyl(TSLA(:,1),tesla(:,2), tesla(:,3))
        case 9
            minRozptyl(TSLA(:,1), tesla(:,2), tesla(:,3))
        case 10
            vstup = MoznostiGrafov();
            priemFilter(tesla(:,1), tesla(:,2), tesla(:,3),tesla(:,3), vstup)
        case 11 
            vlastnaFunkcia(tesla(:,1), tesla(:,2), tesla(:,3), tesla(:,4))         
        case 12 
           endLoop = 0;
        otherwise
            disp("Neplatne cislo");
    end
end

%==========POMOCNE FUNKCIE==========%
%zobrazi menu a vstup na vytvorenie grafu pre druhu a poslednu funkciu
function[vystup] = MoznostiGrafov()
    disp(" 1 - graf pre Open");
    disp(" 2 - graf pre High");
    disp(" 3 - graf pre Low");
    disp(" 4 - graf pre Close");
    
    vystup = input("napis cislo: ");
end

function HlavneMenu()
    disp("stlac 1 pre vypis grafu");
    disp("stlac 2 pre vypis casoveho okna");
    disp("stlac 3 pre pocet kladnych dni");
    disp("stlac 4 pre zobrazenie medianov");
    disp("stlac 5 pre zobrazenie casoveho intrevalu");
    disp("stlac 6 najdenie najhorsieho casoveho segmentu");
    disp("stlac 7 pre najdenie najpozitivnejsieho cas. segmentu");
    disp("stlac 8 pre najdenie cas. segmentu s najvacsim rozptylom");
    disp("stlac 9 pre najdenie cas. segmentu s najmensim rozptylom");
    disp("stlac 10 vytvorenie noveho vektora pomocou priemerovacieho filtra");
    disp("stlac 11 vlastna funkcia");
    disp("stlac 12 pre ukoncenie programu");
    disp("=================================");
end

%==========1. FUNKCIA==========%
%vytvory nám graf zo zadaného vstupu, pripadne poctu hodnot
function VytvorGraf(hodnotaOpen, hodnotaHigh, hodnotaLow, hodnotaClose, vstup)
    switch vstup
        case 1
            figure(1);
            plot(hodnotaOpen(:), 'red');
            legend("Hodnota Open");
        case 2
            figure(2);
            plot(hodnotaHigh(:), 'blue');
            legend("Hodnota High");
        case 3
            figure(3);
            plot(hodnotaLow(:), 'green');
            legend("Hodnota Low");
        case 4
            figure(4);
            plot(hodnotaClose(:), 'black');
            legend("Hodnota Close");
        otherwise
            disp("neplatne cislo");
    end
end

%==========2. FUNKCIA==========%
%funkcia zobrazi uzivatelom vybrany graf zo zadaneho casoveho intervalu
function zobrazenieCasOkna(den, hodnotaOpen, hodnotaHigh, hodnotaLow, hodnotaClose, vstup)
    datum = input("Zadaj datum vo formate YYYY-MM-DD: ", 's');
    pocetDni = input("Zadaj pocet dni: ");
    cmpDen = false;
    pocetLoop = 0;
    
    if pocetDni > size(hodnotaOpen, 1) || pocetDni < 1
        disp("Zadany pocet dni je zaporny, pripadne vacsi ako je pocet záznamov v tabulke");
        return
    end

    %pred alokacia pola na zvysenie rychlosti
    novePole = pocetDni+1;
    
    %loop na najdenie datumu v tabulke
    for i=1:size(den,1)
        if datum == den{i,1}
            cmpDen = true;
            pocetLoop = i;
            break;
        end
    end

    if cmpDen == false
        disp("Zadaj platny datum");
        return
    end

    %vlozenie zadanych hodnot do novehoPola
    for i=pocetLoop:pocetLoop+pocetDni 
        if vstup == 1
            novePole(i,1) = hodnotaOpen(i,1); 
        elseif vstup == 2
            novePole(i,1) = hodnotaHigh(i,1); 
        elseif vstup == 3
            novePole(i,1) = hodnotaLow(i,1); 
        elseif vstup == 4
            novePole(i,1) = hodnotaClose(i,1); 
        end
    end

    switch vstup
        case 1 
            figure(1);
            plot(novePole(:,1), 'red');
            legend("Novy graf Open"); 
        case 2 
            figure(2);
            plot(novePole(:,1), 'blue');
            legend("Novy graf High"); 
        case 3
            figure(3);
            plot(novePole(:,1), 'green');
            legend("Novy graf Low"); 
        case 4
            figure(4);
            plot(novePole(:,1), 'black');
            legend("Novy graf Close");
        otherwise
            disp("Neplatny vstup");
    end
end

%==========3. FUNKCIA==========%
%funkcia vypise kladne dni, kedy hodnota Open bola mensia ako Close
%funkcia taktiez vypise za urcite obdobie - nefunguje
function kladneDni(den, hodnotaOpen,hodnotaClose)
    %PREMENNE
    pocetDni = 0;

    %VYPIS
    disp(" stlac 1 pre zobrazenie za celé obdobie: ");
    disp(" stlac 2 pre zobrazenie za vybrane obdobie: ");
    vstup = input(" vyber moznost: ");
    
    switch vstup
        case 1
            for i = 1:size(den, 1)
                if hodnotaClose(i) > hodnotaOpen(i)
                    pocetDni = pocetDni + 1;
                else
                    continue;
                end
            end
            disp(" Pocet kladnych dni za cele obdobie bolo: " + pocetDni);

        case 2
            datum = input(" Zadaj datum vo formate YYYY-MM-DD: ", 's');
            pocetDni = input(" Zadaj pocet dni: ");
            sucetDni = 0;
            cmpDatum = false;
            pocetLoop = 0;
    
            if pocetDni > size(hodnotaOpen, 1) || pocetDni < 1
                disp("Zadany pocet dni je zaporny, pripadne vacsi ako je pocet záznamov v tabulke");
                return
            end
    
            %tymto loopom si prejdem cely array a najdem si ci sa niekde
            %nachádza zadany datum, ak ano , tak mi nastavi pocetLoop na
            %pocet iteracii, ktore loop presiel
            
            for i = 1:size(den,1)
                if datum == den{i,1}
                    cmpDatum = true;
                    pocetLoop = i;
                    break;
                end
            end
            
            if cmpDatum == false
                disp(" NENASIEL SA ZIADEN DATUM");
                return;
            end
    
            %ak sa premenna strcmpDatum = true, tak dalsim for loopom
            %prejdem od lokacie, kde bol najdeny datum az do zadaneho
            %datumu
            for i = pocetLoop:pocetLoop+pocetDni
                %ak je hodnota close vacsia ako hodnota open, tak vypisem riadok a
                %datum, pre ktory tato podmienka plati
                if hodnotaClose(i,1) > hodnotaOpen(i,1)
                    sucetDni = sucetDni + 1;
                end
            end
            disp("pocet kladnych dni je: " + sucetDni);
    
        otherwise
            disp("nespravna moznost");
    end
end

%==========4. FUNKCIA==========%
%uzivatel zada datum vo formate "YYYY-MM-DD", pocet dni a z toho vypocita
%median pre zadane hodnoty
function Median(den, hodnotaOpen, hodnotaHigh, hodnotaLow, hodnotaClose)
    zadanyDen = input("Zadaj datum vo formate YYYY-MM-DD: ", "s");
    pocetDni = input("Zadaj pocet dni: ");
    pocetLoop = 0;
    cmpDatum = false;

    %premenne na vypocitany median
    medianOpen = 0;
    medianClose = 0;
    medianHigh = 0;
    medianLow = 0;

    %premenne na docasne ulozenie hodnot
    tempOpen = 0;
    tempClose = 0;
    tempHigh = 0;
    tempLow = 0;

    for i = 1:size(den,1)
        if zadanyDen == den{i,1}
            cmpDatum = true;
            pocetLoop = i;
            break;
        end
    end

    %kontrola ci bol najdeny datum
    if cmpDatum == false
        disp("nespravny datum!");
        return
    end

    %alokovanie pamati 
    novePoleOpen = pocetDni+1;
    novePoleClose = pocetDni+1;
    novePoleHigh = pocetDni+1;
    novePoleLow = pocetDni+1;

    %ulozim si celkovy pocet dni
    celkovyPocet = pocetDni+1;

    for i = pocetLoop:pocetLoop + pocetDni
        for j = pocetLoop:(pocetLoop + pocetDni)-1
            if hodnotaOpen(j) > hodnotaOpen(j+1)
                %Sortovanie hodnot pre Open
                tempOpen = hodnotaOpen(j);
                hodnotaOpen(j) = hodnotaOpen(j+1);
                hodnotaOpen(j+1) = tempOpen;
            end
            if hodnotaClose(j) > hodnotaClose(j+1)
                %sortovanie hodnot pre Close
                tempClose = hodnotaClose(j);
                hodnotaClose(j) = hodnotaClose(j+1);
                hodnotaClose(j+1) = tempClose;
            end
            if hodnotaHigh(j) > hodnotaHigh(j+1)
                %sortovanie hodnot pre High
                tempHigh = hodnotaHigh(j);
                hodnotaHigh(j) = hodnotaHigh(j+1);
                hodnotaHigh(j+1) = tempHigh;
            end
            if hodnotaLow(j) > hodnotaLow(j+1)
                %sortovanie hodnot pre Low
                tempLow = hodnotaLow(j);
                hodnotaLow(j) = hodnotaLow(j+1);
                hodnotaLow(j+1) = tempLow;
            end
        end
    end

    %do novych poli si ulozim zosortovane hodnoty 
    for i=pocetLoop:pocetLoop + pocetDni
       novePoleOpen(i) = hodnotaOpen(i,1);
       novePoleClose(i) = hodnotaClose(i,1);
       novePoleHigh(i) = hodnotaHigh(i,1);
       novePoleLow(i) = hodnotaLow(i,1);
    end

    %naslade spravim kontrolu ci zadane cislo je parne alebo neparne
    if mod(celkovyPocet, 2) ~= 0
        disp("median pre open: " + novePoleOpen(ceil(celkovyPocet/2)));  
        disp("median pre Close: " + novePoleClose(ceil(celkovyPocet/2)));
        disp("median pre High: " + novePoleHigh(ceil(celkovyPocet/2)));
        disp("median pre Low: " + novePoleLow(ceil(celkovyPocet/2)));
    else
        %ak pocet dni je parne cislo, tak si vytvorim docasne premenne, do
        %ktorych si ulozim hodnoty pre indexy n a n+1, z ktorych potom
        %vypocitam priemernu hodnotu
        medianOpen = (novePoleOpen((celkovyPocet/2)) + novePoleOpen(celkovyPocet/2)+1)/2;
        medianClose = (novePoleClose((celkovyPocet/2)) + novePoleClose(celkovyPocet/2)+1)/2;
        medianHigh = (novePoleHigh((celkovyPocet/2)) + novePoleHigh(celkovyPocet/2)+1)/2;
        medianLow = (novePoleLow((celkovyPocet/2)) + novePoleClose(celkovyPocet/2)+1)/2;

        disp("median pre Open: " + medianOpen);
        disp("median pre Close: " + medianClose);
        disp("median pre High: " + medianHigh);
        disp("median pre Low: " + medianLow);
    end
end

%==========5. FUNKCIA==========%
%uzivatel si vyberie datum, pocet dni a ci chce zratat pocet hodnotou nad
%urcitu hranicu alebo medianom
function sucetMedianAleboPH(den, hodnotaOpen, hodnotaHigh, hodnotaLow, hodnotaClose)
    zadanyDen = input("Zadaj datum vo formate YYYY-MM-DD: ", "s");
    pocetDni = input("Zadaj pocet dni: ");

    if pocetDni > size(den, 1) || pocetDni < 1 
        disp("Zadany pocet dni je zaporny, pripadne vacsi ako je pocet záznamov v tabulke");
        return
    end

    %--PREMENNE--%
    pocetLoop = 0;
    cmpDatum = false;

    medianHigh = 0;
    medianLow = 0;
    medianOpen = 0;
    medianClose = 0;

    sucetOpen = 0;
    sucetClose = 0;
    sucetHigh = 0;
    sucetLow = 0;

    novePoleOpen = zeros(pocetDni,1);
    novePoleClose = zeros(pocetDni,1);
    novePoleHigh = zeros(pocetDni, 1);
    novePoleLow = zeros(pocetDni, 1);

    %najdenie datumu v poli
    for i = 1:size(den,1)
        if zadanyDen == den{i,1}
            cmpDatum = true;
            pocetLoop = i;
            break;
        end
    end

    %kontrola ci bol najdeny datum
    if cmpDatum == false
        disp("nespravny datum!");
        return
    end
    
    celkovyPocetDni = pocetDni + 1;
   %roztriedim si hodnoty v poliach
   for i = pocetLoop:pocetLoop + pocetDni
        for j = pocetLoop:pocetLoop + pocetDni-1
            if hodnotaOpen(j) > hodnotaOpen(j+1)
                %Sortovanie hodnot pre Open
                tempOpen = hodnotaOpen(j);
                hodnotaOpen(j) = hodnotaOpen(j+1);
                hodnotaOpen(j+1) = tempOpen;
            end
            if hodnotaClose(j) > hodnotaClose(j+1)
                %sortovanie hodnot pre Close
                tempClose = hodnotaClose(j);
                hodnotaClose(j) = hodnotaClose(j+1);
                hodnotaClose(j+1) = tempClose;
            end
            if hodnotaHigh(j) > hodnotaHigh(j+1)
                %sortovanie hodnot pre High
                tempHigh = hodnotaHigh(j);
                hodnotaHigh(j) = hodnotaHigh(j+1);
                hodnotaHigh(j+1) = tempHigh;
            end
            if hodnotaLow(j) > hodnotaLow(j+1)
                %sortovanie hodnot pre Low
                tempLow = hodnotaLow(j);
                hodnotaLow(j) = hodnotaLow(j+1);
                hodnotaLow(j+1) = tempLow;
            end
        end 
   end

   for i=pocetLoop:pocetLoop + pocetDni
       novePoleOpen(i) = hodnotaOpen(i);
       novePoleClose(i) = hodnotaClose(i);
       novePoleHigh(i) = hodnotaHigh(i);
       novePoleLow(i) = hodnotaLow(i);
   end

   disp(" 1 - pre sucet hodnot nad urcitu hranicu");
   disp(" 2 - pre sucet hodnot nad hranicu medianu");
   vstup = input("vyber moznost: ");

   switch vstup
       case 1
           %sucet hodnot nad stanovenou hranicou
           hranica = input("Zadaj cislo, nad ktore chces scitat cisla: ");
           for i = 1:pocetDni
               %ak cislo v poli je vacsie ako zadana hranica, tak ju
               %pripocitam
               if hranica <= novePoleOpen(i)
                   sucetOpen = sucetOpen + novePoleOpen(i);
               end
               if hranica <= novePoleClose(i)
                   sucetClose = sucetClose + novePoleClose(i);
               end
               if hranica <= novePoleHigh(i)
                   sucetHigh = sucetOpen + novePoleHigh(i);
               end
               if hranica <= novePoleLow(i)
                    sucetLow = sucetOpen + novePoleLow(i);
               end
           end
           disp("Sucet Open nad zadanu hranicu je: " + sucetOpen);
           disp("Sucet Close nad zadanu hranicu je: " + sucetClose);
           disp("Sucet High nad zadanu hranicu je: " + sucetHigh);
           disp("Sucet Low nad zadanu hranicu je: " + sucetLow);

       case 2
         if mod(celkovyPocetDni, 2) ~= 0
             medianOpen = novePoleOpen(ceil(celkovyPocetDni/2));  
             medianClose = novePoleOpen(ceil(celkovyPocetDni/2));
             medianHigh = novePoleHigh(ceil(celkovyPocetDni/2));
             medianLow = novePoleLow(ceil(celkovyPocetDni/2));
         else
             % vypocet parnych medianov 
             medianOpen = (novePoleOpen((celkovyPocetDni/2)) + novePoleOpen(celkovyPocetDni/2)+1)/2;
             medianClose = (novePoleClose((celkovyPocetDni/2)) + novePoleClose(celkovyPocetDni/2)+1)/2;
             medianHigh = (novePoleHigh((celkovyPocetDni/2)) + novePoleHigh(celkovyPocetDni/2)+1)/2;
             medianLow = (novePoleLow((celkovyPocetDni/2)) + novePoleClose(celkovyPocetDni/2)+1)/2;
         end
         
         %prechadzam polom s novymi hodnotami. Ked indexy v poli su
         %vacsie ako median, tak to zacne spocitavat
         for i = 1:pocetDni+1
            if medianOpen <= novePoleOpen(i)
                sucetOpen = sucetOpen + novePoleOpen(i);
            end
            if medianClose <= novePoleClose(i)
                sucetClose = sucetClose + novePoleClose(i);
            end
            if medianHigh <= novePoleHigh(i)
                sucetHigh = sucetHigh + novePoleHigh(i);
            end
            if medianLow <= novePoleLow(i)
                sucetLow = sucetLow + novePoleLow(i);
            end
         end
         disp("Sucet hodnot Open nad median je: " + sucetOpen);
         disp("Sucet hodnot Close nad median je: " + sucetClose);
         disp("Sucet hodnot High nad median je: " + sucetHigh);
         disp("Sucet hodnot Low nad median je: " + sucetLow);
       otherwise
         disp("Zla moznost!!!");
   end
end

%==========6. FUNKCIA==========%
%vstupom funkcie je pocet dni, z ktorych najdem najhorsi casovy segment
function najhorCasSeg(hodnotaOpen, hodnotaClose)
    pocetDni = input(" zadaj cislo na najdenie nahorsieho cas. segmentu: ");
    rozdiel = 0;

    %ochrana pred zlym vstupom
    if pocetDni > size(hodnotaOpen, 1) || pocetDni < 1
        disp(" zadany pocet dni je mensi ako 0, prípadne vacsi ako pocet zaznamov v tabulke");
        disp(" Aktualny pocet zaznamov je: " + size(hodnotaOpen,1));
        return
    end

    minHodnota = hodnotaOpen(1)-hodnotaClose(pocetDni);

    for i = 1:size(hodnotaOpen, 1) - pocetDni + 1
        rozdiel = hodnotaOpen(i) - hodnotaClose(pocetDni-1+i);
        if minHodnota >= rozdiel
            minHodnota = rozdiel;
        end
    end

    disp(" najmensi narast je: " + minHodnota);
end

%==========7. FUNKCIA==========%
%vstupom funkcie je pocet dni, kde najdem najlepsi casovy segment
function najlepCasSeg(hodnotaOpen, hodnotaClose)
    pocetDni = input(" zadaj cislo na najdenie najlepsieho cas. segmentu: ");
    rozdiel = 0;

    %ochrana pred zlym vstupom
    if pocetDni > size(hodnotaOpen, 1) || pocetDni < 1
        disp(" zadany pocet dni je mensi ako 0, prípadne vacsi ako pocet zaznamov v tabulke");
        disp(" Aktualny pocet zaznamov je: " + size(hodnotaOpen,1));
        return
    end

    maxHodnota = hodnotaOpen(1)-hodnotaClose(pocetDni);

    for i = 1:size(hodnotaOpen, 1) - pocetDni + 1
        rozdiel = hodnotaOpen(i) - hodnotaClose(pocetDni-1+i);
        if maxHodnota <= rozdiel
            maxHodnota = rozdiel;
        end
    end
    disp(" najvacsi narast je: " + maxHodnota);
end

%==========8. FUNKCIA =========%
%uzivatel zada pocet dni a funckia mu vypocita maximalny rozdiel hodnot
%High a Low pre zadany pocet dni
function maxRozptyl(den, hodnotaHigh, hodnotaLow)
    pocetDni = input(" zadaj pocet dni: ");
    sucetHodnot = 0;
    vysledneHodnoty = size(den,1);
    rozdiel = 0;
    count = 0;
    maxHodnota = 0;
    
    %ochrana pre pripad, ze zadana hodnota bola vacsia ako pocet zaznamov,
    %pripadne zaporne cislo
    if pocetDni > size(den, 1) || pocetDni < 1
        disp(" zadany pocet dni je mensi ako 0, prípadne vacsi ako pocet zaznamov v tabulke");
        disp(" Aktualny pocet zaznamov je: " + size(den,1));
        return
    end
  
    %for loop, ktory mi prejde cele pole po casovych segmentoch, ktore som
    %zadal 
    for i = 1:size(den,1)-pocetDni+1
        for j = 1+i-1:pocetDni+i-1
            count = count + 1;
            rozdiel = hodnotaHigh(j) - hodnotaLow(j);
            sucetHodnot = sucetHodnot + rozdiel;
            if count == pocetDni
                vysledneHodnoty(i) = sucetHodnot;
                count = 0;
                sucetHodnot = 0;
            end
        end
    end


    %nastavim si ako max hodnotu prvu hodnotu z novo vytvoreneho pola
    %prejdem pole loopom a snazim sa najst najvacsiu hodnotu
    maxHodnota = vysledneHodnoty(1);
    for i = 1:length(vysledneHodnoty)
        if maxHodnota < vysledneHodnoty(i)
            maxHodnota = vysledneHodnoty(i);
        else
            continue;
        end
    end
    disp(" najvacsi rozdiel pre zadany pocet dni bol: " + maxHodnota);
end

%==========9. FUNKCIA ==========%
%uzivatel zada pocet dni a funkcia mu vypocita najmensi rozdiel hodnot High
%a low pre zadany pocet dni
function minRozptyl(den, hodnotaHigh, hodnotaLow)
    pocetDni = input(" zadaj pocet dni: ");
    sucetHodnot = 0;
    vysledneHodnoty = size(den,1);
    rozdiel = 0;
    count = 0;
    minHodnota = 0;
    
    %ochrana pre pripad, ze zadana hodnota bola vacsia ako pocet zaznamov,
    %pripadne zaporne cislo
    if pocetDni > size(den, 1) || pocetDni < 1
        disp(" zadany pocet dni je mensi ako 0, prípadne vacsi ako pocet zaznamov v tabulke");
        disp(" Aktualny pocet zaznamov je: " + size(den,1));
        return
    end
  
    for i = 1:size(den,1)-pocetDni+1
        for j = 1+i-1:pocetDni+i-1
            count = count + 1;
            rozdiel = hodnotaHigh(j) - hodnotaLow(j);
            sucetHodnot = sucetHodnot + rozdiel;
            if count == pocetDni
                vysledneHodnoty(i) = sucetHodnot;
                count = 0;
                sucetHodnot = 0;
            end
        end
    end


    %nastavim si ako max hodnotu prvu hodnotu z novo vytvoreneho pola
    %prejdem pole loopom a snazim sa najst najvacsiu hodnotu
    minHodnota = vysledneHodnoty(1);
    for i = 1:length(vysledneHodnoty)
        if minHodnota > vysledneHodnoty(i)
            minHodnota = vysledneHodnoty(i);
        else
            continue;
        end
    end
    disp(" najmensi rozdiel pre zadany pocet dni bol: " + minHodnota);
end

%==========10. FUNKCIA==========%
%uzivatel si vyberie, ktory graf chce zobrazit, potom na kolko cisel chce
%spriemerovat,vystupom je graf bez filtrovanymi a s filtrovanymi hodnotami
function priemFilter(hodnotaOpen, hodnotaHigh, hodnotaLow, hodnotaClose, vstup)
    velkostPola = length(hodnotaOpen);
    velkostPriemeru = input(" Zadaj pocet cisel, ktore chceme spriemerovat: ");

    %ochrana pred zlym vstupom
    if velkostPriemeru > size(hodnotaHigh, 1) || velkostPriemeru < 1
        disp(" zadany pocet dni je mensi ako 0, prípadne vacsi ako pocet zaznamov v tabulke");
        disp(" Aktualny pocet zaznamov je: " + size(hodnotaHigh,1));
        return
    end

    %predalkovanie pamate pre nove polia
    novePoleOpen = velkostPola;
    novePoleHigh = velkostPola;
    novePoleLow = velkostPola;
    novePoleClose = velkostPola;

    sucetOpen = 0;
    sucetHigh = 0;
    sucetLow = 0;
    sucetClose = 0;

    %prechadzam celym polom az po poslednych n hodnot
    for i = 1:length(hodnotaOpen)-velkostPriemeru+1
        %ak sa mi vykona cely for loop, tak iba pripocitam hodnotu z loopu
        %nad a pokracujem dalej
        for j = 1+i-1:velkostPriemeru+i-1
            sucetOpen = sucetOpen + hodnotaOpen(j);
            sucetHigh = sucetHigh + hodnotaHigh(j);
            sucetLow = sucetLow + hodnotaLow(j);
            sucetClose = sucetClose + hodnotaClose(j);
        end
        %zo suctu vypocitam priemer
        sucetOpen = sucetOpen / velkostPriemeru;
        sucetHigh = sucetHigh / velkostPriemeru;
        sucetLow = sucetLow / velkostPriemeru;
        sucetClose = sucetClose / velkostPriemeru;

        %vyslednu hodnotu vlozim do noveho pola
        novePoleOpen(i) = sucetOpen;
        novePoleHigh(i) = sucetHigh;
        novePoleLow(i) = sucetLow;
        novePoleClose(i) = sucetClose;
        
        %vynulovanie hodnot suctu
        sucetOpen = 0;
        sucetHigh = 0;
        sucetLow = 0;
        sucetClose = 0;
    end
   
    switch vstup 
        case 1
            %vypis grafov Open
            figure(1);
            plot(hodnotaOpen, 'blue');
            title("graf Open, blue - nefiltrovane hodnoty, red - filtrovane hodnoty");
            hold on
            plot(novePoleOpen, 'red');
            hold off
        case 2
            %vypis grafov High
            figure(2);
            plot(hodnotaHigh, 'blue');
            title("graf High, blue - nefiltrovane hodnoty, red - filtrovane hodnoty");
            hold on
            plot(novePoleHigh, 'red');
            hold off
        case 3
            %vypis grafov Low
            figure(3);
            plot(hodnotaLow, 'blue');
            title("graf Low, blue - nefiltrovane hodnoty, red - filtrovane hodnoty");
            hold on
            plot(novePoleLow, 'red');
            hold off
        case 4
            %vypis grafov Close
            figure(4);
            plot(hodnotaClose, 'blue');
            title("graf Close, blue - nefiltrovane hodnoty, red - filtrovane hodnoty");
            hold on
            plot(novePoleClose, 'red');
            hold off
    end
end

%==========11. FUNKCIA==========%
%vypocita priemernu hodnotu pre Open, High, Low a Close a vytvorí graf
function vlastnaFunkcia(hodnotaOpen, hodnotaHigh, hodnotaLow, hodnotaClose)
    novePole = size(hodnotaOpen,1);

    for i = 1:size(hodnotaOpen,1)
        novePole(i) = (hodnotaOpen(i) + hodnotaHigh(i) + hodnotaLow(i) + hodnotaClose(i))/4;
    end

    figure(1)
    plot(novePole(:));
    legend("pole s priemernymi hodnotami");
end

%koniec programu