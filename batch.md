## Proceso: Calculo de planilla

1. Se realizará el calculo de una planilla que aun no haya generado sus pagos, el sistema puede identificar cuales son con este query:
```
SELECT id_planilla, fecha_calculo, periodo, monto_emitido FROM planilla
WHERE fecha_calculo IS NOT NULL AND monto_emitido IS NOT NULL;
```
2. Los empleados a los que se le pagará se pueden identificar con este query:
```
SELECT e.id_empleado,co.id_contrato,e.nombre, co.fecha_inicio_laboral, co.fecha_termino_contrato, ca.nombre_cargo  
FROM contrato co, cargo ca, empleado e, Frecuencia_pago fp
WHERE co.fecha_inicio_laboral <= (SELECT fecha_inicio FROM planilla WHERE id_planilla=<1>) 
  AND co.fecha_termino_contrato+30 >= (SELECT fecha_fin FROM planilla WHERE id_planilla=<1>) 
  AND fp.frecuencia_pago= (SELECT periodicidad FROM planilla WHERE id_planilla=<1>)
  AND e.id_empleado = co.id_empleado 
  AND co.id_frecuencia_pago = fp.id_frecuencia_pago 
  AND co.id_cargo = ca.id_cargo
-- 1: id de planilla
```
3. Para empezar con el cálculo de planilla, el sistema generará boletas con valores en blanco, es decir, los valores en total neto, total ingresos, etc, estarán en 0. Esto se llevará a cabo con el siguiente código en lenguaje plpsql:
```
CREATE OR REPLACE FUNCTION crear_boletas(planilla_id integer)
RETURNS VOID AS 
$$
DECLARE
    fila_contrato RECORD;
BEGIN
    FOR fila_contrato IN 
        SELECT e.id_empleado,co.id_contrato,e.nombre  
        FROM contrato co, empleado e, Frecuencia_pago fp
        WHERE co.fecha_inicio_laboral < (SELECT fecha_inicio FROM planilla WHERE id_planilla=planilla_id) 
            AND co.fecha_termino_contrato+30 >= (SELECT fecha_fin FROM planilla WHERE id_planilla=planilla_id) 
            AND fp.frecuencia_pago= (SELECT periodicidad FROM planilla WHERE id_planilla=planilla_id)
            AND e.id_empleado = co.id_empleado 
            AND co.id_frecuencia_pago = fp.id_frecuencia_pago
    LOOP
        INSERT INTO Boleta (id_boleta, TotalDescuentos, TotalNeto, TotalIngresos, TotalAportes, id_contrato, id_planilla)
        VALUES (nextval('boleta_nuevo_id_seq1'::regclass),0, 0, 0, 0, fila_contrato.id_contrato, planilla_id);
        
    END LOOP;
	
END;
$$
LANGUAGE plpgsql;
```
&nbsp; &nbsp; &nbsp; &nbsp; Este código crea una función que tiene como variable de entrada el *id_planilla* de la planilla que se quiere pagar. Con esta función se crea las boletas, en base a la *frecuencia_pago*, *fecha_inicio_laboral* y *fecha_termino_contrato* del contrato y la *periodicidad*, *fecha_inicio* y *fecha_fin* de la planilla. Se crea una fila a partir de un query, en esta fila se obtiene todos los contratos de los empleados a los que se les debe pagar por esta planilla, por eso este query similar al anterior. Una vez ejecutada esta función se tendran todas las nuevas boletas.


4. Ahora se comenzará con los calculos en sí, se usará el siguiente código en lenguaje plpgsql para sumar todos los movimientos de planilla y trasladarlos a los atributos de la fila boleta correspondiente:
```
CREATE OR REPLACE FUNCTION modificar_boletas_consecutivas() RETURNS VOID AS $$
DECLARE
    id_inicio INT := 1853;
    id_fin INT := 1877;
    curr_id INT;
BEGIN
    FOR curr_id IN id_inicio..id_fin LOOP
        UPDATE Boleta
        SET TotalDescuentos = (SELECT COALESCE(SUM(mp.monto), 0)
                               FROM Movimiento_planilla mp
                               INNER JOIN Concepto_nomina cn ON mp.id_nomina = cn.id_nomina
                               WHERE mp.id_contrato = Boleta.id_contrato
                                 AND cn.id_tipo_operacion = 2
                                 AND mp.fecha > (SELECT fecha_inicio FROM Planilla WHERE id_planilla = Boleta.id_planilla)
                                 AND mp.fecha < (SELECT fecha_fin FROM Planilla WHERE id_planilla = Boleta.id_planilla)),
            TotalIngresos = (SELECT COALESCE(SUM(mp.monto), 0)
                             FROM Movimiento_planilla mp
                             INNER JOIN Concepto_nomina cn ON mp.id_nomina = cn.id_nomina
                             WHERE mp.id_contrato = Boleta.id_contrato
                               AND cn.id_tipo_operacion = 1
                               AND mp.fecha > (SELECT fecha_inicio FROM Planilla WHERE id_planilla = Boleta.id_planilla)
                               AND mp.fecha < (SELECT fecha_fin FROM Planilla WHERE id_planilla = Boleta.id_planilla)),
            TotalAportes = (SELECT COALESCE(SUM(mp.monto), 0)
                            FROM Movimiento_planilla mp
                            INNER JOIN Concepto_nomina cn ON mp.id_nomina = cn.id_nomina
                            WHERE mp.id_contrato = Boleta.id_contrato
                              AND cn.id_tipo_operacion = 3
                              AND mp.fecha > (SELECT fecha_inicio FROM Planilla WHERE id_planilla = Boleta.id_planilla)
                              AND mp.fecha < (SELECT fecha_fin FROM Planilla WHERE id_planilla = Boleta.id_planilla)),
            TotalNeto = ((SELECT COALESCE(SUM(mp1.monto), 0)
                          FROM Movimiento_planilla mp1
                          INNER JOIN Concepto_nomina cn1 ON mp1.id_nomina = cn1.id_nomina
                          WHERE mp1.id_contrato = Boleta.id_contrato
                            AND cn1.id_tipo_operacion = 1
                            AND mp1.fecha > (SELECT fecha_inicio FROM Planilla WHERE id_planilla = Boleta.id_planilla)
                            AND mp1.fecha < (SELECT fecha_fin FROM Planilla WHERE id_planilla = Boleta.id_planilla)) -
                         (SELECT COALESCE(SUM(mp2.monto), 0)
                          FROM Movimiento_planilla mp2
                          INNER JOIN Concepto_nomina cn2 ON mp2.id_nomina = cn2.id_nomina
                          WHERE mp2.id_contrato = Boleta.id_contrato
                            AND cn2.id_tipo_operacion = 2
                            AND mp2.fecha > (SELECT fecha_inicio FROM Planilla WHERE id_planilla = Boleta.id_planilla)
                            AND mp2.fecha < (SELECT fecha_fin FROM Planilla WHERE id_planilla = Boleta.id_planilla)))
        WHERE id_boleta = curr_id;
    END LOOP;
	UPDATE planilla
	SET fecha_calculo=current_date, monto_emitido=(select sum(totalneto) from boleta where id_planilla=34 )
	where id_planilla=34;
END;
$$ LANGUAGE PLPGSQL;
```
&nbsp; &nbsp; &nbsp; &nbsp; Este código crea una función que tiene como variables de entrada el primer y último *id_boleta* generado en el código anterior, y crea un for que va a recorrer todas esas boletas para hacerles un *UPDATE*. Este consisten en sumar todos los movimientos de planilla considerando su atributo *id_tipo_operacion*, dependiendo su valor se va a sumar en un total diferente, estos son:
- id_tipo_operacion = 1, se suma en *totalingresos*
- id_tipo_operacion = 2, se suma en *totaldescuentos*
- id_tipo_operacion = 3, se suma en *totalaportes*
Luego se resta *totalingresos* menos *totaldescuentos* y se almacena en *totalneto*, finalmente fuera del bucle se actualiza los atributos *fecha_calculo* y *monto_emitido* de la planilla, *fecha_calculo* con un *current_date* y *monto_emitido* con un *SELECT SUM()* de los totales netos de las nuevas boletas de la planilla
