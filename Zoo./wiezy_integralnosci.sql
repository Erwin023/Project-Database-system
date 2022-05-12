ALTER TABLE wybiegi ADD PRIMARY KEY (id);
ALTER TABLE wybiegi ALTER COLUMN typ_wybiegu SET NOT NULL;
ALTER TABLE wybiegi ALTER COLUMN czestotliwosc_sprzatania SET NOT NULL;
ALTER TABLE wybiegi ADD CHECK (czestotliwosc_sprzatania>0 AND czestotliwosc_sprzatania < 40);
ALTER TABLE wybiegi ALTER COLUMN dni_do_sprzatania SET NOT NULL;
ALTER TABLE wybiegi ADD CHECK (dni_do_sprzatania <= czestotliwosc_sprzatania);
ALTER TABLE wybiegi ALTER COLUMN max_zwierzat SET NOT NULL;

ALTER TABLE zapasy ADD PRIMARY KEY (produkt);
ALTER TABLE zapasy ALTER COLUMN ilosc SET NOT NULL;
ALTER TABLE zapasy ALTER COLUMN ilosc SET DEFAULT 0;
ALTER TABLE zapasy ADD CHECK (ilosc >= 0);
ALTER TABLE zapasy ALTER COLUMN cena_jednostkowa SET NOT NULL;
ALTER TABLE zapasy ADD CHECK (cena_jednostkowa >= 0);
ALTER TABLE zapasy ADD CHECK (rodzaj IN ('jedzenie', 'lek'));


ALTER TABLE gatunki ADD PRIMARY KEY (nazwa);
ALTER TABLE gatunki ADD CHECK (strefa_klimatyczna IN ('okolobiegunowa', 'umiarkowana', 'miedzyzwrotnikowa', 'ocean'));
ALTER TABLE gatunki ADD FOREIGN KEY (pozywienie) REFERENCES zapasy(produkt) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE gatunki ALTER COLUMN czy_drapieznik SET DEFAULT false; 
ALTER TABLE gatunki ALTER COLUMN czy_drapieznik SET NOT NULL;
ALTER TABLE gatunki ADD CHECK (typ_wybiegu IN ('arktyczny', 'lesny', 'trawiasty', 'sawanna', 'dzungla', 'pustynny', 'gorski', 'akwarium', 'terrarium', 'ptaszarnia', 'afrykarium', 'mokradla'));
ALTER TABLE gatunki ADD CHECK (czestotliwosc_karmienia > 0 AND czestotliwosc_karmienia < 40);
ALTER TABLE gatunki ALTER COLUMN czestotliwosc_karmienia SET NOT NULL;
ALTER TABLE gatunki ADD CHECK (ilosc_pokarmu > 0 AND ilosc_pokarmu < 20);
ALTER TABLE gatunki ALTER COLUMN ilosc_pokarmu SET NOT NULL;
ALTER TABLE gatunki ADD FOREIGN KEY (id_wybiegu) REFERENCES wybiegi(id) ON UPDATE CASCADE ON DELETE RESTRICT;

ALTER TABLE stanowiska ADD PRIMARY KEY (nazwa);
ALTER TABLE stanowiska ALTER COLUMN pensja SET NOT NULL;
ALTER TABLE stanowiska ADD CHECK (pensja > 0);

ALTER TABLE pracownicy ADD PRIMARY KEY (id);
ALTER TABLE pracownicy ADD FOREIGN KEY (stanowisko) REFERENCES stanowiska(nazwa) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE pracownicy ALTER COLUMN stanowisko SET NOT NULL;
ALTER TABLE pracownicy ALTER COLUMN imie SET NOT NULL;
ALTER TABLE pracownicy ALTER COLUMN nazwisko SET NOT NULL;


ALTER TABLE zwierzeta ADD PRIMARY KEY (id);
ALTER TABLE zwierzeta ADD FOREIGN KEY (gatunek) REFERENCES gatunki(nazwa) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE zwierzeta ALTER COLUMN gatunek SET NOT NULL;
ALTER TABLE zwierzeta ADD FOREIGN KEY (id_opiekuna) REFERENCES pracownicy(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE zwierzeta ADD CHECK (plec IN ('F', 'M'));
ALTER TABLE zwierzeta ADD CHECK (dni_do_karmienia >= 0 AND dni_do_karmienia < 40);
ALTER TABLE zwierzeta ADD UNIQUE (gatunek, imie);
 
 
ALTER TABLE karmienie ADD FOREIGN KEY (id_zwierzaka) REFERENCES zwierzeta(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE karmienie ALTER COLUMN id_zwierzaka SET NOT NULL;
ALTER TABLE karmienie ALTER COLUMN dzien_karmienia SET DEFAULT CURRENT_DATE;
ALTER TABLE karmienie ALTER COLUMN godzina_karmienia SET DEFAULT CURRENT_TIME;

ALTER TABLE zabiegi ADD PRIMARY KEY (rodzaj_zabiegu);
ALTER TABLE zabiegi ADD FOREIGN KEY (rodzaj_leku) REFERENCES zapasy(produkt) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE zabiegi ALTER COLUMN rodzaj_leku SET NOT NULL;


ALTER TABLE badania ADD FOREIGN KEY (id_zwierzaka) REFERENCES zwierzeta(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE badania ALTER COLUMN id_zwierzaka SET NOT NULL;
ALTER TABLE badania ADD FOREIGN KEY (id_weterynarza) REFERENCES pracownicy(id) ON UPDATE CASCADE ON DELETE CASCADE;
ALTER TABLE badania ALTER COLUMN id_weterynarza SET NOT NULL;
ALTER TABLE badania ALTER COLUMN data_badania SET DEFAULT CURRENT_DATE;
ALTER TABLE badania ADD FOREIGN KEY (zabieg) REFERENCES zabiegi(rodzaj_zabiegu) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE badania ALTER COLUMN zabieg SET NOT NULL;
ALTER TABLE badania ALTER COLUMN ilosc_leku SET NOT NULL;
ALTER TABLE badania ADD CHECK (ilosc_leku >0 AND ilosc_leku < 40);



ALTER TABLE zamowienia ALTER COLUMN id_pracownika SET NOT NULL;
ALTER TABLE zamowienia ADD FOREIGN KEY (produkt) REFERENCES zapasy(produkt) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE zamowienia ALTER COLUMN produkt SET NOT NULL;
ALTER TABLE zamowienia ALTER COLUMN ilosc SET NOT NULL;
ALTER TABLE zamowienia ADD CHECK (ilosc > 0 AND ilosc < 100000);
ALTER TABLE zamowienia ALTER COLUMN data_zamowienia SET NOT NULL;
ALTER TABLE zamowienia ALTER COLUMN data_zamowienia SET DEFAULT CURRENT_DATE;
ALTER TABLE zamowienia ADD CHECK (data_dostawy > data_zamowienia);
ALTER TABLE zamowienia ALTER COLUMN data_dostawy SET NOT NULL;

ALTER TABLE sprzatanie ALTER COLUMN id_sprzatajacego SET NOT NULL;
ALTER TABLE sprzatanie ADD FOREIGN KEY (id_sprzatajacego) REFERENCES pracownicy(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE sprzatanie ALTER COLUMN id_wybiegu SET NOT NULL;
ALTER TABLE sprzatanie ADD FOREIGN KEY (id_wybiegu) REFERENCES wybiegi(id) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE sprzatanie ALTER COLUMN dzien_sprzatania SET NOT NULL;
ALTER TABLE sprzatanie ALTER COLUMN dzien_sprzatania SET DEFAULT CURRENT_DATE;
ALTER TABLE sprzatanie ALTER COLUMN godzina_sprzatania SET DEFAULT CURRENT_TIME;

ALTER TABLE bilety ADD PRIMARY KEY (rodzaj);
ALTER TABLE bilety ADD CHECK (cena>0);
ALTER TABLE bilety ALTER COLUMN cena SET NOT NULL;

ALTER TABLE sprzedane_bilety ADD PRIMARY KEY (id);
ALTER TABLE sprzedane_bilety ADD FOREIGN KEY (rodzaj) REFERENCES bilety(rodzaj) ON UPDATE CASCADE ON DELETE RESTRICT;
ALTER TABLE sprzedane_bilety ALTER COLUMN rodzaj SET NOT NULL;
ALTER TABLE sprzedane_bilety ALTER COLUMN data_odwiedzin SET NOT NULL;
ALTER TABLE sprzedane_bilety ALTER COLUMN data_odwiedzin SET DEFAULT CURRENT_DATE; 
ALTER TABLE sprzedane_bilety ALTER COLUMN godzina_odwiedzin SET NOT NULL;
ALTER TABLE sprzedane_bilety ALTER COLUMN godzina_odwiedzin SET DEFAULT CURRENT_TIME;
ALTER TABLE sprzedane_bilety ADD CHECK (ilosc >=1);
ALTER TABLE sprzedane_bilety ALTER COLUMN ilosc SET DEFAULT 1;


ALTER TABLE dzisiejsza_data ALTER COLUMN dzisiaj SET NOT NULL;
ALTER TABLE dzisiejsza_data ALTER COLUMN dzisiaj SET DEFAULT CURRENT_DATE;


