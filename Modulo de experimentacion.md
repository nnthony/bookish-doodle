# unidad 0
CREATE TABLE Planilla (
    id_planilla INTEGER(6) PRIMARY KEY,
    periodo CHAR(9) NOT NULL,
    dias_laborables NUMERIC(2)
    fechaInicio DATE NOT NULL
    fechaFinal DATE NOT NULL
);

CREATE TABLE AREA (
    id_area INTEGER(2) PRIMARY KEY,
    nombre_area VARCHAR(20) NOT NULL,
    descripcion VARCHAR(100) NOT NULL,
    estado CHAR(1) CHECK (estado IN ('A', 'I')),
   
);

