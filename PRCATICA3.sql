GRANT CREATE TRIGGER TO GIIC10;
GRANT ALTER ANY TRIGGER TO GIIC10;
GRANT DROP ANY TRIGGER TO GIIC10;
-----------------------------1--------------------------------
CREATE OR REPLACE trigger control_detalle_pedidos
AFTER INSERT OR UPDATE OR DELETE OF PRECIOCONCOMISI車N ON Contiene
FOR EACH ROW

BEGIN
	IF INSERTING THEN
	UPDATE Pedidos SET "importe total" = "importe total" + :NEW.PRECIOCONCOMISI車N WHERE CODIGO = :NEW.PEDIDO;
	
	ELSIF DELETING THEN
	UPDATE Pedidos SET  "importe total" = "importe total" - :OLD.PRECIOCONCOMISI車N WHERE CODIGO = :OLD.PEDIDO;
	
	ELSE
	UPDATE Pedidos SET	"importe total" = "importe total" - :OLD.PRECIOCONCOMISI車N + :NEW.PRECIOCONCOMISI車N WHERE CODIGO = :OLD.PEDIDO;
	
	END IF;
	
END;

-----------------------------2--------------------------------
CREATE TABLE REGISTRO_VENTAS (
 COD_REST NUMBER(8) PRIMARY KEY REFERENCES Restaurantes
 ,TOTAL_PEDIDOS NUMBER
 );
 
 CREATE OR REPLACE trigger t_actualiza
 AFTER INSERT OR UPDATE OR DELETE OF "importe total" ON Pedidos
 FOR EACH ROW
 
 BEGIN
	select restaurante,"importe total" from Contiene,Pedidos where CODIGO = PEDIDO;
	
	IF INSERTING THEN
	UPDATE REGISTRO_VENTAS SET TOTAL_PEDIDOS = TOTAL_PEDIDOS + :NEW."importe total" WHERE COD_REST = :NEW.restaurante ;
	
	ELSIF DELETING THEN
	UPDATE REGISTRO_VENTAS SET TOTAL_PEDIDOS = TOTAL_PEDIDOS - :OLD."importe total" WHERE COD_REST = :OLD.restaurante;
	
	ELSE
	UPDATE REGISTRO_VENTAS SET	"importe total" = "importe total" - :OLD."importe total" + :NEW."importe total" WHERE COD_REST = :OLD.restaurante;
	
	END IF;
 
 END;