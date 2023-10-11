# unidad 0
CREATE TABLE Planilla (
    id_planilla NUMERIC(6) PRIMARY KEY,
    periodo CHAR(9) NOT NULL,
    dias_laborables NUMERIC(2),
    fechaInicio DATE NOT NULL,
    fechaFinal DATE NOT NULL,
    fechaCalculo DATE,
);

CREATE TABLE BOLETA (
    id_boleta NUMERIC(6) PRIMARY KEY
    id_planilla NUMERIC(6) NOT NULL,
    id_empleado NUMERIC(6) NOT NULL,
    totalIngresos NUMERIC(9,2) NOT NULL,
    totalDescuentos NUMERIC(9,2) NOT NULL,
    totalNeto NUMERIC(9,2) NOT NULL, 
    totalAporte NUMERIC(O,2) NOT NULL
)



CREATE TABLE CONCEPTONOMINA (
    id_concepto INTEGER(6) PRIMARY KEY,
    nombreConcepto VARCHAR(40) NOT NULL,
    tipoOperacion CHAR(3) CHECK (tipoOperacion IN ('TO1', 'TO2', 'TO3')),
    estadoConcepto CHAR(3) CHECK (estadoConcepto IN ('EC1', 'EC2') ),
    valor NUMERIC(1,2),
);

