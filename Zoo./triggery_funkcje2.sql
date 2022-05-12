

-- 1.trigger sprawdzający czy w zwierzakach id_opiekuna ma pracownik opiekun

CREATE OR REPLACE FUNCTION sprawdz_opiekuna() RETURNS TRIGGER AS $$
DECLARE 
	krotka RECORD;
BEGIN
	SELECT * INTO krotka FROM pracownicy WHERE pracownicy.id = NEW.id_opiekuna;
	IF (krotka.stanowisko = 'opiekun') THEN
		RETURN NEW;
	ELSE
		RAISE 'Pracownik o id % nie jest opiekunem!', NEW.id_opiekuna;
	END IF;
END;
$$ LANGUAGE 'plpgsql';


DROP TRIGGER sprawdz_opiekuna_trigger ON zwierzeta CASCADE;
CREATE TRIGGER sprawdz_opiekuna_trigger BEFORE INSERT OR UPDATE ON zwierzeta
	FOR EACH ROW EXECUTE PROCEDURE sprawdz_opiekuna();
	

--2.Jak robimy karmienie to zmniejszaja sie zapasy i zmienia wartosc dni_do_karmienia--
CREATE OR REPLACE FUNCTION wez_jedzenie() RETURNS TRIGGER AS $$
DECLARE 
	krotka RECORD;
	stan_zapasow INTEGER;
	za_ile_znow_karmienie INTEGER;
BEGIN
	SELECT * INTO krotka 
		FROM gatunki g 
			JOIN zwierzeta z ON z.gatunek = g.nazwa
		WHERE z.id = NEW.id_zwierzaka;
	SELECT sum(ilosc) INTO stan_zapasow FROM zapasy WHERE zapasy.produkt = krotka.pozywienie;
	za_ile_znow_karmienie := krotka.czestotliwosc_karmienia;
	IF (krotka.ilosc_pokarmu  <= stan_zapasow) THEN
		UPDATE zapasy SET ilosc = ilosc - krotka.ilosc_pokarmu WHERE zapasy.produkt = krotka.pozywienie;
		UPDATE zwierzeta SET dni_do_karmienia = za_ile_znow_karmienie WHERE zwierzeta.id = NEW.id_zwierzaka;
		RETURN NEW;
	ELSE
		RAISE 'Nie ma wystarczajaco pozywienia!';
	END IF;
END;
$$ LANGUAGE 'plpgsql';


DROP TRIGGER wez_jedzenie_trigger ON karmienie CASCADE;
CREATE TRIGGER wez_jedzenie_trigger BEFORE INSERT ON karmienie
	FOR EACH ROW EXECUTE PROCEDURE wez_jedzenie();
	
--INSERT INTO karmienie VALUES (1, CURRENT_DATE, CURRENT_TIME);

--3.Zrobić żeby dni do karmienia się zupdateowały po dodaniu krotki--
CREATE OR REPLACE FUNCTION uzupelnij_dni_do_kamienia() RETURNS TRIGGER AS $$
DECLARE 
	krotka RECORD;
BEGIN 
	SELECT * INTO krotka FROM gatunki WHERE gatunki.nazwa = NEW.gatunek;
	UPDATE zwierzeta SET dni_do_karmienia = krotka.czestotliwosc_karmienia WHERE zwierzeta.id = NEW.id;
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER uzupelnij_dni_do_kamienia_trigger ON zwierzeta CASCADE;
CREATE TRIGGER uzupelnij_dni_do_kamienia_trigger AFTER INSERT ON zwierzeta
	FOR EACH ROW EXECUTE PROCEDURE uzupelnij_dni_do_kamienia();
	
--4 wyswietl zwierzaki danego opiekuna 

DROP FUNCTION zwierzaki_opiekuna();

CREATE OR REPLACE FUNCTION zwierzaki_opiekuna(id INTEGER) RETURNS TABLE (id_zwierzaka INTEGER, gatunek VARCHAR, imie VARCHAR) AS $$
DECLARE
	krotka RECORD;
BEGIN
	SELECT * INTO krotka FROM pracownicy WHERE pracownicy.id =zwierzaki_opiekuna.id;
	IF (NOT FOUND) THEN
		RAISE EXCEPTION 'Nie istenieje pracownik o takim id!';
	END IF;
	SELECT * INTO krotka 
	FROM pracownicy p
	WHERE p.id = zwierzaki_opiekuna.id AND p.stanowisko = 'opiekun';
	IF (NOT FOUND) THEN
		RAISE EXCEPTION 'Pracownik o id % nie jest opiekunem!', zwierzaki_opiekuna.id;
	END IF;
	RETURN QUERY
	SELECT z.id, z.gatunek, z.imie
	FROM zwierzeta z
	WHERE (z.id_opiekuna = zwierzaki_opiekuna.id)
	ORDER BY z.id;
END;
$$ LANGUAGE 'plpgsql';

--SELECT * FROM zwierzaki_opiekuna(50);

--5. badania zabierają z zapasow i zmieniaja ostatnie_badanie 
CREATE OR REPLACE FUNCTION wez_lek() RETURNS TRIGGER AS $$
DECLARE 
	lek RECORD;
	stan_zapasow INTEGER;
	za_ile_znow_karmienie INTEGER;
BEGIN
	SELECT * INTO lek FROM zabiegi WHERE zabiegi.rodzaj_zabiegu = NEW.zabieg;
	SELECT sum(ilosc) INTO stan_zapasow FROM zapasy WHERE zapasy.produkt = lek.rodzaj_leku;
	IF (NEW.ilosc_leku  <= stan_zapasow) THEN
		UPDATE zapasy SET ilosc = ilosc - NEW.ilosc_leku WHERE zapasy.produkt = lek.rodzaj_leku;
		UPDATE zwierzeta SET ostatnie_badanie = NEW.data_badania WHERE zwierzeta.id = NEW.id_zwierzaka;
		RETURN NEW;
	ELSE
		RAISE 'Nie ma wystarczajaco lekarstwa!';
	END IF;
END;
$$ LANGUAGE 'plpgsql';


DROP TRIGGER wez_lek_trigger ON badania CASCADE;
CREATE TRIGGER wez_lek_trigger BEFORE INSERT ON badania
	FOR EACH ROW EXECUTE PROCEDURE wez_lek();
	
--INSERT INTO badania VALUES (1, 26, CURRENT_DATE, 'narkoza', 3);
--INSERT INTO badania VALUES(300,26,CURRENT_DATE, 'narkoza',3);


--6. pozywienie w gatunkach może być tylko jedzenie
CREATE OR REPLACE FUNCTION sprawdz_pozywienie() RETURNS TRIGGER AS $$
DECLARE 
	krotka RECORD;
BEGIN
	SELECT * INTO krotka FROM zapasy WHERE NEW.pozywienie = zapasy.produkt;
	IF (krotka.rodzaj = 'jedzenie') THEN
		RETURN NEW;
	ELSE
		RAISE 'Produkt % nie moze byc pokarmem!', NEW.pozywienie;
	END IF;
END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER sprawdz_pozywienie_trigger ON gatunki CASCADE;
CREATE TRIGGER sprawdz_pozywienie_trigger BEFORE INSERT OR UPDATE ON gatunki
	FOR EACH ROW EXECUTE PROCEDURE sprawdz_pozywienie();
	
--INSERT INTO gatunki VALUES ('makak', 'miedzyzwrotnikowa', 'znieczulenie', FALSE, 'dzungla', 2, 2, 15); 

--7. sprzatac moze tylko sprzatacz
CREATE OR REPLACE FUNCTION sprawdz_sprzatacza() RETURNS TRIGGER AS $$
DECLARE 
	krotka RECORD;
BEGIN
	SELECT * INTO krotka FROM pracownicy WHERE pracownicy.id = NEW.id_sprzatajacego;
	IF (krotka.stanowisko = 'sprzatacz') THEN
		RETURN NEW;
	ELSE
		RAISE 'Pracownik o id % nie jest sprzataczem!', NEW.id_sprzatajacego;
	END IF;
END;
$$ LANGUAGE 'plpgsql';


DROP TRIGGER sprawdz_sprzatacza_trigger ON sprzatanie CASCADE;
CREATE TRIGGER sprawdz_sprzatacza_trigger BEFORE INSERT OR UPDATE ON sprzatanie
	FOR EACH ROW EXECUTE PROCEDURE sprawdz_sprzatacza();
	
--INSERT INTO sprzatanie(id_sprzatajacego, id_wybiegu) VALUES (1, 1);

--8. jak dodajemy gatunek sprawdz wybieg czy drapieżnik, czy dobra sterfa
CREATE OR REPLACE FUNCTION sprawdz_wybieg() RETURNS TRIGGER AS $$
DECLARE 
	wybieg RECORD;
	kto_na_wybiegu INTEGER;
BEGIN
	SELECT * INTO wybieg FROM wybiegi WHERE wybiegi.id = NEW.id_wybiegu;
	IF (NEW.czy_drapieznik = TRUE) THEN
		SELECT count(*) INTO kto_na_wybiegu FROM gatunki WHERE gatunki.id_wybiegu = NEW.id_wybiegu;
		IF (kto_na_wybiegu != 0) THEN 
			RAISE 'Nie mozna dodac drapieznika do innych!';
		END IF;
	END IF;
	IF (wybieg.typ_wybiegu != NEW.typ_wybiegu) THEN 
		RAISE 'Nie mozna dodac gatunku % do wybiegu %', NEW.nazwa, wybieg.typ_wybiegu;
	END IF;
	RETURN NEW;
END;
$$ LANGUAGE 'plpgsql';


DROP TRIGGER sprawdz_wybieg_trigger ON gatunki CASCADE;
CREATE TRIGGER sprawdz_wybieg_trigger BEFORE INSERT OR UPDATE ON gatunki
	FOR EACH ROW EXECUTE PROCEDURE sprawdz_wybieg();
	
--INSERT INTO gatunki VALUES ('pies_dingo', 'miedzyzwrotnikowa', 'mieso', TRUE, 'sawanna', 3, 5, 1);
--INSERT INTO gatunki VALUES ('pies_dingo', 'miedzyzwrotnikowa', 'mieso', FALSE, 'dzungla', 3, 5, 1);

--9. jak dodaje zwierze czy jest miejsce na wybiegu 

CREATE OR REPLACE FUNCTION sprawdz_limit_zwierzat() RETURNS TRIGGER AS $$
DECLARE 
	liczba_zw INTEGER;
	wybieg INTEGER;
	limit_zw INTEGER;
BEGIN
	SELECT id_wybiegu INTO wybieg FROM gatunki WHERE gatunki.nazwa = NEW.gatunek;
	SELECT max_zwierzat INTO limit_zw FROM wybiegi WHERE wybiegi.id = wybieg;
	SELECT zwierzat_na_wybiegu INTO liczba_zw FROM liczba_zwierzat_na_wybiegu WHERE liczba_zwierzat_na_wybiegu.id_wybiegu = wybieg;
	IF (liczba_zw < limit_zw) THEN
		RETURN NEW;
	ELSE
		RAISE 'Brak miejsca na tym wybiegu!';
	END IF;
END;
$$ LANGUAGE 'plpgsql';

DROP TRIGGER sprawdz_limit_zwierzat_trigger ON zwierzeta CASCADE;
CREATE TRIGGER sprawdz_limit_zwierzat_trigger BEFORE INSERT OR UPDATE ON zwierzeta
	FOR EACH ROW EXECUTE PROCEDURE sprawdz_limit_zwierzat();

--INSERT INTO zwierzeta(gatunek, imie, id_opiekuna, plec, data_urodzenia) VALUES ('pies_dingo','Reksio',14,'F','2006-07-24');


-- 10. funkcja, pokazująca przychody od do 
CREATE OR REPLACE FUNCTION pokaz_dochody(od_kiedy DATE, do_kiedy DATE) RETURNS TABLE (rodzaj_biletu VARCHAR, suma NUMERIC)AS $$
BEGIN 
	RETURN QUERY 
	SELECT s.rodzaj, sum(cena * s.ilosc) 
		FROM sprzedane_bilety s 
			JOIN bilety b 
				ON b.rodzaj = s.rodzaj
		WHERE (s.data_odwiedzin >= od_kiedy AND s.data_odwiedzin <= do_kiedy)
		GROUP BY s.rodzaj;
END;
$$ LANGUAGE 'plpgsql';
--INSERT INTO sprzedane_bilety(rodzaj, ilosc) VALUES ('uczniowski', 2), ('studencki', 4), ('rodzinny', 1), ('dzieci',3), ('grupowy_studencki', 20);



-- 11. suma z calego dnia

CREATE OR REPLACE FUNCTION suma_dzisiaj() RETURNS NUMERIC AS $$
DECLARE 
	wynik NUMERIC;
BEGIN 
	SELECT sum(cena*s.ilosc) INTO wynik
	FROM sprzedane_bilety s 
		JOIN bilety b 
			ON b.rodzaj = s.rodzaj 
	WHERE (s.data_odwiedzin = CURRENT_DATE);
	RETURN wynik;
END;
$$ LANGUAGE 'plpgsql';
--INSERT INTO sprzedane_bilety(rodzaj, ilosc) VALUES ('uczniowski', 2), ('studencki', 4), ('rodzinny', 1), ('dzieci',3), ('grupowy_studencki', 20);

-- 12. funkcja, pokazująca ilosc wykonanych zabiegow kazdego rodzaju od do, przez konkretnego wet 
CREATE OR REPLACE FUNCTION pokaz_zabiegi(od_kiedy DATE, do_kiedy DATE, kto INTEGER) RETURNS TABLE (rodzaj_zabiegu VARCHAR, ilosc BIGINT)AS $$
BEGIN 
	RETURN QUERY 
	SELECT zabieg, count(*)
		FROM badania 
		WHERE (data_badania >= od_kiedy 
				AND data_badania <= do_kiedy 
				AND id_weterynarza = kto)
		GROUP BY zabieg;
END;
$$ LANGUAGE 'plpgsql';

--SELECT * FROM pokaz_zabiegi('2020-10-10', CURRENT_DATE, 26);

--13. wydatki na zapasy w danym okresie
DROP FUNCTION pokaz_wydatki;
 
CREATE OR REPLACE FUNCTION pokaz_wydatki(od_kiedy DATE, do_kiedy DATE) RETURNS TABLE (rodzaj_produktu VARCHAR, ilosc BIGINT, kwota NUMERIC)AS $$
BEGIN 
	RETURN QUERY 
	SELECT zam.produkt, sum(zam.ilosc), sum(zap.cena_jednostkowa * zam.ilosc)
		FROM zamowienia zam
			JOIN zapasy  zap
				ON zam.produkt = zap.produkt
		WHERE (zam.data_zamowienia >= od_kiedy AND zam.data_zamowienia <= do_kiedy)
		GROUP BY zam.produkt;
END;
$$ LANGUAGE 'plpgsql';

--SELECT * FROM pokaz_wydatki('2020-10-10', CURRENT_DATE);

-- 14. funkcja zwolnij 
DROP FUNCTION zwolnij();

CREATE OR REPLACE FUNCTION zwolnij(id INTEGER) RETURNS TEXT AS $$
DECLARE 
	pracownik RECORD;
	ilosc_zwierzat INTEGER;
BEGIN
	SELECT * INTO pracownik FROM pracownicy WHERE pracownicy.id = zwolnij.id;
	IF (NOT FOUND) THEN
		RAISE EXCEPTION 'Pracownik o takim id nie instnieje!';
	END IF;
	IF (pracownik.stanowisko = 'opiekun') THEN
		SELECT liczba_zwierzat INTO ilosc_zwierzat 
		FROM ile_zwierzat_ma_opiekun 
		WHERE ile_zwierzat_ma_opiekun.id_opiekuna = zwolnij.id;
		IF (ilosc_zwierzat != 0) THEN
			RAISE EXCEPTION 'Ten pracownik opiekuje sie % zwierzetami! Nie mozna go zwolnic.', ilosc_zwierzat;
		END IF;
	END IF;
	DELETE FROM pracownicy WHERE pracownicy.id = zwolnij.id;
	RETURN 'Zwolniono pracownika o id: ' || zwolnij.id || ' ze stanowiska ' || pracownik.stanowisko;
END;
$$ LANGUAGE 'plpgsql';

--SELECT * FROM zwolnij(500);
--SELECT * FROM zwolnij(1);
--SELECT * FROM zwolnij(56);

--15. funkcja zatrudnij 

CREATE OR REPLACE FUNCTION zatrudnij(stanowisko VARCHAR, imie VARCHAR, nazwisko VARCHAR, telefon VARCHAR, mail VARCHAR) RETURNS TEXT AS $$
DECLARE 
	krotka RECORD;
BEGIN 
	SELECT * INTO krotka FROM stanowiska WHERE stanowiska.nazwa = zatrudnij.stanowisko;
	IF (NOT FOUND) THEN
		RAISE EXCEPTION 'Nie ma takiego stanowiska!';
	END IF;
	INSERT INTO pracownicy(stanowisko, imie, nazwisko, telefon, mail) VALUES(zatrudnij.stanowisko, zatrudnij.imie, zatrudnij.nazwisko, zatrudnij.telefon, zatrudnij.mail);
	RETURN 'Zatrudniono pracownika na stanowisku '|| zatrudnij.stanowisko;
END;
$$ LANGUAGE 'plpgsql';

--SELECT * FROM zatrudnij('opiekun', 'Krystyna', 'Lampka', '123456789', 'fhfes@zoo.pl');

--16. funkcja zmien opiekuna
DROP FUNCTION zmien_opiekuna();

CREATE OR REPLACE FUNCTION zmien_opiekuna(id_zwierzaka INTEGER, nowy_opiekun INTEGER) RETURNS TEXT AS $$
DECLARE
	krotka RECORD;
BEGIN 
	SELECT * INTO krotka 
	FROM pracownicy p
	WHERE p.id = zmien_opiekuna.nowy_opiekun AND p.stanowisko = 'opiekun';
	IF (NOT FOUND) THEN
		RAISE EXCEPTION 'Pracownik o id % nie jest opiekunem!', nowy_opiekun.id_opiekuna;
	END IF; 
	UPDATE zwierzeta 
	SET id_opiekuna = zmien_opiekuna.nowy_opiekun 
	WHERE id = zmien_opiekuna.id_zwierzaka;
	RETURN 'Pomyslnie zmieniono opiekuna zwierzaka o id '|| zmien_opiekuna.id_zwierzaka || ' na pracownika o id '|| zmien_opiekuna.nowy_opiekun;
END;
$$ LANGUAGE 'plpgsql';

--SELECT * FROM zmien_opiekuna(300, 76);

--17. dodaj zwierze 
CREATE OR REPLACE FUNCTION dodaj_zwierze(gatunek VARCHAR, imie VARCHAR, id_opiekuna INTEGER, plec VARCHAR, data_urodzenia DATE) RETURNS TEXT AS $$
DECLARE 
	krotka RECORD;
BEGIN
	SELECT * INTO krotka FROM gatunki WHERE gatunki.nazwa = dodaj_zwierze.gatunek;
	IF (NOT FOUND) THEN
		RAISE EXCEPTION 'Nie istenieje taki gatunek!';
	END IF;
	SELECT * INTO krotka FROM pracownicy WHERE pracownicy.id = dodaj_zwierze.id_opiekuna;
	IF (NOT FOUND) THEN
		RAISE EXCEPTION 'Nie istenieje pracownik o takim id!';
	END IF;
	SELECT * INTO krotka 
	FROM pracownicy p
	WHERE p.id = dodaj_zwierze.id_opiekuna AND p.stanowisko = 'opiekun';
	IF (NOT FOUND) THEN
		RAISE EXCEPTION 'Pracownik o id % nie jest opiekunem!', dodaj_zwierze.id_opiekuna;
	END IF; 
	INSERT INTO zwierzeta(gatunek, imie, id_opiekuna, plec, data_urodzenia) VALUES(dodaj_zwierze.gatunek, dodaj_zwierze.imie, dodaj_zwierze.id_opiekuna, dodaj_zwierze.plec, dodaj_zwierze.data_urodzenia);
	RETURN 'Pomyslnie dodano zwierzaka';
END;
$$ LANGUAGE 'plpgsql';

--SELECT * FROM dodaj_zwierze('alpakus', 'Dora', 1, 'F', '2019-01-01');
--SELECT * FROM dodaj_zwierze('alpaka', 'Dora', 50, 'F', '2019-01-01');


--18. usun zwierze 
DROP FUNCTION usun_zwierze();

CREATE OR REPLACE FUNCTION usun_zwierze(id INTEGER) RETURNS TEXT AS $$
DECLARE 
	zwierze RECORD;
	ilosc_zwierzat INTEGER;
BEGIN
	SELECT * INTO zwierze FROM zwierzeta WHERE zwierzeta.id = usun_zwierze.id;
	IF (NOT FOUND) THEN
		RAISE EXCEPTION 'Zwierze o takim id nie instnieje!';
	END IF;
	DELETE FROM zwierzeta WHERE zwierzeta.id = usun_zwierze.id;
	RETURN 'Usunieto zwierzaczka '||zwierze.imie||' o id: ' || usun_zwierze.id || ' z gatunku ' || zwierze.gatunek;
END;
$$ LANGUAGE 'plpgsql';

--SELECT * FROM usun_zwierze(50);

--19. dodaj gatunek 
CREATE OR REPLACE FUNCTION dodaj_gatunek(nazwa VARCHAR, strefa_klimatyczna VARCHAR, pozywienie VARCHAR, czy_drapieznik BOOLEAN, typ_wybiegu VARCHAR, czestotliwosc_karmienia INTEGER, ilosc_pokarmu INTEGER, id_wybiegu INTEGER) RETURNS TEXT AS $$
DECLARE 
	krotka RECORD;
BEGIN
	SELECT * INTO krotka FROM gatunki WHERE gatunek.nazwa = dodaj_gatunek.nazwa;
	IF (FOUND) THEN
		RAISE EXCEPTION 'Taki gatunek juz istnieje!';
	END IF;
	SELECT * INTO krotka 
	FROM wybiegi WHERE wybiegi.id = dodaj_gatunek.id_wybiegu;
	IF (NOT FOUND) THEN
		RAISE EXCEPTION 'Wybieg o takim id nie istnieje!';
	END IF;
	INSERT INTO gatunki(nazwa, strefa_klimatyczna, pozywienie, czy_drapieznik, typ_wybiegu, czestotliwosc_karmienia, ilosc_pokarmu, id_wybiegu) VALUES(dodaj_gatunek.nazwa, dodaj_gatunek.strefa_klimatyczna, dodaj_gatunek.pozywienie ,dodaj_gatunek.czy_drapieznik, dodaj_gatunek.typ_wybiegu, dodaj_gatunek.czestotliwosc_karmienia, dodaj_gatunek.ilosc_pokarmu, dodaj_gatunek.id_wybiegu);
	RETURN 'Pomyslnie dodano nowy gatunek';
END;
$$ LANGUAGE 'plpgsql';


--20. funkcja pokazujaca pracownikow na danym stanowisku 
DROP FUNCTION pokaz_pracownikow;
 
CREATE OR REPLACE FUNCTION pokaz_pracownikow(stanowisko VARCHAR) RETURNS TABLE (id_pracownika INTEGER, imie VARCHAR, nazwisko VARCHAR, telefon VARCHAR)AS $$
BEGIN 
	RETURN QUERY 
	SELECT p.id, p.imie, p.nazwisko, p.telefon
	FROM pracownicy p
	WHERE (p.stanowisko = pokaz_pracownikow.stanowisko)
	ORDER BY p.nazwisko ASC;
END;
$$ LANGUAGE 'plpgsql';

--SELECT * FROM pokaz_pracownikow('opiekun');

--21. pokaz zwierzeta danego gatunku 
DROP FUNCTION pokaz_gatunek;
 
CREATE OR REPLACE FUNCTION pokaz_gatunek(nazwa VARCHAR) RETURNS TABLE (id_zwierzaka INTEGER, imie VARCHAR, plec VARCHAR, data_urodzenia DATE)AS $$
BEGIN 
	RETURN QUERY 
	SELECT z.id, z.imie, z.plec, z.data_urodzenia
	FROM zwierzeta z
	WHERE (z.gatunek = pokaz_gatunek.nazwa)
	ORDER BY z.data_urodzenia DESC;
END;
$$ LANGUAGE 'plpgsql';

--SELECT * FROM pokaz_gatunek('pingwin');

--22. codziennie zmniejszanie sie o 1 dni_do_karmienia w tabeli zwierzeta, dodawanie zapasow

DROP FUNCTION zmien_date;

CREATE OR REPLACE FUNCTION zmien_date() RETURNS TEXT AS $$
DECLARE 
	dzis DATE;
BEGIN 
	SELECT dzisiaj INTO dzis FROM dzisiejsza_data;
	IF (dzis != CURRENT_DATE) THEN 
		UPDATE wybiegi
		SET dni_do_sprzatania = dni_do_sprzatania - 1;
		UPDATE zwierzeta
		SET dni_do_karmienia = dni_do_karmienia - 1;
		UPDATE dzisiejsza_data
		SET dzisiaj = CURRENT_DATE;
	
		UPDATE zapasy
		SET ilosc = ilosc + dz.ilosc_produktu
		FROM dzisiejsza_dostawa dz
		WHERE zapasy.produkt = dz.produkt;
		RETURN 'Dzien dobry, pomyslnie otworzono nowy dzien';
	ELSE 
		RETURN 'Data jest aktualna';
	END IF;
	
END;
$$ LANGUAGE 'plpgsql';

--SELECT * FROM zmien_date();




