/* 1. Kreirati bazu podataka pod nazivom: BrojDosijea (npr. 2046) bez posebnog kreiranja data i log fajla.*/

CREATE DATABASE EmirSahovic
GO

USE EmirSahovic
GO

/*2.
U vašoj bazi podataka keirati tabele sa sljede�im parametrima:
- Kupci
	- KupacID, automatski generator vrijednosti i primarni ključ
 	- Ime, polje za unos 35 UNICODE karaktera (obavezan unos),
	- Prezime, polje za unos 35 UNICODE karaktera (obavezan unos),
	- Telefon, polje za unos 15 karaktera (nije obavezan),
	- Email, polje za unos 50 karaktera (nije obavezan),
	- KorisnickoIme, polje za unos 15 karaktera (obavezan unos) jedinstvena vrijednost,
	- Lozinka, polje za unos 15 karaktera (obavezan unos)
- Proizvodi
	- ProizvodID, automatski generator vrijednosti i primarni ključ
	- Sifra, polje za unos 25 karaktera (obavezan unos)
	- Naziv, polje za unos 50 UNICODE karaktera (obavezan unos)
	- Cijena, polje za unos decimalnog broj (obavezan unos)
	- Zaliha, polje za unos cijelog broja (obavezan unos)
- Narudzbe 
 	- NarudzbaID, automatski generator vrijednosti i primarni ključ
 	- KupacID, spoljni ključ prema tabeli Kupci,
	- ProizvodID, spoljni ključ prema tabeli Proizvodi,
	- Kolicina, polje za unos cijelog broja (obavezan unos)
	- Popust, polje za unos decimalnog broj (obavezan unos), DEFAULT JE 0
*/

CREATE TABLE Kupci
(
KupacID int CONSTRAINT PK_Kupci PRIMARY KEY IDENTITY(1,1),
Ime nvarchar(35) NOT NULL,
Prezime nvarchar(35) NOT NULL,
Telefon nvarchar(15),
Email nvarchar(50),
KorisnickoIme nvarchar(15) NOT NULL CONSTRAINT UQ_KorisnickoIme UNIQUE,
Lozinka nvarchar(15) NOT NULL
)

CREATE TABLE Proizvodi
(
ProizvodID int CONSTRAINT PK_Proizvodi PRIMARY KEY IDENTITY(1,1),
Sifra nvarchar(25) NOT NULL,
Naziv nvarchar(50) NOT NULL,
Cijena decimal(8,2) NOT NULL,
Zaliha int NOT NULL
)

CREATE TABLE Narudzbe
(
NarudzbaID int CONSTRAINT PK_Narudzbe PRIMARY KEY IDENTITY(1,1),
KupacID int CONSTRAINT FK_Narudzbe_Kupci FOREIGN KEY(KupacID) REFERENCES Kupci(KupacID),
ProizvodID int CONSTRAINT FK_Narudzbe_Proizvodi FOREIGN KEY(ProizvodID) REFERENCES Proizvodi(ProizvodID),
Kolicina int NOT NULL,
Popust decimal(8,2) NOT NULL DEFAULT(0)
)

/*3.
 Modifikovati tabele Proizvodi i Narudzbe i to sljedeca polja:
	- Zaliha (tabela Proizvodi) - omoguciti unos decimalnog broja
	- Kolicina (tabela Narudzbe) - omoguciti unos decimalnog broja
*/

ALTER TABLE Proizvodi
ALTER COLUMN Zaliha decimal(8,2)

ALTER TABLE Narudzbe
ALTER COLUMN Kolicina decimal(8,2)

/*4.
Koristeci bazu podataka AdventureWorksLT 2012 i tabelu SalesLT.Customer, preko INSERT I SELECT komande importovati 10 zapisa
u tabelu Kupci i to sljedece kolone:
	- FirstName -> Ime
	- LastName -> Prezime
	- Phone -> Telefon
	- EmailAddress -> Email
	- Sve do znaka '@' u koloni EmailAddress -> KorisnickoIme
	- Prvih 8 karaktera iz kolone PasswordHash -> Lozinka
*/

INSERT INTO Kupci(Ime, Prezime, Telefon, Email, KorisnickoIme, Lozinka)
SELECT TOP 10 FirstName, LastName, Phone, EmailAddress, SUBSTRING(EmailAddress, 0, CHARINDEX('@', EmailAddress)), LEFT(PasswordHash, 8)
FROM AdventureWorksLT2014.SalesLT.Customer

SELECT * FROM Kupci

/*5.
Koristeci bazu podataka AdventureWorksLT2012 i tabelu SalesLT.Product importovati u temp tabelu po
nazivom tempBrojDosijea (npr. temp2046) 5 proizvoda i to sljedece kolone:
	
	- ProductName -> Sifra
	- Name -> Naziv
	- StandardCost -> Cijena
*/

SELECT TOP 5 ProductNumber, Name, StandardCost
INTO #tempEmirSahovic
FROM AdventureWorksLT2014.SalesLT.Product

/*6.
. U vašoj bazi podataka kreirajte stored proceduru koja ce raditi INSERT podataka u tabelu Narudzbe. 
Podaci se moraju unijeti preko parametara. Takoder , u proceduru dodati ažuriranje (UPDATE) polja 'Zaliha' (tabela Proizvodi) u 
zavisnosti od prosljeđene količine. Proceduru pohranite pod nazivom usp_Narudzbe_Insert.
*/
GO
CREATE PROCEDURE proc_6
(
@KupacID int,
@ProizvodID int,
@Kolicina decimal(8,2),
@Popust decimal(8,2)
)
AS
BEGIN
INSERT INTO Narudzbe(KupacID, ProizvodID, Kolicina, Popust)
VALUES (@KupacID, @ProizvodID, @Kolicina, @Popust)

UPDATE Proizvodi
SET Zaliha = Zaliha + @Kolicina
WHERE ProizvodID = @ProizvodID
END

INSERT INTO Proizvodi
SELECT ProductNumber, Name, StandardCost, 100
FROM #tempEmirSahovic

SELECT * FROM Proizvodi
SELECT * FROM Kupci
SELECT * FROM #tempEmirSahovic

/*7.
 Koristeći proceduru koju ste kreirali u prethodnom zadatku kreirati 5 narudžbi.
*/

EXEC proc_6 56, 1, 5, 0.15
EXEC proc_6 57, 2, 3, 0.05
EXEC proc_6 58, 4, 7, 0.10
EXEC proc_6 59, 3, 10, 0
EXEC proc_6 60, 5, 5, 0.10

SELECT * FROM Narudzbe

/*8.
 U vašoj bazi podataka kreirajte view koji će sadržavati sljedeca polja: ime kupca, prezime kupca, telefon, 
 šifra proizvoda, naziv proizvoda, cijena, kolicina, te ukupno. View pohranite pod nazivom view_Kupci_Narudzbe.
*/

CREATE VIEW view_8
AS
SELECT K.Ime, K.Prezime, K.Telefon, P.Sifra, P.Naziv, P.Cijena, N.Kolicina, 
       SUM((N.Kolicina * P.Cijena) * (1 - N.Popust)) as ukupno
FROM Kupci as K INNER JOIN Narudzbe as N
ON K.KupacID = N.KupacID INNER JOIN Proizvodi as P
ON P.ProizvodID = N.ProizvodID
GROUP BY K.Ime, K.Prezime, K.Telefon, P.Sifra, P.Naziv, P.Cijena, N.Kolicina

SELECT * FROM view_8

/*9.
. U vašoj bazi podataka kreirajte stored proceduru koja ce na osnovu proslijedenog imena ili 
prezimena kupca (jedan parametar) kao rezultat vratiti sve njegove narudžbe. 
Kao izvor podataka koristite view kreiran u zadatku 8. Proceduru pohranite pod nazivom usp_Kupci_Narudzbe.
*/
GO
ALTER PROCEDURE proc_9
(
@Ime nvarchar(35) = NULL,
@Prezime nvarchar(35) = NULL
)
AS
BEGIN
SELECT *
FROM view_8
WHERE (Ime = @Ime OR @Ime IS NULL) AND (Prezime = @Prezime OR @Prezime IS NULL)
END

EXEC proc_9 @Prezime = 'Gates'

/*10.
. U vašoj bazi podataka kreirajte stored proceduru koja ce raditi DELETE zapisa iz tabele Proizvodi.
Proceduru pohranite pod nazivom usp_Proizvodi_Delete. Pokušajte obrisati jedan od proizvoda kojeg ste dodatli u zadatku 5.
Modifikujte proceduru tako da obriše proizvod i svu njegovu historiju prodaje (Narudzbe).
*/

CREATE PROCEDURE proc_10
(
@ProizvodID int
)
AS
BEGIN
DELETE FROM Narudzbe
WHERE ProizvodID IN
                   (SELECT ProizvodID
				    FROM Proizvodi
					WHERE ProizvodID = @ProizvodID)
DELETE FROM Proizvodi
WHERE ProizvodID = @ProizvodID
END

EXEC proc_10 3