/*
1. Kreirati bazu podataka koju æete imenovati Vašim brojem dosijea. */

CREATE DATABASE EmirSahovic
GO

USE EmirSahovic
GO

/*2.
. U bazi podataka kreirati sljedeæe tabele:
a. Kandidati
- Ime, polje za unos 30 karaktera (obavezan unos),
- Prezime, polje za unos 30 karaktera (obavezan unos),
- JMBG, polje za unos 13 karaktera (obavezan unos i jedinstvena vrijednost),
- DatumRodjenja, polje za unos datuma (obavezan unos),
- MjestoRodjenja, polje za unos 30 karaktera,
- Telefon, polje za unos 20 karaktera,
- Email, polje za unos 50 karaktera (jedinstvena vrijednost).
b. Testovi
- Datum, polje za unos datuma i vremena (obavezan unos),
- Naziv, polje za unos 50 karaktera (obavezan unos),
- Oznaka, polje za unos 10 karaktera (obavezan unos i jedinstvena vrijednost),
- Oblast, polje za unos 50 karaktera (obavezan unos),
- MaxBrojBodova, polje za unos cijelog broja (obavezan unos),
- Opis, polje za unos 250 karaktera.
c. RezultatiTesta
- Polozio, polje za unos ishoda testiranja – DA/NE (obavezan unos)
- OsvojeniBodovi, polje za unos decimalnog broja (obavezan unos),
- Napomena, polje za unos dužeg niza karaktera.
Napomena: Kandidat može da polaže više testova i za svaki test ostvari odreðene rezultate, pri èemu kandidat ne
može dva puta polagati isti test. Takoðer, isti test može polagati više kandidata
*/

CREATE TABLE Kandidati
(
KandidatID int CONSTRAINT PK_Kandidati PRIMARY KEY IDENTITY(1,1),
Ime nvarchar(30) NOT NULL,
Prezime nvarchar(30) NOT NULL,
JMBG nvarchar(13) NOT NULL CONSTRAINT UQ_JMBG UNIQUE,
DatumRodjenja date NOT NULL,
MjestoRodjenja nvarchar(30),
Telefon nvarchar(20),
Email nvarchar(50) CONSTRAINT UQ_Emial UNIQUE
)

CREATE TABLE Testovi
(
TestID int CONSTRAINT PK_Testovi PRIMARY KEY IDENTITY(1,1),
Datum datetime NOT NULL,
Naziv nvarchar(50) NOT NULL,
Oznaka nvarchar(10) NOT NULL CONSTRAINT UQ_Oznaka UNIQUE,
Oblast nvarchar(50) NOT NULL,
MaxBrojBodova int NOT NULL,
Opis nvarchar(250)
)

CREATE TABLE RezultatiTesta
(
KandidatID int CONSTRAINT FK_RezultatiTesta_Kandidati FOREIGN KEY(KandidatID) REFERENCES Kandidati(KandidatID),
TestID int CONSTRAINT FK_RezultatiTesta_Testovi FOREIGN KEY(TestID) REFERENCES Testovi(TestID),
CONSTRAINT PK_RezultatiTesta PRIMARY KEY(KandidatID, TestID),
Polozio bit NOT NULL,
OsvojeniBodovi decimal(8,2) NOT NULL,
Napomena text
)

/*3.
Koristeæi AdventureWorks2014 bazu podataka, importovati 10 kupaca u tabelu Kandidati i to sljedeæe
kolone:
a. FirstName (Person) -> Ime,
b. LastName (Person) -> Prezime,
c. Zadnjih 13 karaktera kolone rowguid iz tabele Customer (Crticu zamijeniti brojem 0) -> JMBG,
d. ModifiedDate (Customer) -> DatumRodjenja,
e. City (Address) -> MjestoRodjenja,
f. PhoneNumber (PersonPhone) -> Telefon,
g. EmailAddress (EmailAddress) -> Email.
Takoðer, u tabelu Testovi unijeti minimalno tri testa sa proizvoljnim podacima.
*/

SELECT *
FROM AdventureWorks2014.Sales.Customer

INSERT INTO Kandidati(Ime, Prezime, JMBG, DatumRodjenja, MjestoRodjenja, Telefon, Email)
SELECT TOP 10 
       PP.FirstName, PP.LastName, 
       REPLACE(RIGHT(SC.rowguid, 13), '-', '0'),
       SC.ModifiedDate,
	   PA.City,
	   PPP.PhoneNumber,
	   PEA.EmailAddress
FROM AdventureWorks2014.Person.Person as PP INNER JOIN AdventureWorks2014.Sales.Customer as SC
ON SC.PersonID = PP.BusinessEntityID INNER JOIN AdventureWorks2014.Person.BusinessEntityAddress as BEA
ON PP.BusinessEntityID = BEA.BusinessEntityID INNER JOIN AdventureWorks2014.Person.Address as PA
ON PA.AddressID = BEA.AddressID INNER JOIN AdventureWorks2014.Person.PersonPhone as PPP
ON PP.BusinessEntityID = PPP.BusinessEntityID INNER JOIN AdventureWorks2014.Person.EmailAddress as PEA
ON PP.BusinessEntityID = PEA.BusinessEntityID

INSERT INTO Testovi(Datum, Naziv, Oznaka, Oblast, MaxBrojBodova)
VALUES ('20150613','Programiranje I','PRI','Programiranje',100),
	   ('20150613','Programiranje II','PRII','Programiranje',100),
	   ('20150613','Programiranje III','PRIII','Programiranje',100)
GO

/*4.
Kreirati stored proceduru koja æe na osnovu proslijeðenih parametara služiti za unos podataka u tabelu
RezultatiTesta. Proceduru pohraniti pod nazivom usp_RezultatiTesta_Insert. Obavezno testirati ispravnost
kreirane procedure (unijeti proizvoljno minimalno 10 rezultata za razlièite testove).
*/

CREATE PROCEDURE proc_4
(
@KandidatID int,
@TestID int,
@Polozio bit,
@OsvojeniBodovi decimal(8,2),
@Napomena text
)
AS
BEGIN
INSERT INTO RezultatiTesta(KandidatID, TestID, Polozio, OsvojeniBodovi, Napomena)
VALUES(@KandidatID, @TestID, @Polozio, @OsvojeniBodovi, @Napomena)
END

SELECT * FROM Kandidati
SELECT * FROM Testovi

EXEC proc_4 18509, 1, 1, 75, 'Odlièno'
EXEC proc_4 18510, 2, 0, 33, 'Nedovoljno'
EXEC proc_4 18511, 1, 1, 90, 'Odlièno'
EXEC proc_4 18512, 3, 0, 20, 'Nedovoljno'
EXEC proc_4 18513, 1, 0, 15, 'Nedovoljno'
EXEC proc_4 18514, 2, 1, 60, 'Odlièno'
EXEC proc_4 18515, 3, 0, 12, 'Nedovoljno'
EXEC proc_4 18516, 2, 1, 100, 'Odlièno'
EXEC proc_4 18517, 1, 1, 87, 'Odlièno'
EXEC proc_4 18518, 3, 0, 5, 'Nedovoljno'

SELECT * FROM RezultatiTesta

/*5.
Kreirati view (pogled) nad podacima koji æe sadržavati sljedeæa polja: ime i prezime, jmbg, telefon i email
kandidata, zatim datum, naziv, oznaku, oblast i max. broj bodova na testu, te polje položio, osvojene bodove i
procentualni rezultat testa. View pohranite pod nazivom view_Rezultati_Testiranja
*/

CREATE VIEW view_5
AS
SELECT K.Ime + ' ' + K.Prezime as 'Ime i prezime',
       K.JMBG,
	   K.Telefon,
	   K.Email,
	   T.Datum,
	   T.Naziv,
	   T.Oznaka,
	   T.Oblast,
	   T.MaxBrojBodova,
	   RT.Polozio,
	   RT.OsvojeniBodovi,
	   FLOOR((RT.OsvojeniBodovi / T.MaxBrojBodova) * 100) as ProcentualniRezultat
FROM Kandidati as K INNER JOIN RezultatiTesta as RT
ON K.KandidatID = RT.KandidatID INNER JOIN Testovi as T
ON RT.TestID = T.TestID

SELECT * FROM view_5

/*6.
Kreirati stored proceduru koja æe na osnovu proslijeðenih parametara @OznakaTesta i @Polozio prikazivati
rezultate testiranja. Kao izvor podataka koristiti prethodno kreirani view. Proceduru pohraniti pod nazivom
usp_RezultatiTesta_SelectByOznaka. Obavezno testirati ispravnost kreirane procedure
*/

ALTER PROCEDURE proc_6
(
@OznakaTesta nvarchar(10),
@Polozio bit
)
AS
BEGIN
SELECT *
FROM view_5
WHERE Oznaka = @OznakaTesta AND Polozio = @Polozio 
END

EXEC proc_6 'PRI', 0

/*7.
 Kreirati proceduru koja æe služiti za izmjenu rezultata testiranja. Proceduru pohraniti pod nazivom
usp_RezultatiTesta_Update. Obavezno testirati ispravnost kreirane procedure
*/

CREATE PROCEDURE usp_RezultatiTesta_Update
(
    @TestID INT,
    @kandidatID INT,
    @Polozio BIT,
    @OsvBodovi DECIMAL(8,2),
    @Napomena TEXT
)
AS
BEGIN
    UPDATE RezultatiTesta
    SET 
        Polozio = @Polozio,
        OsvojeniBodovi = @OsvBodovi,
        Napomena = @Napomena
    WHERE TestID = @TestID AND 
          KandidatID = @kandidatID
END

SELECT * FROM RezultatiTesta

EXEC usp_RezultatiTesta_Update 1, 18509, 1, 55, 'X'
GO
/*8.
Kreirati stored proceduru koja æe služiti za brisanje testova zajedno sa svim rezultatima testiranja. Proceduru
pohranite pod nazivom usp_Testovi_Delete. Obavezno testirati ispravnost kreirane procedure.
*/

CREATE PROCEDURE proc_delete
(
@TestID int
)
AS
BEGIN
DELETE FROM RezultatiTesta
WHERE TestID IN (
                 SELECT TestID
				 FROM Testovi
				 WHERE TestID = @TestID)
DELETE FROM Testovi
WHERE TestID = @TestID
END

EXEC proc_delete 2

/*9.
Kreirati trigger koji æe sprijeèiti brisanje rezultata testiranja. Obavezno testirati ispravnost kreiranog triggera.
*/
GO
CREATE TRIGGER tr_delete_rezTest
ON RezultatiTesta
INSTEAD OF DELETE
AS
PRINT 'Nemoguæe brisanje'
ROLLBACK

DELETE FROM RezultatiTesta
WHERE TestID = 1

/*10. Uraditi full backup Vaše baze podataka na lokaciju D:\DBMS\Backup*/

BACKUP DATABASE EmirSahovic
TO DISK = 'D:\DBMS\Backup\EmirSahovic.bak'