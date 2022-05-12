DROP TABLE gatunki;

CREATE TABLE gatunki(
	nazwa VARCHAR(50),
	strefa_klimatyczna VARCHAR(50),
	pozywienie VARCHAR(50),
	czy_drapieznik BOOLEAN,
	typ_wybiegu VARCHAR(50),
	czestotliwosc_karmienia INTEGER,
	ilosc_pokarmu INTEGER,
	id_wybiegu INTEGER
);


DROP TABLE zwierzeta;

CREATE TABLE zwierzeta(
	id SERIAL,
	gatunek VARCHAR(50),
	imie VARCHAR(50),
	id_opiekuna INTEGER,
	plec VARCHAR(1),
	data_urodzenia DATE,
	dni_do_karmienia INTEGER,
	ostatnie_badanie DATE
);


DROP TABLE karmienie;

CREATE TABLE karmienie(
	id_zwierzaka INTEGER,
	dzien_karmienia DATE,
	godzina_karmienia TIME
);


DROP TABLE badania;

CREATE TABLE badania(
	id_zwierzaka INTEGER,
	id_weterynarza INTEGER,
	data_badania DATE,
	zabieg VARCHAR(255),
	ilosc_leku INTEGER
);

DROP TABLE pracownicy;

CREATE TABLE pracownicy(
	id SERIAL,
	stanowisko VARCHAR(50),
	imie VARCHAR(50),
	nazwisko VARCHAR(50),
	telefon VARCHAR(9),
	mail VARCHAR(30)
);


DROP TABLE stanowiska;

CREATE TABLE stanowiska(
	nazwa VARCHAR(20),
	pensja DECIMAL(7,2)
);


DROP TABLE zabiegi;

CREATE TABLE zabiegi(
	rodzaj_zabiegu VARCHAR(255),
	rodzaj_leku VARCHAR(255) 
);


DROP TABLE zapasy;

CREATE TABLE zapasy(
	produkt VARCHAR(50),
	ilosc INTEGER,
	cena_jednostkowa DECIMAL(6,2),
	rodzaj VARCHAR(20)
);


DROP TABLE zamowienia;

CREATE TABLE zamowienia(
	id_pracownika VARCHAR(50),
	produkt VARCHAR(50),
	ilosc INTEGER,
	data_zamowienia DATE,
	data_dostawy DATE
);


DROP TABLE wybiegi;

CREATE TABLE wybiegi(
	id SERIAL,
	powierzchnia_m2 NUMERIC(50),
	typ_wybiegu VARCHAR(50),
	czestotliwosc_sprzatania INTEGER,
	dni_do_sprzatania INTEGER,
	max_zwierzat INTEGER
);


DROP TABLE sprzatanie;

CREATE TABLE sprzatanie(
	id_sprzatajacego INTEGER,
	id_wybiegu INTEGER,
	dzien_sprzatania DATE,
	godzina_sprzatania TIME
);


DROP TABLE sprzedane_bilety;

CREATE TABLE sprzedane_bilety(
	id SERIAL,
	rodzaj VARCHAR(50),
	ilosc INTEGER,
	data_odwiedzin DATE,
	godzina_odwiedzin TIME
);


DROP TABLE bilety;

CREATE TABLE bilety(
	rodzaj VARCHAR(50),
	cena NUMERIC(20),
	uwagi VARCHAR(255)
);

DROP TABLE dzisiejsza_data;

CREATE TABLE dzisiejsza_data(
	dzisiaj DATE
);

INSERT INTO dzisiejsza_data VALUES(CURRENT_DATE);
