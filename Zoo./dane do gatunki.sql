

--nazwa, strefa klimatyczna, pozywienie, czy drapieznik, typ wybiegu, czestotliwosc karmienia, ilosc_pokarmu, id_wybiegu)
--strefa klimatyczna = (okolobiegunowa, umiarkowana, miedzyzwrotnikowa, ocean)
--pozywienie = (mieso, siano, warzywa, owoce, ryby, owady, skorupiaki, karma_dla_ryb)
--typ wybiegu = (arktyczny, lesny, trawiasty, sawanna, dzungla, pustynny, gorski, akwarium, terrarium, ptaszarnia, afrykarium, mokradla)

INSERT INTO gatunki VALUES ('alpaka', 'umiarkowana', 'warzywa', FALSE, 'trawiasty', 2, 5, 2); 
INSERT INTO gatunki VALUES ('lew', 'miedzyzwrotnikowa', 'mieso', TRUE, 'sawanna', 10, 10, 5); 
INSERT INTO gatunki VALUES ('zebra', 'miedzyzwrotnikowa', 'siano', FALSE, 'sawanna', 2, 5, 1); 
INSERT INTO gatunki VALUES ('zyrafa', 'miedzyzwrotnikowa', 'siano', FALSE, 'sawanna', 1, 8, 1); 
INSERT INTO gatunki VALUES ('slon', 'miedzyzwrotnikowa', 'siano', FALSE, 'sawanna', 3, 12, 6);
INSERT INTO gatunki VALUES ('krokodyl', 'miedzyzwrotnikowa', 'mieso', TRUE, 'afrykarium', 14, 10, 7); 
INSERT INTO gatunki VALUES ('rekin', 'ocean', 'ryby', TRUE, 'akwarium', 5, 10, 8); 
INSERT INTO gatunki VALUES ('niedzwiedz_polarny', 'okolobiegunowa', 'ryby', TRUE, 'arktyczny', 7, 15, 9); 
INSERT INTO gatunki VALUES ('niedzwiedz_brunatny', 'umiarkowana', 'mieso', TRUE, 'lesny', 7, 13, 10); 
INSERT INTO gatunki VALUES ('tygrys', 'miedzyzwrotnikowa', 'mieso', TRUE, 'dzungla', 10, 12, 11);
INSERT INTO gatunki VALUES ('orka', 'ocean', 'ryby', TRUE, 'akwarium', 5, 12, 12); 
INSERT INTO gatunki VALUES ('foka', 'okolobiegunowa', 'ryby', TRUE, 'arktyczny', 7, 8, 13); 
INSERT INTO gatunki VALUES ('gepard', 'miedzyzwrotnikowa', 'mieso', TRUE, 'sawanna', 14, 7, 14); 
INSERT INTO gatunki VALUES ('flaming', 'miedzyzwrotnikowa', 'skorupiaki', FALSE, 'dzungla', 3, 7, 3); 
INSERT INTO gatunki VALUES ('pelikan', 'miedzyzwrotnikowa', 'skorupiaki', FALSE, 'dzungla', 3, 5, 3);
INSERT INTO gatunki VALUES ('szympans', 'miedzyzwrotnikowa', 'owoce', FALSE, 'dzungla', 4, 5, 15); 
INSERT INTO gatunki VALUES ('goryl', 'miedzyzwrotnikowa', 'owoce', FALSE, 'dzungla', 4, 10, 16); 
INSERT INTO gatunki VALUES ('lemur', 'miedzyzwrotnikowa', 'owoce', FALSE, 'dzungla', 3, 3, 17); 
INSERT INTO gatunki VALUES ('orangutan', 'miedzyzwrotnikowa', 'owoce', FALSE, 'dzungla', 4, 8, 18); 
INSERT INTO gatunki VALUES ('okapi', 'miedzyzwrotnikowa', 'siano', FALSE, 'dzungla', 3, 4, 1);
INSERT INTO gatunki VALUES ('kangur', 'miedzyzwrotnikowa', 'siano', FALSE, 'sawanna', 3, 7, 19); 
INSERT INTO gatunki VALUES ('hipopotam', 'miedzyzwrotnikowa', 'siano', FALSE, 'afrykarium', 1, 11, 20); 
INSERT INTO gatunki VALUES ('nosorozec', 'miedzyzwrotnikowa', 'siano', FALSE, 'sawanna', 3, 9, 21); 
INSERT INTO gatunki VALUES ('antylopa', 'miedzyzwrotnikowa', 'siano', FALSE, 'sawanna', 2, 6, 1); 
INSERT INTO gatunki VALUES ('rys', 'umiarkowana', 'mieso', TRUE, 'lesny', 8, 4, 22);
INSERT INTO gatunki VALUES ('wilk', 'umiarkowana', 'mieso', TRUE, 'lesny', 10, 6, 23); 
INSERT INTO gatunki VALUES ('hiena', 'miedzyzwrotnikowa', 'mieso', TRUE, 'sawanna', 14, 8, 24); 
INSERT INTO gatunki VALUES ('strus', 'miedzyzwrotnikowa', 'warzywa', FALSE, 'sawanna', 2, 3, 1); 
INSERT INTO gatunki VALUES ('lama', 'umiarkowana', 'warzywa', FALSE, 'trawiasty', 2, 4, 2); 
INSERT INTO gatunki VALUES ('pingwin', 'okolobiegunowa', 'ryby', TRUE, 'arktyczny', 3, 4, 25);
INSERT INTO gatunki VALUES ('wydra', 'umiarkowana', 'ryby', TRUE, 'mokradla', 4, 3, 26); 
INSERT INTO gatunki VALUES ('delfin', 'ocean', 'ryby', TRUE, 'akwarium', 5, 8, 27); 
INSERT INTO gatunki VALUES ('blazenek', 'ocean', 'karma_dla_ryb', FALSE, 'akwarium', 7, 2, 4); 
INSERT INTO gatunki VALUES ('plaszczka', 'ocean', 'skorupiaki', TRUE, 'akwarium', 5, 5, 28); 
INSERT INTO gatunki VALUES ('konik_morski', 'ocean', 'karma_dla_ryb', FALSE, 'akwarium', 4, 3, 4);
INSERT INTO gatunki VALUES ('wegorz_morski', 'ocean', 'skorupiaki', TRUE, 'akwarium', 7, 6, 29); 
INSERT INTO gatunki VALUES ('ukwial', 'ocean', 'karma_dla_ryb', FALSE, 'akwarium', 7, 2, 4); 
INSERT INTO gatunki VALUES ('glonojad', 'ocean', 'karma_dla_ryb', FALSE, 'akwarium', 30, 1, 4); 
INSERT INTO gatunki VALUES ('ptasznik', 'miedzyzwrotnikowa', 'owady', TRUE, 'terrarium', 7, 2, 30); 
INSERT INTO gatunki VALUES ('waran_z_komodo', 'miedzyzwrotnikowa', 'mieso', TRUE, 'afrykarium', 10, 8, 31);
INSERT INTO gatunki VALUES ('myszojelen', 'umiarkowana', 'siano', FALSE, 'lesny', 4, 3, 32);
INSERT INTO gatunki VALUES ('iguana', 'miedzyzwrotnikowa', 'owady', FALSE, 'terrarium', 5, 5, 33);
INSERT INTO gatunki VALUES ('anakonda', 'miedzyzwrotnikowa', 'mieso', TRUE, 'terrarium', 20, 15, 34);
INSERT INTO gatunki VALUES ('boa', 'miedzyzwrotnikowa', 'mieso', TRUE, 'terrarium', 15, 8, 35);
INSERT INTO gatunki VALUES ('grzechotnik', 'miedzyzwrotnikowa', 'mieso', TRUE, 'terrarium', 12, 4, 36);
INSERT INTO gatunki VALUES ('kameleon', 'miedzyzwrotnikowa', 'owady', TRUE, 'terrarium', 3, 5, 37);
INSERT INTO gatunki VALUES ('zolw', 'miedzyzwrotnikowa', 'skorupiaki', FALSE, 'afrykarium', 4, 8, 38);
INSERT INTO gatunki VALUES ('panda_wielka', 'miedzyzwrotnikowa', 'owoce', FALSE, 'dzungla', 1, 5, 39);
INSERT INTO gatunki VALUES ('koala', 'miedzyzwrotnikowa', 'owoce', FALSE, 'dzungla', 1, 3, 40);
INSERT INTO gatunki VALUES ('leniwiec', 'miedzyzwrotnikowa', 'owoce', FALSE, 'dzungla', 1, 4, 41);
INSERT INTO gatunki VALUES ('panda_mala', 'miedzyzwrotnikowa', 'owoce', FALSE, 'dzungla', 3, 3, 42);
INSERT INTO gatunki VALUES ('kapibara', 'miedzyzwrotnikowa', 'owoce', FALSE, 'dzungla', 4, 7, 43);
INSERT INTO gatunki VALUES ('surykatka', 'miedzyzwrotnikowa', 'warzywa', FALSE, 'sawanna', 5, 3, 44);
INSERT INTO gatunki VALUES ('dziobak', 'umiarkowana', 'skorupiaki', FALSE, 'mokradla', 3, 6, 45);
INSERT INTO gatunki VALUES ('kozica', 'umiarkowana', 'siano', FALSE, 'gorski', 3, 4, 46);
INSERT INTO gatunki VALUES ('papuga', 'miedzyzwrotnikowa', 'owoce', FALSE, 'ptaszarnia', 3, 2, 47);
