LOAD DATA
INFILE 'platos.txt'
APPEND
INTO TABLE Plato
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
 (restaurante
 , nombre
 , precio
 , descripcion
 , categoría
 )