-- Motor: PostgreSQL 10.4

-- Function: get_pop_variation_rate(int)

--DROP CASCADE FUNCTION get_pop_variation_rate();

CREATE OR REPLACE FUNCTION get_pop_variation_rate(_idPais INTEGER) 
  RETURNS real AS
$BODY$
DECLARE

	crecimiento REAL;
	
BEGIN

	RAISE NOTICE 'Se invoca get_pop_variation_rate()';
  
  SELECT 
    (SELECT Poblacion
    FROM Censos
    JOIN Paises
      ON Censos.IdPais = Paises.Id
    WHERE Paises.Id = _idPais
    ORDER BY Censos.Id DESC
    LIMIT 1 OFFSET 1)
    * 100 /
    (SELECT Poblacion
    FROM Censos
    JOIN Paises
      ON Censos.IdPais = Paises.Id
    WHERE Paises.Id = _idPais
    ORDER BY Censos.Id DESC
    LIMIT 1 OFFSET 2)
  INTO crecimiento;
  
	RETURN crecimiento;

	EXCEPTION
	WHEN OTHERS THEN
		RAISE NOTICE 'Ocurrió un error general en get_pop_variation_rate';
	RETURN NULL;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;
ALTER FUNCTION get_pop_variation_rate() OWNER TO postgres;

----------------------------------------------------------------------------------------
