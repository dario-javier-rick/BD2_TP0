CREATE OR REPLACE FUNCTION get_pop_variation_rate(_idPais INTEGER) 
  RETURNS real AS
$BODY$
DECLARE
	PoblacionCenso1 INTEGER;
	FechaCenso1 DATE;
	PoblacionCenso2 INTEGER;
	FechaCenso2 DATE;
	Crecimiento REAL;
		
BEGIN

	RAISE NOTICE 'Se invoca get_pop_variation_rate()';
  
	  SELECT Poblacion, FechaCenso
    	INTO PoblacionCenso1, FechaCenso1
	    FROM Censos
	    JOIN Paises
	      ON Censos.IdPais = Paises.Id
	    WHERE Paises.Id = _idPais
	    ORDER BY FechaCenso DESC
	    LIMIT 1 OFFSET 1;

	  SELECT Poblacion, FechaCenso
    	INTO PoblacionCenso2, FechaCenso2
	    FROM Censos
	    JOIN Paises
	      ON Censos.IdPais = Paises.Id
	    WHERE Paises.Id = _idPais
	    ORDER BY FechaCenso DESC
	    LIMIT 1 OFFSET 2;

	  SELECT (PoblacionCenso1 * 100 / PoblacionCenso2) / DATEDIFF(year, FechaCenso1, FechaCenso2)
	  INTO Crecimiento;

	RETURN Crecimiento;

	EXCEPTION
	WHEN OTHERS THEN
		RAISE NOTICE 'Ocurrió un error general en get_pop_variation_rate';
	RETURN NULL;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION get_pop_variation_rate(int) OWNER TO postgres;
