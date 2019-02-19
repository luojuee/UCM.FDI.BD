LOAD DATA 
INFILE 'aplicadosA.txt' 
APPEND 
INTO TABLE AplicadoA
FIELDS TERMINATED BY ';'
TRAILING NULLCOLS(
 descuent
 , pedido
  )