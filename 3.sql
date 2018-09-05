-- Motor: PostgreSQL 10.4

-- Function: get_pop_variation_rate(int)
----------------------------------------------------------------------------------------

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

----------------------------------------------------------------------------------------

select postgres.public.get_pop_variation_rate(1);

