-- Motor: PostgreSQL 10.4

----------------------------------------------------------------------------------------
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

-- select aplicarIncremento(100, 10, 2);

----------------------------------------------------------------------------------------

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

----------------------------------------------------------------------------------------

select * from Poblacion;