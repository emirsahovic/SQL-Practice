/* Ispit iz Naprednih baza podataka 03.07.2021.godine*/

/*
	1. Kreiranje nove baze podataka kroz SQL kod, sa default postavkama servera  (5)
*/

CREATE DATABASE _108v1
GO

USE _108v1
GO

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

CREATE TABLE Pacijenti
(
    PacijentID int CONSTRAINT PK_Pacijenti PRIMARY KEY IDENTITY(1, 2),
    JMB nvarchar(13) NOT NULL CONSTRAINT UQ_JMB UNIQUE,
    Prezime nvarchar(50) NOT NULL,
    Ime nvarchar(50) NOT NULL,
    DatumRodjenja date DEFAULT NULL,
    DatumKreiranja date NOT NULL DEFAULT GETDATE(),
    DatumModifikovanja date DEFAULT NULL
)

CREATE TABLE Titule
(
    TitulaID int CONSTRAINT PK_Titule PRIMARY KEY IDENTITY(1,1),
    Naziv nvarchar(100) NOT NULL,
    DatumKreiranja date NOT NULL DEFAULT GETDATE(),
    DatumModifikovanja date DEFAULT NULl
)

CREATE TABLE Osoblje
(
    OsobljeID int CONSTRAINT PK_Osoblje PRIMARY KEY IDENTITY(1,1),
    TitulaID int CONSTRAINT FK_Osoblje_Titule FOREIGN KEY(TitulaID) REFERENCES Titule(TitulaID),
    Prezime nvarchar(50) NOT NULL,
    Ime nvarchar(50) NOT NULL,
    DatumKreiranja date NOT NULL DEFAULT GETDATE(),
    DatumModifikovanja date DEFAULT NULL
)

CREATE TABLE Pregledi
(
    PregledID int NOT NULL,
    DatumPregleda date NOT NULL DEFAULT GETDATE(),
    PacijentID int CONSTRAINT FK_Pregledi_Pacijenti FOREIGN KEY(PacijentID) REFERENCES Pacijenti(PacijentID),
    OsobljeID int CONSTRAINT FK_Pregledi_Osoblje FOREIGN KEY(OsobljeID) REFERENCES Osoblje(OsobljeID),
    Dijagnoza nvarchar(1000) NOT NULL,
    CONSTRAINT PK_Pregledi PRIMARY KEY(PregledID, DatumPregleda)
)

/*
		2b. Izmjena tabele "Pregledi" (5)

Modifikovati tabelu Pregledi i dodati dvije kolone:
DatumKreiranja, polje za unos datuma dodavanja zapisa (obavezan unos) DEFAULT je datum unosa
DatumModifikovanja, polje za unos datuma izmjene originalnog zapisa , DEFAULT je NULL
*/

ALTER TABLE Pregledi
ADD DatumKreiranja date NOT NULL DEFAULT GETDATE()

ALTER TABLE Pregledi
ADD DatumModifikovanja date DEFAULT NULL

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

INSERT INTO Pacijenti
    (JMB, Prezime, Ime, DatumRodjenja)
SELECT P.JMB, P.LastName, P.FirstName, P.BirthDate
FROM
    (SELECT LEFT(NEWID(), 13) as JMB, LastName, FirstName, BirthDate
    FROM NORTHWND.dbo.Employees) as P

SELECT *
FROM Pacijenti

INSERT INTO Titule
    (Naziv)
VALUES
    ('Stomatolog'),
    ('Oftalmolog'),
    ('Ginekolog'),
    ('Pulmolog'),
    ('Onkolog')

SELECT *
FROM Titule

INSERT INTO Osoblje
    (TitulaID, Prezime, Ime)
VALUES
    (1, 'Spahić', 'Amel'),
    (2, 'Azemović', 'Jasmin')

SELECT *
FROM Osoblje

/*
	2d. Kreirati uskladištenu proceduru (10) 

U tabelu Pregledi dodati 4 zapisa proizvoljnog karaktera. Obavezno testirati da li su podaci u tabeli.
*/
GO
CREATE PROCEDURE proc_2d
AS
BEGIN
    INSERT INTO Pregledi
        (PregledID, DatumPregleda, PacijentID, OsobljeID, Dijagnoza)
    VALUES
        (1, '2021-07-03', 1, 1, 'Upaljen kutnjak'),
        (2, '2021-05-23', 3, 2, 'Mrena'),
        (3, '2021-06-13', 5, 1, 'Karijes'),
        (4, '2021-04-05', 7, 2, 'Astigmatizam')
END

EXEC proc_2d

SELECT *
FROM Pregledi

/*
	3. Kreiranje procedure za izmjenu podataka u tabeli "Pregledi" (10)

Koja će izvršiti izmjenu podataka u tabeli Pregledi, tako što će modifikovati dijagnoza za određeni pregled. 
Također, potrebno je izmjeniti vrijednost još jednog atributa u tabeli kako bi zapis o poslovnom procesu
bio potpun. Obavezno testirati da li su podaci u tabeli modifikovani
*/
GO
CREATE PROCEDURE proc_3
(
    @PregledID int,
    @DatumPregleda date,
    @Dijagnoza nvarchar(1000)
)
AS
BEGIN
UPDATE Pregledi
SET Dijagnoza = @Dijagnoza,
    DatumModifikovanja = GETDATE()
WHERE PregledID = @PregledID AND DatumPregleda = @DatumPregleda
END

EXEC proc_3 1, '2021-07-03', 'Kvar zuba'

SELECT *
FROM Pregledi

/*
	4. Kreiranje pogleda (5)

Kreirati pogled sa slijedećom definicijom: Prezime i ime pacijenta, datum pregleda, titulu, prezime i ime
doktora, dijagnozu i datum zadnje izmjene zapisa, ali samo onim pacijentima kojima je modfikovana
dijagnoza. Obavezno testirati funkcionalnost view objekta.
*/
GO
CREATE VIEW view_4
AS
    SELECT P.Prezime as [Prezime pacijenta], P.Ime as [Ime pacijenta], PR.DatumPregleda, T.Naziv, O.Prezime, O.Ime, PR.Dijagnoza, PR.DatumModifikovanja
    FROM Pacijenti as P INNER JOIN Pregledi as PR
        ON P.PacijentID = PR.PacijentID INNER JOIN Osoblje as O
        ON PR.OsobljeID = O.OsobljeID INNER JOIN Titule as T
        ON O.TitulaID = T.TitulaID
    WHERE PR.DatumModifikovanja IS NOT NULL
GO
/* GRANICA ZA OCJENU 6 (55 bodova) */

/*
	5. Prilagodjavanje tabele "Pacijenti" (5)

Modifikovati tabelu Pacijenti i dodati slijedeće tri kolone:
	Email, polje za unos 100 UNICODE karaktera, DEFAULT je NULL
	Lozinka, polje za unos 100 UNICODE karaktera, DEFAULT je NULL
	Telefon, polje za unos 100 UNICODE karaktera, DEFAULT je NUL
*/

ALTER TABLE Pacijenti
ADD Email nvarchar(100) DEFAULT NULL

ALTER TABLE Pacijenti
ADD Lozinka nvarchar(100) DEFAULT NULL

ALTER TABLE Pacijenti
ADD Telefon nvarchar(100) DEFAULT NULL

/*
	6. Dodavanje dodatnih zapisa u tabelu "Pacijenti" (5)

Kreirati uskladištenu proceduru koja će iz baze podataka AdventureWorks i tabela:
Person.Person, HumanResources.Employee, Person.Password, Person.EmailAddress i
Person.PersonPhone mapirati odgovarajuće kolone i prebaciti sve zapise u tabelu Pacijenti.
Obavezno testirati da li su podaci u tabeli

*/
GO
CREATE PROCEDURE proc_6
AS
BEGIN
    INSERT INTO Pacijenti
        (JMB, Prezime, Ime, DatumRodjenja, Email, Lozinka, Telefon)
    SELECT LEFT(HRE.rowguid, 13), PP.LastName, PP.FirstName, HRE.BirthDate, PEA.EmailAddress,
        PW.PasswordHash, PH.PhoneNumber
    FROM AdventureWorks2014.HumanResources.Employee as HRE INNER JOIN AdventureWorks2014.Person.Person as PP
        ON HRE.BusinessEntityID = PP.BusinessEntityID INNER JOIN AdventureWorks2014.Person.[Password] as PW
        ON PP.BusinessEntityID = PW.BusinessEntityID INNER JOIN AdventureWorks2014.Person.EmailAddress as PEA
        ON PP.BusinessEntityID = PEA.BusinessEntityID INNER JOIN AdventureWorks2014.Person.PersonPhone as PH
        ON PP.BusinessEntityID = PH.BusinessEntityID
END

EXEC proc_6

SELECT *
FROM Pacijenti

/*
	7. Izmjena podataka u tabel "Pacijenti" (10)

Kreirati uskladištenu proceduru koja će u vašoj bazi podataka, svim pacijentima generisati novu email
adresu u formatu: Ime.Prezime@size.ba, lozinku od 12 karaktera putem SQL funkciju koja generiše
slučajne i jedinstvene ID vrijednosti i podatak da je postojeći zapis u tabeli modifikovan.
*/
GO
CREATE PROCEDURE proc_7
AS
BEGIN
UPDATE Pacijenti
SET Email = Ime + '.' + Prezime + '@size.ba',
    Lozinka = LEFT(NEWID(), 12),
    DatumModifikovanja = GETDATE()
END

EXEC proc_7

/*
	8. Kriranje upita i indeksa (5)

Napisati upit koji prikazuje prezime i ime pacijenta, datum pregleda, dijagnozu i spojene podatke o
doktoru (titula, prezime i ime doktora). U obzir dolaze samo oni pacijenti koji imaju dijagnozu ili čija
email adresa počinje sa slovom „L“. 
Nakon toga kreirati indeks koji će prethodni upit, prema vašem mišljenju, maksimalno ubrzati
*/

SELECT *
FROM Pregledi
SELECT *
FROM Pacijenti

SELECT P.Prezime + ' ' + P.Ime as 'Prezime i ime', PR.DatumPregleda, PR.Dijagnoza,
    T.Naziv + ' ' + O.Prezime + ' ' + O.Ime as 'Podaci o doktoru'
FROM Pacijenti as P INNER JOIN Pregledi as PR
    ON P.PacijentID = PR.PacijentID INNER JOIN Osoblje as O
    ON PR.OsobljeID = O.OsobljeID INNER JOIN Titule as T
    ON O.TitulaID = T.TitulaID
WHERE P.PacijentID IN (SELECT PacijentID
                       FROM Pregledi) OR P.Email LIKE 'L%'

/*
	9. Brisanje pacijenata bez pregleda (5)

Kreirati uskladištenu proceduru koja briše sve pacijente koji nemaju realizovan niti jedan pregled.
Obavezno testirati funkcionalnost procedure. 
*/
GO
CREATE PROCEDURE proc_9
AS
BEGIN
DELETE FROM Pacijenti
WHERE PacijentID NOT IN (SELECT PacijentID
                         FROM Pregledi)
END

EXEC proc_9

SELECT *
FROM Pacijenti

/*
	10a. Backup baze podataka (5)
Kreirati backup vaše baze na default lokaciju servera	
*/

BACKUP DATABASE _108v1
TO DISK = 'e108v1.bak'

/*
	10b. Brisanje svih zapisa iz tabela (5)
Kreirati proceduru koja briše sve zapise iz svih tabela unutar jednog izvršenja. Testirati da li su podaci
obrisani	
*/
GO
CREATE PROCEDURE proc_10b
AS
BEGIN
    ALTER TABLE Osoblje
DROP CONSTRAINT FK_Osoblje_Titule

    ALTER TABLE Pregledi
DROP CONSTRAINT FK_Pregledi_Pacijenti

    ALTER TABLE Pregledi
DROP CONSTRAINT FK_Pregledi_Osoblje

    DELETE FROM Pacijenti
    DELETE FROM Titule
    DELETE FROM Osoblje
    DELETE FROM Pregledi
END

EXEC proc_10b

/*
	10c. Restore baze podataka (5)
Uraditi restore rezervene kopije baze podataka 
*/
GO

USE master
GO

ALTER DATABASE _108v1
SET OFFLINE

DROP DATABASE _108v1
GO

RESTORE DATABASE _108v1 
FROM DISK = 'e108.bak'
WITH REPLACE