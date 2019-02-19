LOAD DATA 
INFILE 'restaurantes.txt' 
APPEND 
INTO TABLE Restaurantes
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS
  (
  codigo,
  nombre,
  calle,
  "código postal",
  comision
  )