/*1.
Kroz SQL kod napraviti bazu podataka koja nosi ime vašeg broja dosijea, a zatim u svojoj bazi podataka kreirati
tabele sa sljedeæom strukturom:
a) Klijenti
i. Ime, polje za unos 50 karaktera (obavezan unos)
ii. Prezime, polje za unos 50 karaktera (obavezan unos)
iii. Grad, polje za unos 50 karaktera (obavezan unos)
iv. Email, polje za unos 50 karaktera (obavezan unos)
v. Telefon, polje za unos 50 karaktera (obavezan unos)
b) Racuni
i. DatumOtvaranja, polje za unos datuma (obavezan unos)
ii. TipRacuna, polje za unos 50 karaktera (obavezan unos)
iii. BrojRacuna, polje za unos 16 karaktera (obavezan unos)
iv. Stanje, polje za unos decimalnog broja (obavezan unos)
c) Transakcije
i. Datum, polje za unos datuma i vremena (obavezan unos)
ii. Primatelj polje za unos 50 karaktera – (obavezan unos)
iii. BrojRacunaPrimatelja, polje za unos 16 karaktera (obavezan unos)
iv. MjestoPrimatelja, polje za unos 50 karaktera (obavezan unos)
v. AdresaPrimatelja, polje za unos 50 karaktera (nije obavezan unos)
vi. Svrha, polje za unos 200 karaktera (nije obavezan unos)
vii. Iznos, polje za unos decimalnog broja (obavezan unos)
Napomena: Klijent može imati više otvorenih raèuna, dok se svaki raèun veže iskljuèivo za jednog klijenta. Sa
raèuna klijenta se provode transakcije, dok se svaka pojedinaèna transakcija provodi sa jednog raèuna
*/

CREATE DATABASE EmirSahovic
GO

USE EmirSahovic
GO

CREATE TABLE Klijenti
(
KlijentID int CONSTRAINT PK_Klijenti PRIMARY KEY IDENTITY(1,1),
Ime nvarchar(50) NOT NULL,
Prezime nvarchar(50) NOT NULL,
Grad nvarchar(50) NOT NULL,
Email nvarchar(50) NOT NULL,
Telefon nvarchar(50) NOT NULL,
)

CREATE TABLE Racuni
(
RacunID int CONSTRAINT PK_Racuni PRIMARY KEY IDENTITY(1,1),
KlijentID int CONSTRAINT FK_Racuni_Klijenti FOREIGN KEY(KlijentID) REFERENCES Klijenti(KlijentID),
DatumOtvaranja date NOT NULL,
TipRacuna nvarchar(50) NOT NULL,
BrojRacuna nvarchar(16) NOT NULL,
Stanje decimal(8,2) NOT NULL
)

CREATE TABLE Transakcije
(
TransakcijaID int CONSTRAINT PK_Transakcije PRIMARY KEY IDENTITY(1,1),
RacunID int CONSTRAINT FK_Transakcije_Racuni FOREIGN KEY(RacunID) REFERENCES Racuni(RacunID),
Datum datetime NOT NULL,
Primatelj nvarchar(50) NOT NULL,
BrojRacunaPrimatelja nvarchar(16) NOT NULL,
MjestoPrimatelja nvarchar(50) NOT NULL,
AdresaPrimatelja nvarchar(50),
Svrha nvarchar(200),
Iznos decimal(8,2) NOT NULL
)

/*2.Nad poljem Email u tabeli Klijenti, te BrojRacuna u tabeli Racuni kreirati unique index.*/

CREATE UNIQUE NONCLUSTERED INDEX IX_Email
ON Klijenti(Email)

CREATE UNIQUE NONCLUSTERED INDEX IX_BrojRacuna
ON Racuni(BrojRacuna)

/*3.Kreirati uskladištenu proceduru za unos novog raèuna. Obavezno provjeriti ispravnost kreirane procedure.*/

CREATE PROCEDURE proc_3
(
@KlijentID int,
@DatumOtvaranja date,
@TipRacuna nvarchar(50),
@BrojRacuna nvarchar(16),
@Stanje decimal(8,2)
)
AS
BEGIN
INSERT INTO Racuni(KlijentID, DatumOtvaranja, TipRacuna, BrojRacuna, Stanje)
VALUES (@KlijentID, @DatumOtvaranja, @TipRacuna, @BrojRacuna, @Stanje)
END

EXEC proc_3 1, '20190526', 'Testni', '0000000000000001', 300.45

/*4.
 Iz baze podataka Northwind u svoju bazu podataka prebaciti sljedeæe podatke:
a) U tabelu Klijenti prebaciti sve kupce koji su obavljali narudžbe u 1996. godini
i. ContactName (do razmaka) -> Ime
ii. ContactName (poslije razmaka) -> Prezime
iii. City -> Grad
iv. ContactName@northwind.ba -> Email (Izmeðu imena i prezime staviti taèku)
v. Phone -> Telefon
b) Koristeæi prethodno kreiranu proceduru u tabelu Racuni dodati 10 raèuna za razlièite kupce
(proizvoljno). Odreðenim kupcima pridružiti više raèuna.
c) Za svaki prethodno dodani raèun u tabelu Transakcije dodati po 10 transakcija. Podatke za tabelu
Transakcije preuzeti RANDOM iz Northwind baze podataka i to poštujuæi sljedeæa pravila:
i. OrderDate (Orders) -> Datum
ii. ShipName (Orders) - > Primatelj
iii. OrderID + '00000123456' (Orders) -> BrojRacunaPrimatelja
iv. ShipCity (Orders) -> MjestoPrimatelja,
v. ShipAddress (Orders) -> AdresaPrimatelja,
vi. NULL -> Svrha,
vii. Ukupan iznos narudžbe (Order Details) -> Iznos
Napomena (c): ID raèuna ruèno izmijeniti u podupitu prilikom inserta podataka
*/

INSERT INTO Klijenti(Ime, Prezime, Grad, Email, Telefon)
SELECT SUBSTRING(ContactName, 0, CHARINDEX(' ', ContactName)),
       SUBSTRING(ContactName, CHARINDEX(' ', ContactName) + 1, LEN(ContactName)),
	   City,
	   SUBSTRING(ContactName, 0, CHARINDEX(' ', ContactName)) + '.' + SUBSTRING(ContactName, CHARINDEX(' ', ContactName) + 1, LEN(ContactName)) + '@northwind.ba',
	   Phone
FROM NORTHWND.dbo.Customers 

SELECT * FROM Klijenti

EXEC proc_3 1, '20190526', 'TIP1', '1000000000000001', 300.45
EXEC proc_3 2, '20190326', 'TIP2', '1100000000000001', 150.50
EXEC proc_3 2, '20190427', 'TIP3', '1110000000000001', 1300.75
EXEC proc_3 3, '20190316', 'TIP3', '1111000000000001', 2000
EXEC proc_3 4, '20190405', 'TIP2', '1111100000000001', 3000.45
EXEC proc_3 4, '20191213', 'TIP1', '1111110000000001', 125.85
EXEC proc_3 5, '20190324', 'TIP3', '1111111000000001', 100
EXEC proc_3 5, '20190217', 'TIP1', '1111111100000001', 50
EXEC proc_3 6, '20190512', 'TIP2', '1111111110000001', 5000
EXEC proc_3 7, '20190423', 'TIP1', '1111111111000001', 500.50

SELECT * FROM Racuni

/*5.
 Svim raèunima èiji vlasnik dolazi iz Londona, a koji su otvoreni u 8. mjesecu, stanje uveæati za 500. Grad i mjesec
se mogu proizvoljno mijenjati kako bi se rezultat komande prilagodio vlastitim podacima
*/

SELECT * FROM Klijenti

UPDATE Racuni
SET Stanje = Stanje + 500
WHERE KlijentID IN (
                    SELECT KlijentID
					FROM Klijenti
					WHERE Grad = 'London')
AND MONTH(DatumOtvaranja) = 8


/*6.
Kreirati view (pogled) koji prikazuje ime i prezime (spojeno), grad, email i telefon klijenta, zatim tip raèuna, broj
raèuna i stanje, te za svaku transakciju primatelja, broj raèuna primatelja i iznos. Voditi raèuna da se u rezultat
ukljuèe i klijenti koji nemaju otvoren niti jedan raèun
*/

CREATE VIEW view_6
AS
SELECT K.Ime + ' ' + K.Prezime as 'Ime i prezime', K.Grad, K.Email, K.Telefon,
       R.TipRacuna, R.BrojRacuna, R.Stanje, T.Primatelj, T.BrojRacunaPrimatelja, T.Iznos
FROM Klijenti as K LEFT JOIN Racuni as R 
ON K.KlijentID = R.KlijentID LEFT JOIN Transakcije as T
ON T.RacunID = R.RacunID

SELECT * FROM view_6

/*7.
Kreirati uskladištenu proceduru koja æe na osnovu proslijeðenog broja raèuna klijenta prikazati podatke o
vlasniku raèuna (ime i prezime, grad i telefon), broj i stanje raèuna te ukupan iznos transakcija provedenih sa
raèuna. Ukoliko se ne proslijedi broj raèuna, potrebno je prikazati podatke za sve raèune. Sve kolone koje
prikazuju NULL vrijednost formatirati u 'N/A'. U proceduri koristiti prethodno kreirani view. Obavezno provjeriti
ispravnost kreirane procedure
*/

CREATE PROCEDURE proc_7
(
@BrojRacuna nvarchar(16) = NULL
)
AS
BEGIN
SELECT [Ime i prezime], Grad, Telefon, BrojRacuna, Stanje, SUM(Iznos) as Ukupno
FROM view_6
WHERE BrojRacuna = @BrojRacuna OR @BrojRacuna IS NULL
GROUP BY [Ime i prezime], Grad, Telefon, BrojRacuna, Stanje
END

EXEC proc_7 '1100000000000001'

/*8.
Kreirati uskladištenu proceduru koja æe na osnovu unesenog identifikatora klijenta vršiti brisanje klijenta
ukljuèujuæi sve njegove raèune zajedno sa transakcijama. Obavezno provjeriti ispravnost kreirane procedure
*/

CREATE PROCEDURE proc_8
(
@KlijentID int
)
AS
BEGIN
DELETE FROM Racuni
WHERE KlijentID IN (
                    SELECT KlijentID
					FROM Klijenti
					WHERE KlijentID = @KlijentID)
DELETE FROM Transakcije
WHERE RacunID IN (
                  SELECT RacunID
				  FROM Racuni
				  WHERE KlijentID = @KlijentID)
DELETE FROM Klijenti
WHERE KlijentID = @KlijentID
END

EXEC proc_8 2

/*9.
Komandu iz zadatka 5. pohraniti kao proceduru a kao parametre proceduri proslijediti naziv grada, mjesec i iznos
uveæanja raèuna. Obavezno provjeriti ispravnost kreirane procedure
*/

CREATE PROCEDURE proc_9
(
@Grad nvarchar(50),
@Mjesec nvarchar(10),
@Iznos decimal(8,2)
)
AS
BEGIN
UPDATE Racuni
SET Stanje = Stanje + @Iznos
WHERE KlijentID IN (
                    SELECT KlijentID
					FROM Klijenti
					WHERE Grad = @Grad)
AND MONTH(DatumOtvaranja) = @Mjesec
END

EXEC proc_9 'Mexico D.F.', '03', 300

SELECT * FROM Racuni
SELECT * FROM Klijenti

/*10. Kreirati full i diferencijalni backup baze podataka na lokaciju servera D:\BP2\Backup*/

BACKUP DATABASE EmirSahovic
TO DISK = 'D:\BP2\Backup\EmirSahovic.bak'

BACKUP DATABASE EmirSahovic
TO DISK = 'D:\BP2\Backup\EmirSahovic.bak'
WITH DIFFERENTIAL