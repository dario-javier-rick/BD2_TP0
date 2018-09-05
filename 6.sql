-- Motor: PostgreSQL 10.4

-- Function: get_pop_by_continent(int)
----------------------------------------------------------------------------------------

--DROP CASCADE FUNCTION get_pop_by_continent();

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

----------------------------------------------------------------------------------------

select get_pop_by_continent(2);