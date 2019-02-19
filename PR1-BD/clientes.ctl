LOAD DATA
INFILE 'clientes.txt'
APPEND
INTO TABLE Clientes
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
(DNI
 , nombre
 , apellido
 , calle
 , numero
 , piso
 , localidad
 , codigoPostal
 , telefono
 , usuario
 , contraseña
)