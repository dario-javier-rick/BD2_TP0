-- Motor: PostgreSQL 10.4

-- Function: get_pop_variation_rate(int)
----------------------------------------------------------------------------------------

--DROP CASCADE FUNCTION get_pop_variation_rate();

CREATE OR REPLACE FUNCTION get_pop_variation_rate(_idPais INTEGER) 
  RETURNS real AS
$BODY$
DECLARE
	PoblacionCenso1 BIGINT;
	FechaCenso1 INTEGER;
	PoblacionCenso2 BIGINT;
	FechaCenso2 INTEGER;
	Crecimiento REAL;
		
BEGIN

	RAISE NOTICE 'Se invoca get_pop_variation_rate()';
  
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

	  Crecimiento := (PoblacionCenso1 * 100 / PoblacionCenso2) / (FechaCenso1 - FechaCenso2);

	  raise notice 'PoblacionCenso1: %', PoblacionCenso1;
	  raise notice 'FechaCenso1: %', FechaCenso1;
    raise notice 'PoblacionCenso2: %', PoblacionCenso2;
    raise notice 'FechaCenso2: %', FechaCenso2;
    raise notice 'Crecimiento: %', Crecimiento;

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

----------------------------------------------------------------------------------------

select get_pop_variation_rate(2);

