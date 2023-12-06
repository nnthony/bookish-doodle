-- CALDERON PEREZ ANTHONY ALEXIS, CODIGO:20211398I, DBD 23-2 V
-- ejercicio1
CREATE OR REPLACE FUNCTION triangulo(a NUMERIC, b NUMERIC, c NUMERIC)
RETURNS VOID AS
$$
BEGIN
	IF a = b AND b = c THEN
		RAISE NOTICE 'Triangulo equilatero';
	ELSIF a = b OR b = c OR a = c THEN
		RAISE NOTICE 'Triangulo isosceles';
	ELSE
		RAISE NOTICE 'Triangulo escaleno';
	END IF;
END;
$$
LANGUAGE PLPGSQL;

SELECT triangulo(4,4,4);


--ejercicio2
CREATE TABLE triangle (
	a NUMERIC,
	b NUMERIC,
	c NUMERIC
);

INSERT INTO triangle values (2,2,2),(2,3,4),(2,2,3),(3,3,5),(5,4,7),(8,8,8);
select * from triangle;


DO $$
DECLARE
	cur CURSOR 
	FOR SELECT * FROM triangle; 
BEGIN
	FOR tr IN cur LOOP 
		PERFORM triangulo(tr.a,tr.b,tr.c);
	END LOOP;
END;
$$

--ejercicio3
CREATE OR REPLACE FUNCTION f(x NUMERIC, y NUMERIC, z NUMERIC)
RETURNS NUMERIC AS
$$
DECLARE
	resultado NUMERIC;
BEGIN
	resultado:= power(x,3)+power(y,6)+x*y*z;
	RETURN resultado;
END;
$$
LANGUAGE PLPGSQL;


select f(1,2,2);

--ejercicio4
DO $$
DECLARE
	resultado numeric;
BEGIN
	FOR i IN 1..5 LOOP
		FOR j IN 1..5 LOOP
			FOR k IN 1..5 LOOP
				resultado = f(i,j,k);
				RAISE NOTICE 'Valores %, %, %, resultado %',i,j,k,resultado;
			END LOOP;
		END LOOP;
	END LOOP;
END;
$$

--ejercicio 5




