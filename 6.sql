-- Motor: PostgreSQL 10.4

-- Function: get_pop_by_continent(int)
----------------------------------------------------------------------------------------

--DROP CASCADE FUNCTION get_pop_by_continent();

CREATE OR REPLACE FUNCTION get_pop_by_continent(_idPais INTEGER)
  RETURNS real AS
$BODY$
DECLARE
  -- TODO...

BEGIN

	RAISE NOTICE 'Se invoca get_pop_by_continent()';

  -- TODO...

	EXCEPTION
	WHEN OTHERS THEN
		RAISE NOTICE 'Ocurrió un error general en get_pop_by_continent';
	RETURN NULL;

END;
$BODY$
  LANGUAGE plpgsql VOLATILE
  COST 100;

ALTER FUNCTION get_pop_by_continent(int) OWNER TO postgres;

----------------------------------------------------------------------------------------

select get_pop_by_continent(1);