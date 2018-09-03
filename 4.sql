-- Motor: PostgreSQL 10.4

----------------------------------------------------------------------------------------
-- Vista de población segón censo - trabajo práctico N°0

-- DROP VIEW Poblacion;

CREATE OR REPLACE VIEW Poblacion AS
    SELECT 
      Paises.Id,
      Paises.Nombre,
      DatosUltimoCenso.Poblacion,
      UltimoCenso.FechaCenso,
      CAST(POWER(get_pop_variation_rate(Paises.Id), (UltimoCenso.FechaCenso -  DATE_PART('year', CURRENT_DATE))) AS BIGINT) + DatosUltimoCenso.Poblacion PoblacionEstimada
    FROM Paises
    JOIN (SELECT IdPais,
            MAX(FechaCenso) AS FechaCenso
           FROM Censos
           GROUP BY IdPais) UltimoCenso
      ON UltimoCenso.IdPais = Paises.Id
    JOIN Censos DatosUltimoCenso
      ON (UltimoCenso.IdPais = DatosUltimoCenso.IdPais
          AND UltimoCenso.FechaCenso = DatosUltimoCenso.FechaCenso);

----------------------------------------------------------------------------------------

select * from Poblacion;