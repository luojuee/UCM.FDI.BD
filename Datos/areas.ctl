LOAD DATA 
INFILE 'areas.txt' 
APPEND 
INTO TABLE AreasCobertura
FIELDS TERMINATED BY ';'
(restaurante,codigoPostal)