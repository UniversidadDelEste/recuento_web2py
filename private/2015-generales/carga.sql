BEGIN;

/* script SQL para importar datos publicos Elecciones PASO Nacionales 2015 */

/*

Descargar y descomprimir los siguientes archivos en el directorio temporal:

http://www.elecciones.gov.ar/articulo_princ.php?secc=2&sub_secc=55

Cambios desde 2015 PASO (datos provisorios): 

 * Falta FMESSN_1424.csv (datos de senadores nacionales varias provincias)
 * Menos mesas (79057 de las generales vs 94236 de las PASO)
 
*/

/* creo un esquema para alojar las tablas "temporales" */

DROP SCHEMA IF EXISTS tmp CASCADE;
CREATE SCHEMA tmp;

/* provincias: crear tabla e importar datos publicos */

CREATE TABLE tmp.provincias (
    codigo_provincia INTEGER PRIMARY KEY,
    provincia VARCHAR(50)
);

COPY tmp.provincias
    FROM '/tmp/PROVINCIAS.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';' );

/* departamentos: crear tabla e importar datos publicos */

CREATE TABLE tmp.departamentos (
    codigo_departamento INTEGER,
    codigo_provincia INTEGER,
    departamento VARCHAR(50),
    PRIMARY KEY (codigo_provincia, codigo_departamento)
);

COPY tmp.departamentos
    FROM '/tmp/DEPARTAMENTOS.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';', ENCODING 'latin1' );

/* partidos: crear tabla e importar datos publicos */

CREATE TABLE tmp.partidos (
    codigo_partido INTEGER PRIMARY KEY,
    partido VARCHAR(250),
    lista_interna VARCHAR(250),
    agrupacion INTEGER REFERENCES tmp.partidos(codigo_partido)
);

COPY tmp.partidos
    FROM '/tmp/FPARTIDOS.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';', ENCODING 'latin1' );

/* resultados para presidente: crear tabla e importar datos publicos */

CREATE TABLE tmp.presidente (
    codigo_provincia INTEGER REFERENCES tmp.provincias(codigo_provincia),
    codigo_departamento INTEGER,
    codigo_circuito VARCHAR(5),
    codigo_mesa INTEGER,
    ambito TEXT, -- nuevo!
    codigo_partido INTEGER REFERENCES tmp.partidos(codigo_partido),
    votos INTEGER NOT NULL CHECK (votos BETWEEN 0 AND 999),
    PRIMARY KEY (codigo_provincia, codigo_departamento, codigo_mesa, codigo_partido),
    FOREIGN KEY (codigo_provincia, codigo_departamento) 
    REFERENCES tmp.departamentos(codigo_provincia, codigo_departamento)
);

COPY tmp.presidente
    FROM '/tmp/FMESPR_0101.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';' );

COPY tmp.presidente
    FROM '/tmp/FMESPR_0202.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';' );

COPY tmp.presidente
    FROM '/tmp/FMESPR_0313.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';' );

COPY tmp.presidente
    FROM '/tmp/FMESPR_1424.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';' );

/* resultados para senadores nac.: crear tabla e importar datos publicos */

CREATE TABLE tmp.senadores (
    codigo_provincia INTEGER REFERENCES tmp.provincias(codigo_provincia),
    codigo_departamento INTEGER,
    codigo_circuito VARCHAR(5),
    codigo_mesa INTEGER,
    ambito TEXT, -- nuevo!
    codigo_partido INTEGER REFERENCES tmp.partidos(codigo_partido),
    votos INTEGER NOT NULL CHECK (votos BETWEEN 0 AND 999),
    PRIMARY KEY (codigo_provincia, codigo_departamento, codigo_mesa, codigo_partido),
    FOREIGN KEY (codigo_provincia, codigo_departamento) 
     REFERENCES tmp.departamentos(codigo_provincia, codigo_departamento)
);

COPY tmp.senadores
    FROM '/tmp/FMESSN_0313.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';' );


/* resultados para diputados nac.: crear tabla e importar datos publicos */

CREATE TABLE tmp.diputados (
    codigo_provincia INTEGER REFERENCES tmp.provincias(codigo_provincia),
    codigo_departamento INTEGER,
    codigo_circuito VARCHAR(6), /* 1008.0 */
    codigo_mesa INTEGER,
    ambito TEXT, -- nuevo!
    codigo_partido INTEGER REFERENCES tmp.partidos(codigo_partido),
    votos INTEGER NOT NULL CHECK (votos BETWEEN 0 AND 999),
    PRIMARY KEY (codigo_provincia, codigo_departamento, codigo_mesa, codigo_partido),
    FOREIGN KEY (codigo_provincia, codigo_departamento)
     REFERENCES tmp.departamentos(codigo_provincia, codigo_departamento)
);

COPY tmp.diputados
    FROM '/tmp/FMESDN_0101.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';' );

COPY tmp.diputados
    FROM '/tmp/FMESDN_0202.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';' );

COPY tmp.diputados
    FROM '/tmp/FMESDN_0313.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';' );

COPY tmp.diputados
    FROM '/tmp/FMESDN_1424.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';' );


/* resultados para gobernador PBA: crear tabla e importar datos publicos */

CREATE TABLE tmp.gobernador (
    codigo_provincia INTEGER REFERENCES tmp.provincias(codigo_provincia),
    codigo_departamento INTEGER,
    codigo_circuito VARCHAR(6), /* 1008.0 */
    codigo_mesa INTEGER,
    ambito TEXT, -- nuevo!
    codigo_partido INTEGER REFERENCES tmp.partidos(codigo_partido),
    votos INTEGER NOT NULL CHECK (votos BETWEEN 0 AND 999),
    PRIMARY KEY (codigo_provincia, codigo_departamento, codigo_mesa, codigo_partido),
    FOREIGN KEY (codigo_provincia, codigo_departamento)
     REFERENCES tmp.departamentos(codigo_provincia, codigo_departamento)
);

COPY tmp.gobernador
    FROM '/tmp/FMESGO_0202.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';' );


/* resultados para senadores prov.: crear tabla e importar datos publicos */

CREATE TABLE tmp.senadores_prov (
    codigo_provincia INTEGER REFERENCES tmp.provincias(codigo_provincia),
    codigo_departamento INTEGER,
    codigo_circuito VARCHAR(5),
    codigo_mesa INTEGER,
    ambito TEXT, -- nuevo!
    codigo_partido INTEGER REFERENCES tmp.partidos(codigo_partido),
    votos INTEGER NOT NULL CHECK (votos BETWEEN 0 AND 999),
    PRIMARY KEY (codigo_provincia, codigo_departamento, codigo_mesa, codigo_partido),
    FOREIGN KEY (codigo_provincia, codigo_departamento) 
     REFERENCES tmp.departamentos(codigo_provincia, codigo_departamento)
);

COPY tmp.senadores_prov
    FROM '/tmp/FMESSP_0202.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';' );


COPY tmp.senadores_prov
    FROM '/tmp/FMESSP_0313.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';' );

COPY tmp.senadores_prov
    FROM '/tmp/FMESSP_1424.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';' );

/* resultados para diputados prov.: crear tabla e importar datos publicos */

CREATE TABLE tmp.diputados_prov (
    codigo_provincia INTEGER REFERENCES tmp.provincias(codigo_provincia),
    codigo_departamento INTEGER,
    codigo_circuito VARCHAR(6), /* 1008.0 */
    codigo_mesa INTEGER,
    ambito TEXT, -- nuevo!
    codigo_partido INTEGER REFERENCES tmp.partidos(codigo_partido),
    votos INTEGER NOT NULL CHECK (votos BETWEEN 0 AND 999),
    PRIMARY KEY (codigo_provincia, codigo_departamento, codigo_mesa, codigo_partido),
    FOREIGN KEY (codigo_provincia, codigo_departamento)
     REFERENCES tmp.departamentos(codigo_provincia, codigo_departamento)
);

COPY tmp.diputados_prov
    FROM '/tmp/FMESDP_0202.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';' );

COPY tmp.diputados_prov
    FROM '/tmp/FMESDP_0313.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';' );

COPY tmp.diputados_prov
    FROM '/tmp/FMESDP_1424.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';' );


/* resultados municipales PBA: crear tabla e importar datos publicos */

CREATE TABLE tmp.municipales (
    codigo_provincia INTEGER REFERENCES tmp.provincias(codigo_provincia),
    codigo_departamento INTEGER,
    codigo_circuito VARCHAR(6), /* 1008.0 */
    codigo_mesa INTEGER,
    ambito TEXT, -- nuevo!
    codigo_partido INTEGER REFERENCES tmp.partidos(codigo_partido),
    votos INTEGER NOT NULL CHECK (votos BETWEEN 0 AND 999),
    PRIMARY KEY (codigo_provincia, codigo_departamento, codigo_mesa, codigo_partido),
    FOREIGN KEY (codigo_provincia, codigo_departamento)
     REFERENCES tmp.departamentos(codigo_provincia, codigo_departamento)
);

COPY tmp.municipales
    FROM '/tmp/FMESMU_0202.csv' 
    WITH ( FORMAT CSV, HEADER, DELIMITER ';' );


/* elimino .0 y 0 a la izquierda en codigo de circuitos */

UPDATE tmp.presidente SET codigo_circuito = REPLACE(codigo_circuito, '.0', '') WHERE codigo_circuito LIKE '%\.%';
UPDATE tmp.senadores SET codigo_circuito = REPLACE(codigo_circuito, '.0', '') WHERE codigo_circuito LIKE '%\.%';
UPDATE tmp.diputados SET codigo_circuito = REPLACE(codigo_circuito, '.0', '') WHERE codigo_circuito LIKE '%\.%';
UPDATE tmp.gobernador SET codigo_circuito = REPLACE(codigo_circuito, '.0', '') WHERE codigo_circuito LIKE '%\.%';
UPDATE tmp.senadores_prov SET codigo_circuito = REPLACE(codigo_circuito, '.0', '') WHERE codigo_circuito LIKE '%\.%';
UPDATE tmp.diputados_prov SET codigo_circuito = REPLACE(codigo_circuito, '.0', '') WHERE codigo_circuito LIKE '%\.%';
UPDATE tmp.municipales SET codigo_circuito = REPLACE(codigo_circuito, '.0', '') WHERE codigo_circuito LIKE '%\.%';

UPDATE tmp.presidente SET codigo_circuito = TRIM(LEADING '0' FROM codigo_circuito) WHERE codigo_circuito LIKE '0%';
UPDATE tmp.senadores SET codigo_circuito = TRIM(LEADING '0' FROM codigo_circuito) WHERE codigo_circuito LIKE '0%';
UPDATE tmp.diputados SET codigo_circuito = TRIM(LEADING '0' FROM codigo_circuito) WHERE codigo_circuito LIKE '0%';
UPDATE tmp.gobernador SET codigo_circuito = TRIM(LEADING '0' FROM codigo_circuito) WHERE codigo_circuito LIKE '0%';
UPDATE tmp.senadores_prov SET codigo_circuito = TRIM(LEADING '0' FROM codigo_circuito) WHERE codigo_circuito LIKE '0%';
UPDATE tmp.diputados_prov SET codigo_circuito = TRIM(LEADING '0' FROM codigo_circuito) WHERE codigo_circuito LIKE '0%';
UPDATE tmp.municipales SET codigo_circuito = TRIM(LEADING '0' FROM codigo_circuito) WHERE codigo_circuito LIKE '0%';


/* creo algunas vistas y tabla para extraer los circuitos/mesas */

CREATE OR REPLACE VIEW tmp.mesas_presidente AS 
  SELECT DISTINCT codigo_provincia, codigo_departamento, codigo_circuito, codigo_mesa FROM tmp.presidente;
CREATE OR REPLACE VIEW tmp.mesas_senadores AS 
  SELECT DISTINCT codigo_provincia, codigo_departamento, codigo_circuito, codigo_mesa FROM tmp.senadores;
CREATE OR REPLACE VIEW tmp.mesas_diputados AS 
  SELECT DISTINCT codigo_provincia, codigo_departamento, codigo_circuito, codigo_mesa FROM tmp.diputados;
CREATE OR REPLACE VIEW tmp.mesas_gobernador AS 
  SELECT DISTINCT codigo_provincia, codigo_departamento, codigo_circuito, codigo_mesa FROM tmp.gobernador;
CREATE OR REPLACE VIEW tmp.mesas_senadores_prov AS 
  SELECT DISTINCT codigo_provincia, codigo_departamento, codigo_circuito, codigo_mesa FROM tmp.senadores_prov;
CREATE OR REPLACE VIEW tmp.mesas_diputados_prov AS 
  SELECT DISTINCT codigo_provincia, codigo_departamento, codigo_circuito, codigo_mesa FROM tmp.diputados_prov;
CREATE OR REPLACE VIEW tmp.mesas_municipales AS 
  SELECT DISTINCT codigo_provincia, codigo_departamento, codigo_circuito, codigo_mesa FROM tmp.municipales;

CREATE TABLE tmp.mesas AS 
  SELECT DISTINCT C.* FROM (
    SELECT * FROM tmp.mesas_presidente UNION
    SELECT * FROM tmp.mesas_diputados UNION 
    SELECT * FROM tmp.mesas_senadores UNION 
    SELECT * FROM tmp.mesas_gobernador UNION 
    SELECT * FROM tmp.mesas_diputados_prov UNION 
    SELECT * FROM tmp.mesas_senadores_prov UNION 
    SELECT * FROM tmp.mesas_municipales 
    ) C
  ORDER BY codigo_provincia, codigo_departamento, codigo_mesa;

/* agrego la columna de ubicacion de la app para simplificar consultas*/
ALTER TABLE tmp.mesas ADD COLUMN id_ubicacion INTEGER;   

COMMIT;

