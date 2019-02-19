CREATE OR REPLACE PROCEDURE PEDIDO_CLIENTE AS
id Cliente.DNI%type;
cintador :=0;
total number(8,2):=0;

BEGIN

CURSOR Datos IS
SELECT cliente,codigo,fecha_hora_pedido,fecha_hora_entrega,estado,sum("importe total")
FROM Pedidos
ORDER BY fecha_hora_pedido;

WHILE contador<codigo LOOP
dbms_output.put_line(contador.cliente ||contador.codigo|| contador.fecha_hora_pedido||
contador.fecha_hora_entrega||contador.estado||contador."importe total");
IF(contador.cliente NOT IN Clientes)THEN 
dbms_output.put_line('DNI no existe')
ELSE IF contador.estado = 'CANCEL' THEN 
dbms_output.put_line('no hay pedidos para ese cliente')
END IF;
END IF;
contador++;
END LOOP;

EXCEPTION

END; 