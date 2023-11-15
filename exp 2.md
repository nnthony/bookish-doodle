
### planilla
```
CREATE TABLE Planilla
(
  id_planilla NUMERIC(6) NOT NULL,
  periodo VARCHAR(10) NOT NULL,
  dias_laborables NUMERIC(3) not null,
  fecha_inicio DATE not null,
  fecha_fin DATE not null,
  fecha_calculo date,
  monto_emitido NUMERIC(12,5),
  periodicidad VARCHAR(10) not null,
  fecha_creacion date not null,
  hora_creacion time not null,
  PRIMARY KEY (id_planilla)
);
```
### boleta
```
CREATE TABLE Boleta
(
  id_boleta NUMERIC(9,2) NOT NULL,
  TotalDescuentos NUMERIC(9,2) NOT NULL,
  TotalNeto NUMERIC(9,2) NOT NULL,
  TotalIngresos NUMERIC(9,2) NOT NULL,
  TotalAportes numeric(9,2) NOT NULL,
  id_contrato numeric(6)NOT NULL,
  id_planilla numeric(6) NOT NULL,
  PRIMARY KEY (id_boleta),
  FOREIGN KEY (id_contrato) REFERENCES Contrato(id_contrato),
  FOREIGN KEY (id_planilla) REFERENCES Planilla(id_planilla)
);
```
### tipo_operacion
```
create table tipo_operacion 
(
	id_tipo_operacion VARCHAR(3) not null,
	descripcion_operacion VARCHAR(20) not null,
	primary key (id_tipo_operacion)
);
```
### tipo_operacion
```
insert into tipo_operacion (id_tipo_operacion,descripcion_operacion) 
values ('TO1'.'Ingreso'), ('TO2','Descuento'), ('TO3','aportes');
```



### estado_concepto
```
create table estado_concepto 
(
	id_estado VARCHAR(3) not null,
	descripcion_estado VARCHAR(20) not null,
	primary key (id_estado)
);
```
### estado_concepto
```
insert into estado_concepto (id_estado,descripcion_estado) 
values ('EC1'.'Activo'), ('EC2','Inactivo');
```

### concepto_nomina
```
CREATE TABLE concepto_nomina
(
  id_nomina serial NOT NULL,
  nombre_nomina VARCHAR(50) NOT NULL,
  valor_nomina numeric(3,2) NOT NULL,
  id_tipo_operacion varchar(6) CHECK (id_tipo_operacion IN ('TO1', 'TO2', 'TO3')),
  id_estado varchar(6) CHECK (id_estado IN ('EC1', 'EC2') ),
  PRIMARY KEY (id_nomina),
  FOREIGN KEY (id_tipo_operacion) REFERENCES tipo_operacion(id_tipo_operacion),
  FOREIGN KEY (id_estado) REFERENCES estado_concepto(id_estado)
);
```

### concepto_nomina
```
INSERT INTO concepto_nomina ("id_nomina", "nombre_nomina", "valor_nomina", "id_tipo_operacion", "id_estado") 
VALUES
	('1', 'Dias Subsidiados Laborados', '0', 'TO1', 'EC1'),
	('2', 'Dias Vacaciones', '0', 'TO1', 'EC1'),
	('3', 'Dias No Laborados', '0', 'TO2', 'EC1'),
	('4', 'Horas ordinarias', '0', 'TO1', 'EC1'),
	('5', 'Horas Extras 25%', '0', 'TO1', 'EC1'),
	('6', 'Horas Extras 35%', '0', 'TO1', 'EC1'),
	('7', 'Sueldo Básico a pagar', '0', 'TO1', 'EC1'),
	('8', 'Asig.Familiar', '0', 'TO1', 'EC1'),
	('9', 'Horas Extras 25%', '0', 'TO1', 'EC1'),
	('10', 'Horas Extras 35%', '0', 'TO1', 'EC1'),
	('11', 'Vacaciones', '0', 'TO1', 'EC1'),
	('12', 'OTROS INGRESOS', '0', 'TO1', 'EC1'),
	('13', 'DSCTOS. INASISTENCIA', '0', 'TO2', 'EC1'),
	('14', 'GratifIcacion', '0', 'TO1', 'EC1'),
	('15', 'Bono Extraord. Essalud', '0', 'TO3', 'EC1'),
	('16', 'Total Gratif. Diciembre', '0', 'TO1', 'EC1'),
	('17', 'ONP 13%', '0', 'TO3', 'EC1'),
	('18', 'AFP Obligatorio 10%', '0', 'TO3', 'EC1'),
	('19', 'AFP Comisión', '0', 'TO3', 'EC1'),
	('20', 'AFP Seguro', '0', 'TO3', 'EC1'),
	('21', 'Renta 5ta.', '0', 'TO2', 'EC1'),
	('22', 'Adelanto', '0', 'TO1', 'EC1'),
	('23', 'OTROS DESCUENTOS', '0', 'TO2', 'EC1'),
	('24', 'REINTEGRO', '0', 'TO1', 'EC1'),
	('25', 'Essalud 9%', '0.09', 'TO3', 'EC1');
```





#### Planillas primera pagina
```
select id_planilla, fecha_inicio, periodicidad from planilla;
```


#### Detalle planilla ** falta :,c
```
select p.id_planilla,e.nombre,c.fecha_de_contrato ca.nombre_de_cargo from planilla p,contrato c, empleado e, cargo ca
where p.id_planilla = , e.id_empleado = c.id_contrato, c.id_cargo = ca.id_cargo;
```

#### Crear planilla
```
insert into planilla (periodo, fecha_inicio, fecha_fin, fecha_creacion, hora_creacion) values (<1>,<2>,<3>,current_date,current_time);
```


#### Crear planilla, verificar empleado empleados
```
select e.id_empleado, e.nombre, c.fecha_de_contrato, ca.nombre  from empleado e, contrato c, detalle_pago d,cargo ca 
where c.fecha_de_contrato < current_date and c.fecha_termino_contrato > current_date and d.frecuencia_pago= <1> --periodicidad
```

#### Boletas de pago. primera pagina
```
select id_planilla, fecha_calculo, periodo, monto_emitido from planilla where fecha_calculo is not null
and monto_emitido is not null;
```

--generar pago es crear boletas es el calculo, el proceso bach falta :c

#### Detalle boletas - planilla(monto a cada empleado)
```
select e.nombres, e.apellido_materno, e.apellido_paterno, b.total_neto, b.id_boleta  from planilla p, empleado e,boleta b 
where p.id_planilla =<1> and p.id_planilla=b.id_planilla; --la tabla
select id_planilla, fecha_calculo,monto_emitido, periodo from planilla where planilla =<1>;--la parte de arriba,falta count
```


#### Detalle de una boleta (montos de cada empleado)
```
select e.nombres, e.apellido_materno, e.apellido_paterno, e.dni, b.total_neto, b.total_ingresos, b.total_descuentos, b.total_aportes, tc.tipo_contrato,c sueldo_base 
from planilla p, empleado e, contrato c, concepto_nomina cn, boleta b, movimiento_planilla mp,tipo_contrato tc
where b.id_boleta =<1> and c.id_tipo_contrato=tp.id_tipo_contrato and c.id_empleado=e.id_empleado;--duda
```

