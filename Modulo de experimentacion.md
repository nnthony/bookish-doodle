# unidad 0


- Tabla: PLANILLA
```
CREATE TABLE Planilla (
    id_planilla NUMERIC(6) PRIMARY KEY,
    periodo CHAR(9) NOT NULL,
    dias_laborables NUMERIC(2),
    fechaInicio DATE NOT NULL,
    fechaFinal DATE NOT NULL,
    fechaCalculo DATE,
);
```

- Tabla: BOLETA
```
CREATE TABLE BOLETA (
    id_boleta NUMERIC(6) PRIMARY KEY
    id_planilla NUMERIC(6) NOT NULL,
    id_empleado NUMERIC(6) NOT NULL,
    totalIngresos NUMERIC(9,2) NOT NULL,
    totalDescuentos NUMERIC(9,2) NOT NULL,
    totalNeto NUMERIC(9,2) NOT NULL, 
    totalAporte NUMERIC(O,2) NOT NULL
)
```

- Tabla: CONCEPTO_NOMINA
```
CREATE TABLE CONCEPTO_NOMINA (
    id_concepto INTEGER(6) PRIMARY KEY,
    nombreConcepto VARCHAR(40) NOT NULL,
    tipoOperacion CHAR(3) CHECK (tipoOperacion IN ('TO1', 'TO2', 'TO3')),
    estadoConcepto CHAR(3) CHECK (estadoConcepto IN ('EC1', 'EC2') ),
    valor NUMERIC(1,2),
);
```



```
CREATE TABLE "mytable" (
  "id_concepto ;nombreConcepto;tipoOperacion;estadoConcepto;valor" text
);

INSERT INTO CONCEPTO_NOMINA ("id_concepto;nombreConcepto;tipoOperacion;estadoConcepto;valor) VALUES
('162873;SUELDO;TO1;EC1;'),
('162872;BONIFIVCACION GRATIFICACION;TO1;EC1;'),
('162871;COMPENSACION ;TO1;EC1;'),
('162870;DESCANSO MEDICO;TO1;EC1;'),
('162869;GRATIFICACION;TO1;EC1;'),
('162868;LICENCIA PATERNIDAD;TO1;EC1;'),
('162867;LICENCIA POR LUTO;TO1;EC1;'),
('162866;SUBSIDIO MATERNO;TO1;EC1;'),
('162865;VACACIONES;TO1;EC1;'),
('162864;BONO NOCTURNO;TO1;EC1;'),
('162863;COMISIONES;TO1;EC1;'),
('162862;DOMINICAL;TO1;EC1;'),
('162861;FERIADO;TO1;EC1;'),
('162860;REINTEGRO;TO1;EC1;'),
('162859;REINTEGRO ASIGNACION FAMILIAR;TO1;EC1;'),
('162858;REINTEGRO COMISIONES;TO1;EC1;'),
('162857;REINTEGRO FERIADO;TO1;EC1;'),
('162856;TRABAJO ENM SOBRETIEMPO;TO1;EC1;'),
('162855;BONO POR PRODUCTIVIDAD;TO1;EC1;'),
('162854;MOVILIDAD LABORAL;TO1;EC1;'),
('162853;MOVILIDAD SUJETO A ASISTENCIA;TO1;EC1;'),
('162852;ONP;TO2;EC1;'),
('162851;APORTE AFP;TO2;EC1;'),
('162850;COMISION AFP;TO2;EC1;'),
('162849;AFP SEGUROS;TO2;EC1;'),
('162848;SOBREGIRO;TO2;EC1;'),
('162847;ESSSALUD;TO3;EC1;'),
('162846;EPS;TO3;EC1;'),
('162845;VIDA LEY;TO3;EC1;'),
('162844;LBS: GRATIFICACION;TO1;EC1;'),
('162841;LBS: SUBSIDIO MATERNO;TO1;EC1;'),
('162827;LBS: ONP;TO1;EC1;'),
('162826;LBS: APORTE AFP;TO1;EC1;'),
('162825;LBS: COMISION AFP;TO1;EC1;'),
('162824;LBS: AFP SEGUROS;TO1;EC1;');
```


TAB:
| Codigo | tipoOperacion |
|----------|----------|
| TO1 | Beneficio |
| TO2 | Descuento |
| TO3 | Aporte |

| Codigo | estadoConcepto |
|----------|----------|
| EC1 | Activo |
| EC2 | Inactivo |

| Atributo | Naturaleza  |  Formato  |  Valores validos  |  Unidad  |  Derivada de  |  Descripcion  |  
|----------|----------|----------|----------|----------|----------|----------|
| Id_TipoOperacion| INTEGER | 999999 | 6 dígitos | - | - | Identificador único de tipo de operacion|
| descripcion_TipoOperacion| CHAR(3) | XXX | NOT NULL | - | - | Descripcion de tipo de operacion |


| Atributo | Naturaleza  |  Formato  |  Valores validos  |  Unidad  |  Derivada de  |  Descripcion  | 
|----------|----------|----------|----------|----------|----------|----------|
| Id_estadoConcepto| INTEGER | 999999 | 6 dígitos | - | - | Identificador único de estado del concepto|
| descripcion_estadoConcepto| CHAR(3) | XXX | NOT NULL | - | - | Descripcion del estado de concepto|

