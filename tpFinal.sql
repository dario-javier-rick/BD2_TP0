-- Bases de datos 2. Trabajo práctico 0
-- Motor: PostgreSQL 10.4

----------------------------------------------------------------------------------------
-- Punto 1

/*
DROP TABLE IF EXISTS Limites;
DROP TABLE IF EXISTS Censos;
DROP TABLE IF EXISTS Paises;
DROP TABLE IF EXISTS Continentes;
DROP DATABASE IF EXISTS TP0;
*/

CREATE DATABASE TP0;

CREATE TABLE Continentes
(
  Id SERIAL PRIMARY KEY,
  Nombre VARCHAR(40) NOT NULL
);

CREATE TABLE Paises
(
  Id SERIAL PRIMARY KEY,
  Nombre VARCHAR(40) NOT NULL,
  IdContinente INTEGER NOT NULL,
  FormaGobierno VARCHAR(40) NOT NULL,
  Poblacion BIGINT NOT NULL,
  FechaIndependencia DATE,
  FOREIGN KEY (IdContinente) REFERENCES Continentes (Id)
);

CREATE TABLE Limites
(
  Pais_Id1 INTEGER NOT NULL,
  Pais_Id2 INTEGER NOT NULL,
  ExtensionFrontera REAL NOT NULL,
  PRIMARY KEY(Pais_Id1, Pais_Id2),
  FOREIGN KEY (Pais_Id1) REFERENCES Paises (Id),
  FOREIGN KEY (Pais_Id2) REFERENCES Paises (Id)
);

CREATE TABLE Censos
(
  Id SERIAL PRIMARY KEY,
  FechaCenso SMALLINT NOT NULL,
  IdPais INTEGER NOT NULL,
  Poblacion BIGINT NOT NULL,
  FOREIGN KEY (IdPais) REFERENCES Paises (Id)
);

----------------------------------------------------------------------------------------
-- Punto 2

COPY Continentes(Id,Nombre) FROM 'C:\Users\dario\source\repos\BD2_TP0\csv\Datos_paises - Continente.csv' DELIMITER ',' CSV HEADER;
COPY Paises(Id,Nombre,FechaIndependencia,IdContinente,FormaGobierno,Poblacion) FROM 'C:\Users\dario\source\repos\BD2_TP0\csv\Datos_paises - Pais.csv' DELIMITER ',' CSV HEADER;
COPY Censos(IdPais,FechaCenso,Poblacion) FROM 'C:\Users\dario\source\repos\BD2_TP0\csv\Datos_paises - Censo.csv' DELIMITER ',' CSV HEADER;
COPY Limites(Pais_Id1,Pais_Id2,ExtensionFrontera) FROM 'C:\Users\dario\source\repos\BD2_TP0\csv\Datos_paises - Frontera.csv' DELIMITER ',' CSV HEADER;


----------------------------------------------------------------------------------------
-- Punto 3

-- DROP FUNCTION get_pop_variation_rate(_idPais INTEGER) CASCADE;

CREATE OR REPLACE FUNCTION get_pop_variation_rate(_idPais INTEGER) 
  RETURNS REAL AS
$BODY$
DECLARE
	PoblacionCenso1 BIGINT;
	FechaCenso1 INTEGER;
	PoblacionCenso2 BIGINT;
	FechaCenso2 INTEGER;
	Crecimiento REAL;
		
BEGIN

	RAISE NOTICE 'Se invoca get_pop_variation_rate(%)', _idPais;
  
	  SELECT Censos.Poblacion, Censos.FechaCenso
    	INTO PoblacionCenso1, FechaCenso1
	    FROM Censos
	    WHERE Censos.IdPais = _idPais
	    ORDER BY FechaCenso DESC
	    LIMIT 1 OFFSET 0;

	  SELECT Censos.Poblacion, Censos.FechaCenso
    	INTO PoblacionCenso2, FechaCenso2
	    FROM Censos
	    WHERE Censos.IdPais = _idPais
	    ORDER BY FechaCenso DESC
	    LIMIT 1 OFFSET 1;

		IF (FechaCenso1 IS NULL OR FechaCenso2 IS NULL)
			THEN
				RAISE EXCEPTION 'Pais sin censos suficientes --> %', _idPais;
		END IF;

		Crecimiento := ((PoblacionCenso1::REAL * 100 / PoblacionCenso2::REAL) - 100) / (FechaCenso1 - FechaCenso2);

	/*
    RAISE NOTICE 'PoblacionCenso1: %', PoblacionCenso1;
    RAISE NOTICE 'FechaCenso1: %', FechaCenso1;
    RAISE NOTICE 'PoblacionCenso2: %', PoblacionCenso2;
    RAISE NOTICE 'FechaCenso2: %', FechaCenso2;
    RAISE NOTICE 'Crecimiento: %', Crecimiento;
	*/

	RETURN Crecimiento;

	EXCEPTION
	WHEN OTHERS THEN
		RAISE NOTICE 'Ocurrió un error general en get_pop_variation_rate() ';
		RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	RETURN NULL;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

ALTER FUNCTION get_pop_variation_rate(int) OWNER TO postgres;

select postgres.public.get_pop_variation_rate(1);

----------------------------------------------------------------------------------------
-- Punto 4

-- Función auxiliar para aumentar un porcentaje a un numero n veces

CREATE OR REPLACE FUNCTION aplicarIncremento(_numero REAL, _porcentaje REAL, _cantidad INTEGER)
  RETURNS REAL AS
$BODY$
DECLARE
  contador INTEGER := 0 ;
  resultado REAL := _numero;

BEGIN

	RAISE NOTICE 'Se invoca aplicarIncremento(%,%,%)', _numero, _porcentaje, _cantidad;

  LOOP
  EXIT WHEN contador = _cantidad ;
    contador := contador + 1 ;
    resultado := resultado + (resultado * _porcentaje / 100);
  END LOOP ;

	RETURN resultado;

	EXCEPTION
	WHEN OTHERS THEN
		RAISE NOTICE 'Ocurrió un error general en aplicarIncremento() ';
		RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	RETURN NULL;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

ALTER FUNCTION aplicarIncremento(int) OWNER TO postgres;

select aplicarIncremento(100, 10, 2);


-- Vista de población segón censo - trabajo práctico N°0

-- DROP VIEW Poblacion;

CREATE OR REPLACE VIEW Poblacion AS
    SELECT 
      Paises.Id,
      Paises.Nombre,
      DatosUltimoCenso.Poblacion,
      UltimoCenso.FechaCenso AS Fecha_Ultimo_Censo,
      -- Incrementar en porcentaje get_pop_variation_rate(Paises.Id) a los datos del ultimo censo n veces (años de diferencia entre hoy y ultimo censo)
      aplicarIncremento(DatosUltimoCenso.Poblacion::REAL,
        get_pop_variation_rate(Paises.Id)::REAL,
        (DATE_PART('year', CURRENT_DATE) - UltimoCenso.FechaCenso)::INTEGER)::INTEGER Poblacion_Estimada
    FROM Paises
    JOIN (SELECT IdPais,
            MAX(FechaCenso) AS FechaCenso
           FROM Censos
           GROUP BY IdPais) UltimoCenso
      ON UltimoCenso.IdPais = Paises.Id
    JOIN Censos DatosUltimoCenso
      ON (UltimoCenso.IdPais = DatosUltimoCenso.IdPais
          AND UltimoCenso.FechaCenso = DatosUltimoCenso.FechaCenso)
    WHERE 1=1
    ORDER BY Paises.Id ASC;


select * from Poblacion;

----------------------------------------------------------------------------------------
-- Punto 5

----------------------------------------------------------------------------------------
-- Punto 6

CREATE OR REPLACE FUNCTION get_pop_by_continent(_idContinente INTEGER)
  RETURNS BIGINT AS
$BODY$
DECLARE
  PoblacionEstimada BIGINT;

BEGIN

	RAISE NOTICE 'Se invoca get_pop_by_continent(%)', _idContinente;

  SELECT SUM(Poblacion.Poblacion_Estimada)
  INTO PoblacionEstimada
  FROM Poblacion
  JOIN Paises
    ON Poblacion.id = Paises.id
  JOIN Continentes
    ON Paises.IdContinente = Continentes.Id
  WHERE Continentes.Id = _idContinente;

  RETURN PoblacionEstimada;

	EXCEPTION
	WHEN OTHERS THEN
		RAISE NOTICE 'Ocurrió un error general en get_pop_by_continent()';
		RAISE NOTICE '% %', SQLERRM, SQLSTATE;
	RETURN NULL;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

ALTER FUNCTION get_pop_by_continent(int) OWNER TO postgres;

select * from Poblacion;
----------------------------------------------------------------------------------------
-- Punto 7
----------------------------------------------------------------------------------------
-- Punto 8
----------------------------------------------------------------------------------------
-- Punto 9

SELECT p1.Nombre, p2.Nombre, l.ExtensionFrontera
FROM Limites l
JOIN Paises p1
  ON l.Pais_Id1 = p1.Id
JOIN Paises p2
  ON l.Pais_Id2 = p2.Id
ORDER BY l.ExtensionFrontera DESC;

----------------------------------------------------------------------------------------
-- Punto 10

-- Forma 1
SELECT count(*)
FROM paises p1, paises p2, paises p3
WHERE 1=1
AND (p1.Id, p2.Id) IN (SELECT pais_id1, pais_id2 FROM limites);
AND (p2.Id, p3.Id) IN (SELECT pais_id1, pais_id2 FROM limites);
AND (p1.Id, p3.Id) IN (SELECT pais_id1, pais_id2 FROM limites);

-- Forma 2

SELECT *
FROM Limites l1
JOIN Limites l2
  ON l1.pais_id1 = l2.pais_id2
JOIN Limites l3
  ON ((l1.pais_id1 = l3.pais_id1 AND l2.pais_id1 = l3.pais_id2)
      OR (l1.pais_id1 = l3.pais_id2 AND l2.pais_id1 = l3.pais_id1));