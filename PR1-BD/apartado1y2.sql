/*
Liuyifei GIIC10
Practica 1 
Apartado 1
*/
CREATE TABLESPACE EMPRESAGIIC10 DATAFILE 'D:\oracle\EMPRESAGIIC10'
SIZE 5M AUTOEXTEND OFF;

CREATE USER GIIC10 IDENTIFIED BY GIIC10 DEFAULT TABLESPACE
EMPRESAGIIC10 TEMPORARY TABLESPACE TEMP QUOTA UNLIMITED ON
EMPRESAGIIC10;

GRANT CREATE SESSION, CREATE TABLE, DELETE ANY TABLE, SELECT ANY
DICTIONARY, CREATE ANY SEQUENCE TO GIIC10;
-------------------------------------------------------

SELECT TABLE_NAME FROM USER_TABLES;

-- Permite ver las tablas creadas por el usuario conectado
CREATE TABLE Restaurantes(
 codigo NUMBER(8) NOT NULL
 , nombre CHAR(20) NOT NULL
 , calle CHAR(30) NOT NULL
 , "código postal" CHAR(5) NOT NULL
 , comision NUMBER(8,2)
 , PRIMARY KEY(codigo)
);

CREATE TABLE AreasCobertura(
 restaurante NUMBER(8) NOT NULL REFERENCES Restaurantes(codigo)
, codigoPostal Char(5)
, PRIMARY KEY(restaurante,codigoPostal)
);

CREATE TABLE Horarios(
 restaurante NUMBER(8) NOT NULL REFERENCES Restaurantes(codigo)
 , diaSemana CHAR(1) NOT NULL
 , hora_apertura Date
 , hora_cierre Date
 , PRIMARY KEY(restaurante,diaSemana)
);

CREATE TABLE Plato(
 restaurante NUMBER(8) NOT NULL REFERENCES Restaurantes(codigo)
 , nombre CHAR(20) NOT NULL
 , precio Number(8,2)
 , descripcion Char(30)
 , categoría Char(10)
 , PRIMARY KEY(restaurante,nombre)
);

CREATE INDEX I_CatPlatos ON Plato(categoría);
CREATE SEQUENCE Seq_CodPedidos INCREMENT BY 1 START WITH 1
NOMAXVALUE;

CREATE TABLE Clientes(
 DNI Char(9) NOT NULL
 , nombre Char(20) NOT NULL
 , apellido Char(20) NOT NULL
 , calle Char(20) NOT NULL
 , numero Number(4) NOT NULL
 , piso Char(5)
 , localidad Char(15)
 , codigoPostal Char(5)
 , telefono Char(9)
 , usuario Char(8) NOT NULL
 , contraseña Char(8) NOT NULL
 , PRIMARY KEY(DNI)
);

CREATE TABLE Descuentos(
 codigo NUMBER(8) NOT NULL
 , fecha_caducidad DATE
 , "porcentaje descuento" NUMBER(3) CHECK ("porcentaje descuento" >0 AND "porcentaje descuento"<=100)
 , PRIMARY KEY(codigo)
 );

CREATE TABLE Pedidos(
 codigo NUMBER(8) NOT NULL
 , estado CHAR(9) DEFAULT 'REST' NOT NULL
 , fecha_hora_pedido DATE NOT NULL
 , fecha_hora_entrega DATE
 , "importe total" NUMBER(8,2)
 , cliente CHAR(9) NOT NULL REFERENCES Clientes(DNI)
 , codigoDescuento Number(8) REFERENCES Descuentos(codigo) ON DELETE SET NULL
 , PRIMARY KEY(codigo)
 , CHECK (estado IN ('REST', 'CANCEL', 'RUTA', 'ENTREGADO', 'RECHAZADO'))
);

CREATE TABLE Contiene(
 restaurante NUMBER(8)
 , plato CHAR(20)
 , pedido NUMBER(8) REFERENCES Pedidos(codigo) ON DELETE CASCADE
 , precioConComisión NUMBER(8,2)
 , unidades NUMBER(4)NOT NULL
 , PRIMARY KEY(restaurante, plato, pedido)
 , FOREIGN KEY(restaurante, plato) REFERENCES Plato(restaurante, nombre)
);
-----------------------------------------------------------------------
/*
Apartado 2.A
*/
INSERT INTO Restaurantes VALUES (1234,'pizzahu','abascal 45','12345',2.0);
INSERT INTO AreasCobertura VALUES (1234,'12345');
INSERT INTO Horarios VALUES (1234,'X',to_date('12:00', 'HH24:MI'),to_date('23:00','HH24:MI'));
INSERT INTO Plato VALUES (1234,'pizza arrabiata',17.50,'pizza de carne y guindilla','picante');
INSERT INTO Clientes
	VALUES('12345678N','Pedro','Pérez','Torralba',29,'4B','Madrid','12345','12345612','pedro','pedro');
INSERT INTO Descuentos VALUES (1100,to_date('20-04-09', 'DD-MM-YY'),50);
INSERT INTO Pedidos VALUES 
	(1,'REST',to_date('17-02-09:19:50','DD-MM-YY:HH24:MI'),to_date('17-02-09:20:50','DD-MM-YY:HH24:MI'), 34.25,
'12345678N',1100);
INSERT INTO Contiene VALUES (1234,'pizza arrabiata',1,NULL,2);
/*
Apartado 2.B
1.*Cause:    An UPDATE or INSERT statement attempted to insert a duplicate key.
           For Trusted Oracle configured in DBMS MAC mode, you may see
           this message if a duplicate entry exists at a different level.
  *Action:   Either remove the unique restriction or do not insert the key.
2.no hay suficientes valores
	Informe de error:
	Error SQL: ORA-01400: no se puede realizar una inserción NULL en ("GIIC10"."CONTIENE"."PLATO")
	01400. 00000 -  "cannot insert NULL into (%s)"
3.The values being inserted do not satisfy the named check,do not insert values that violate the constraint.
4.
5.Error SQL: ORA-02292: restricción de integridad (GIIC10.SYS_C0013627) violada - registro secundario encontrado
	02292. 00000 - "integrity constraint (%s.%s) violated - child record found"
	*Cause:    attempted to delete a parent key value that had a foreign
           dependency.
	*Action:   delete dependencies first then parent or disable constraint.
	si,se muestra las horas,

*/