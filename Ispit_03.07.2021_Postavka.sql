/* Ispit iz Naprednih baza podataka 03.07.2021.godine*/

/*
	1. Kreiranje nove baze podataka kroz SQL kod, sa default postavkama servera  (5)
*/





/*
	2a. Kreiranje tabela i unošenje testnih podataka (10)

	Unutar svoje baze podataka kreirati tabele sa slijedećom strukturom:

Pacijenti
	PacijentID, automatski generator neparnih vrijednosti - primarni ključ
	JMB, polje za unos 13 UNICODE karaktera (obavezan unos) - jedinstvena vrijednost
	Prezime, polje za unos 50 UNICODE karaktera (obavezan unos)
	Ime, polje za unos 50 UNICODE karaktera (obavezan unos)
	DatumRodjenja, polje za unos datuma, DEFAULT je NULL
	DatumKreiranja, polje za unos datuma dodavanja zapisa (obavezan unos) DEFAULT je datum unosa
	DatumModifikovanja, polje za unos datuma izmjene originalnog zapisa , DEFAULT je NULL

Titule
	TitulaID, automatski generator vrijednosti - primarni ključ
	Naziv, polje za unos 100 UNICODE karaktera (obavezan unos)
	DatumKreiranja, polje za unos datuma dodavanja zapisa (obavezan unos) DEFAULT je datum unosa
	DatumModifikovanja, polje za unos datuma izmjene originalnog zapisa , DEFAULT je NULL

Osoblje (Jednu titulu može imati više osoba)
	OsobljeID, automatski generator vrijednosti i primarni kljuè
	Prezime, polje za unos 50 UNICODE karaktera (obavezan unos)
	Ime, polje za unos 50 UNICODE karaktera (obavezan unos)
	DatumKreiranja, polje za unos datuma dodavanja zapisa (obavezan unos) DEFAULT je datum unosa
	DatumModifikovanja, polje za unos datuma izmjene originalnog zapisa , DEFAULT je NULL

Pregledi (Pacijent može izvršiti samo jedan pregled kod istog doktora unutar termina)
	PregledID, polje za unos cijelih brojeva (obavezan unos)
	DatumPregleda, polje za unos datuma (obavezan unos) DEFAULT je datum unosa
	Dijagnoza polje za unos 1000 UNICODE karaktera (obavezan unos)
*/





/*
		2b. Izmjena tabele "Pregledi" (5)

Modifikovati tabelu Pregledi i dodati dvije kolone:
DatumKreiranja, polje za unos datuma dodavanja zapisa (obavezan unos) DEFAULT je datum unosa
DatumModifikovanja, polje za unos datuma izmjene originalnog zapisa , DEFAULT je NULL
*/





/*
		2c. Unošenje testnih podataka (10)

Iz baze podataka Northwind, a putem podupita dodati sve zapise iz tabele Employees:
(LastName, FirstName, BirthDate) u tabelu Pacijenti. Za JMB koristiti SQL funkciju koja
generiše slučajne i jedinstvene ID vrijednosti. Obavezno testirati da li su podaci u tabeli.

U tabelu Titule, jednom komandom, dodati: Stomatolog, Oftalmolog, Ginekolog,
Pulmolog i Onkolog. Obavezno testirati da li su podaci u tabeli.

U tabelu Osoblje, jednom komandom, dodati proizvoljna dva zapisa. 
Obavezno testirati da li su podaci u tabeli.

*/





/*
	2d. Kreirati uskladištenu proceduru (10) 

U tabelu Pregledi dodati 4 zapisa proizvoljnog karaktera. Obavezno testirati da li su podaci u tabeli.
*/




/*
	3. Kreiranje procedure za izmjenu podataka u tabeli "Pregledi" (10)

Koja će izvršiti izmjenu podataka u tabeli Pregledi, tako što će modifikovati dijagnoza za određeni pregled. 
Također, potrebno je izmjeniti vrijednost još jednog atributa u tabeli kako bi zapis o poslovnom procesu
bio potpun. Obavezno testirati da li su podaci u tabeli modifikovani
*/




/*
	4. Kreiranje pogleda (5)

Kreirati pogled sa slijedećom definicijom: Prezime i ime pacijenta, datum pregleda, titulu, prezime i ime
doktora, dijagnozu i datum zadnje izmjene zapisa, ali samo onim pacijentima kojima je modfikovana
dijagnoza. Obavezno testirati funkcionalnost view objekta.

*/

/* GRANICA ZA OCJENU 6 (55 bodova) */



/*
	5. Prilagodjavanje tabele "Pacijenti" (5)

Modifikovati tabelu Pacijenti i dodati slijedeće tri kolone:
	Email, polje za unos 100 UNICODE karaktera, DEFAULT je NULL
	Lozinka, polje za unos 100 UNICODE karaktera, DEFAULT je NULL
	Telefon, polje za unos 100 UNICODE karaktera, DEFAULT je NUL
*/




/*
	6. Dodavanje dodatnih zapisa u tabelu "Pacijenti" (5)

Kreirati uskladištenu proceduru koja će iz baze podataka AdventureWorks i tabela:
Person.Person, HumanResources.Employee, Person.Password, Person.EmailAddress i
Person.PersonPhone mapirati odgovarajuće kolone i prebaciti sve zapise u tabelu Pacijenti.
Obavezno testirati da li su podaci u tabeli

*/





/*
	7. Izmjena podataka u tabel "Pacijenti" (10)

Kreirati uskladištenu proceduru koja će u vašoj bazi podataka, svim pacijentima generisati novu email
adresu u formatu: Ime.Prezime@size.ba, lozinku od 12 karaktera putem SQL funkciju koja generiše
slučajne i jedinstvene ID vrijednosti i podatak da je postojeći zapis u tabeli modifikovan.
*/



/*
	8. Kriranje upita i indeksa (5)

Napisati upit koji prikazuje prezime i ime pacijenta, datum pregleda, dijagnozu i spojene podatke o
doktoru (titula, prezime i ime doktora). U obzir dolaze samo oni pacijenti koji imaju dijagnozu ili čija
email adresa počinje sa slovom „L“. 
Nakon toga kreirati indeks koji će prethodni upit, prema vašem mišljenju, maksimalno ubrzati
*/



/*
	9. Brisanje pacijenata bez pregleda (5)

Kreirati uskladištenu proceduru koja briše sve pacijente koji nemaju realizovan niti jedan pregled.
Obavezno testirati funkcionalnost procedure. 
*/




/*
	10a. Backup baze podataka (5)
Kreirati backup vaše baze na default lokaciju servera	
*/



/*
	10b. Brisanje svih zapisa iz tabela (5)
Kreirati proceduru koja briše sve zapise iz svih tabela unutar jednog izvršenja. Testirati da li su podaci
obrisani	
*/




/*
	10c. Restore baze podataka (5)
Uraditi restore rezervene kopije baze podataka 
*/