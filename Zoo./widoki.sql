--widoki--

--ile hajsu pracownikom i ile z biletow haraczy--
DROP VIEW do_nakarmienia;

CREATE VIEW do_nakarmienia AS
	SELECT z.id AS id_zwierzaka, p.id AS id_pracownika, g.pozywienie AS pozywienie 
	FROM zwierzeta z 
		JOIN pracownicy p
			ON z.id_opiekuna = p.id
		JOIN gatunki g
			ON z.gatunek = g.nazwa
	WHERE dni_do_karmienia = 0;


DROP VIEW do_sprzatania;

CREATE VIEW do_sprzatania AS
	SELECT w.id AS id_wybiegu
	FROM wybiegi w
	WHERE w.dni_do_sprzatania = 0;
	
	
DROP VIEW wydatki_na_pensje;

CREATE VIEW wydatki_na_pensje AS
	SELECT sum(s.pensja) AS wydatki_na_pensje
	FROM pracownicy p 
		JOIN stanowiska s
			ON p.stanowisko = s.nazwa;
			

DROP VIEW ile_zwierzat_w_gatunku;

CREATE VIEW ile_zwierzat_w_gatunku AS
	SELECT g.nazwa, count(z.gatunek) AS liczba_okazow, count(CASE WHEN z.plec = 'F' then 1 ELSE NULL END) AS samice, count(CASE WHEN z.plec = 'M' then 1 ELSE NULL END) AS samce
	FROM zwierzeta z
		JOIN gatunki g
			ON z.gatunek = g.nazwa
	GROUP BY g.nazwa;
	


DROP VIEW ile_pracownikow_na_stanowisku;

CREATE VIEW ile_pracownikow_na_stanowisku AS
	SELECT count(p.stanowisko) AS liczba_pracownikow, s.nazwa
	FROM pracownicy p
		JOIN stanowiska s
			ON p.stanowisko = s.nazwa
	GROUP BY s.nazwa;
	

DROP VIEW liczba_wybiegow;	

CREATE VIEW liczba_wybiegow AS
	SELECT count(typ_wybiegu) AS liczba_wybiegow, typ_wybiegu
	FROM wybiegi
	GROUP BY typ_wybiegu;
	
	
DROP VIEW liczba_zwierzat_na_wybiegu;

CREATE VIEW liczba_zwierzat_na_wybiegu AS
	SELECT w.id AS id_wybiegu, count(z.gatunek) AS zwierzat_na_wybiegu, w.max_zwierzat AS gorny_limit
	FROM zwierzeta z
		RIGHT OUTER JOIN gatunki g
			ON g.nazwa = z.gatunek
		JOIN wybiegi w
			ON w.id = g.id_wybiegu
	GROUP BY w.id
	ORDER BY count(z.gatunek) DESC;
	

DROP VIEW ile_jedzenia;

CREATE VIEW ile_jedzenia AS
	SELECT g.pozywienie, sum(g.ilosc_pokarmu) AS jedzenie_na_jutro, za.ilosc
	FROM gatunki g
		JOIN zwierzeta z
			ON z.gatunek = g.nazwa
		JOIN zapasy za
			ON g.pozywienie = za.produkt
	WHERE z.dni_do_karmienia = 1
	GROUP BY g.pozywienie, za.ilosc;
	


DROP VIEW bad_dawniej_niz_30;

CREATE VIEW bad_dawniej_niz_30 AS
	SELECT id AS id_zwierzaka, gatunek, ostatnie_badanie
	FROM zwierzeta
	WHERE ostatnie_badanie < CURRENT_DATE - 30 OR ostatnie_badanie IS NULL;
	



DROP VIEW ile_zwierzat_ma_opiekun;

CREATE VIEW ile_zwierzat_ma_opiekun AS
	SELECT p.id AS id_opiekuna, p.imie, p.nazwisko, count(z.id_opiekuna) AS liczba_zwierzat
	FROM pracownicy p
		JOIN zwierzeta z
			ON p.id = z.id_opiekuna
	WHERE p.stanowisko = 'opiekun'
	GROUP BY p.id
	ORDER BY p.nazwisko;
	



DROP VIEW dzisiejsza_dostawa;

CREATE VIEW dzisiejsza_dostawa AS
	SELECT zam.produkt, sum(zam.ilosc) AS ilosc_produktu
	FROM zamowienia zam
		JOIN dzisiejsza_data dd
			ON zam.data_dostawy = dd.dzisiaj
	GROUP BY zam.produkt;
	
DROP VIEW dzisiejsza_dostawa;

CREATE VIEW wszystkie_zamowienia AS
	SELECT zam.produkt, sum(zam.ilosc) AS ilosc_produktu
	FROM zamowienia zam
		JOIN dzisiejsza_data dd
			ON zam.data_dostawy <= dd.dzisiaj
	GROUP BY zam.produkt;
	

	
	
	