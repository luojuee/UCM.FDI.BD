LOAD DATA 
INFILE 'contiene.txt' 
APPEND 
INTO TABLE Contiene
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
  (restaurante
 , plato
 , pedido
 , precioConComisión
 , unidades
  )