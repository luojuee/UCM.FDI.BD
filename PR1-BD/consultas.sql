/*1*/ SELECT *FROM Clientes ORDER BY apellido ASC;

/*2*/SELECT restaurante, to_char(hora_apertura,'HH:MM'),to_char(hora_cierre,'HH:MM'),
		case diaSemana
			WHEN 'L' THEN 'LUNES'
			WHEN 'J' THEN 'JUEVES'
			WHEN 'X' THEN 'MIECORES'
			WHEN 'D' THEN 'DOMINGO'
			WHEN 'S' THEN 'SÁBATO'
			WHEN 'M' THEN 'MARTES'
			WHEN 'V' THEN 'VIERNES'
		END AS DIA 
	from HORARIOS;

3.SELECT DNI,nombre,apellido FROM Clientes, pedidos WHERE clientes.dni = pedidos.cliente IN( 
        SELECT PEDIDOS.CLIENTE FROM PEDIDOS WHERE pedidos.codigo = contiene.pedido IN(
         SELECT contiene.plato FROM CONTIENE WHERE contiene.plato = plato.nombre
                     IN (select plato.nombre from plato WHERE plato.categoría = 'picante'))); 

/*4*/ SELECT codigo, nombre, apellido FROM pedidos, clientes WHERE "importe total" > 100;

/*5*/ SELECT * FROM clientes WHERE DNI NOT IN(SELECT CLIENTE FROM pedidos);

/*6*/ SELECT *FROM clientes WHERE telefono IS NOT NULL;

/*8*/ SELECT distinct DNI,nombre,apellido FROM Clientes,pedidos WHERE estado != 'ENTREGADO';

/*9*/ SELECT * FROM pedidos WHERE "importe total" = (select max("importe total")from pedidos);

/*10*/ SELECT DNI,nombre,apellido, AVG("importe total")AS MEDIO FROM Clientes,pedidos 
	WHERE clientes.dni = pedidos.cliente
	group by DNI,nombre,apellido,clientes.codigopostal;

/*11*/ SELECT codigo, restaurantes.nombre, count(distinct plato.nombre) as numTotal,sum(distinct plato.precio)as precioTotal
	FROM restaurantes,plato
	WHERE restaurantes.codigo = plato.restaurante
	group by codigo, restaurantes.nombre;
	
/*12*/ SELECT nombre,apellido FROM Clientes C,Pedidos P WHERE C.DNI = P.codigo,"importe total" >15;

/*13*/ SELECT DNI,nombre,apellido, COUNT(clientes.codigopostal)AS numRes FROM Clientes,areascobertura 
	WHERE clientes.codigopostal = areascobertura.codigopostal 
	group by DNI,nombre,apellido,clientes.codigopostal;