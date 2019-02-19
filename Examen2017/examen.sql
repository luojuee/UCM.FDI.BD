/*------------------CREATE TABLE--------------------*/
CREATE TABLE Cine(
 Cod NUMBER(8) NOT NULL
 , distrito NUMBER(5)NOT NULL
 , PRIMARY KEY(Cod)
);

CREATE TABLE Salas(
 CodCine NUMBER(8) NOT NULL REFERENCES Cine(Cod)
, NumSala NUMBER(8) NOT NULL
, Aforo NUMBER (3)
, PRIMARY KEY(CodCine,NumSala)
);

CREATE TABLE Plicula(
 TPelicula CHAR(30) NOT NULL
, FechaEstreno DATE NOT NULL
, Precio NUMBER (3) NOT NULL
, Durcion NUMBER (3) NOT NULL
, PRIMARY KEY(TPelicula)
);

CREATE TABLE Pases(
 CodCine NUMBER(8) NOT NULL
, NumSalas NUMBER(8) NOT NULL
, Hora DATE NOT NULL
, TPelicula CHAR(30) NOT NULL
, EntradasVendidas CHAR(8) NOT NULL
, PRIMARY KEY(CodCine,NumSalas,Hora)
, FOREIGN KEY(CodCine,NumSalas) REFERENCES Salas
);

CREATE TABLE CompraEntradas(
 IdCliente NUMBER(9) NOT NULL
, CodCine NUMBER(8) NOT NULL
, NumSala NUMBER(8) NOT NULL
, Hora DATE NOT NULL
, NumLocalidades char(8) not null
, PRIMARY KEY(IdCliente,CodCine,NumSala,Hora)
, FOREIGN KEY(CodCine,NumSala,Hora) REFERENCES Pases
);
/*----------------------Consultas--------------------*/
/*a*/SELECT DISTINCT pases.TPelicula FROM Pases, Pelicula,Cine
	WHERE Pases.TPelicula = Pelicula.TPelicula
		AND Cine.Cod = Pases.CodCine
		AND Duracion > 90 
		AND Dintrito = 24321;	
/*b*/SELECT DISTINCT Pelicula.TPelicula FROM Pases, Cine, Salas, Pelicula
	WHERE Pelicula.TPelicula = Pases.TPelicula AND Pases.CodCine = Salas.CodCine AND Salas.CodCine = Cine.COD
		AND Duracion > 90
		GROUP BY Pelicula.TPelicula, Distrito
		Having SUM(Aforo) > 300;
/*c*/SELECT C.Cod, count(*) FROM Cine C,Pases
	WHERE C.Cod = CodCine
	AND EntradasVendidas = 0
	GROUP BY C.Cod
	UNION ALL
	SELECT C.Cod,0 FROM Cine C
	WHERE NOT EXISTS (SELECT*FROM Pases 
					WHERE C.Cod = CodCine
					AND EntradasVendidas = 0);
/*d*/SELECT CodCine FROM Pases, Pelicula
	WHERE Pases.TPelicula = Pelicula.TPelicula
	AND NOT EXISTS(SELECT *FROM Pelicula
					WHERE YEAR FROM FechaEstreno<>2016);
/*e*/SELECT distrito FROM Pases, Cine
	WHERE CodCine = Cod
	GROUP BY distrito
	HAVING COUNT(DISTINCT TPelicula)>= ALL(SELECT COUNT (DISTINCT TPelicula) FROM Pases,Cine
											WHERE CodCine = Cod
											GROUP BY distrito)
/*f*/
create or replace PROCEDURE printcine(Cine Salas.CodCine%TYPE)) AS
nSalas Salas.NumSalas%TYPE;
vAforo Salas.Aforo%TYPE;
vCodCine Salas.CodCine%TYPE;
CURSOR c_Cine IS
	SELECT Hora,NumSalas,TPelicula,Aforo-EntradasVendidas as LocLibres FROM Salas, Pases
	WHERE  Salas.CodCine = Pases.CodCine
		AND Salas.NumSala = Pases.NumSalas;
		AND Salas.CodCine = vCine
	ORDER BY Pases.Hora;
	
	vPases c_Cine%ROWTYPE;
BEGIN
	SELECT CodCine, COUNT(*), SUM(Aforo)
	INTO vCodCine, nSalas, vAforo FROM Salas
	WHERE CodCine = vCine
	GROUP BY CodCine;
	DBMS_OUTPUT.PUT_LINE('Cine: ' || vCine ||', NumSalas: ' || nSalas || ', Aforo total: ' || vAforo);
OPEN c_Cine;
LOOP
	FETCH c_Cine INTO vPases;
	DBMS_OUTPUT.PUT_LINE('Hora: ' || PASE.Hora ||' Sala: ' || PASE.NumSalas ||' Pelicula: ' || PASE.TPelicula || ' Localidades Libres: ' || PASE.LocLibres);
	EXIT WHEN c_Cine%NOTFOUND;
END LOOP;
CLOSE c_Cine;

EXCEPTION
	WHEN NO_DATA_FOUND THEN
		DBMS_OUTPUT.PUT_LINE('El cine ' || Cine || ' no existe');
END;

/*g*/CREATE OR REPLACE TRIGGER actuariza
AFTER INSERT OR DELETE OR UPDATE OF NumLocalidades ON CompraEntradas
FOR EACH ROW
BEGIN
	IF INSERTING THEN
		UPDATE Pases SET EntradasVendidas = EntradasVendidas + :NEW.NumLocalidades
		WHERE CodCine = :NEW.CodCine
		AND NumSala= :NEW.NumSala
		AND Hora = :NEW.Hora;
	ELSE IF DELETING THEN
		UPDATE Pases SET EntradasVendidas = EntradasVendidas - :OLD.NumLocalidades
		WHERE CodCine = :OLD.CodCine
		AND NumSala= :OLD.NumSala
		AND Hora = :OLD.Hora;
	ELSE IF UPDATING THEN
		UPDATE Pases SET EntradasVendidas = EntradasVendidas - :OLD.NumLocalidades + :NEW.NumLocalidades
		WHERE CodCine = :OLD.CodCine
		AND NumSala= :OLD.NumSala
		AND Hora = :OLD.Hora;
	END IF;
END;