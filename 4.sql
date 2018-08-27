-- Motor: PostgreSQL 10.4

----------------------------------------------------------------------------------------
-- Vista de población segón censo - trabajo práctico N°0

CREATE VIEW Poblacion AS
    SELECT 
      Paises.Id,
      Paises.Nombre,
      UltimoCenso.Poblacion,
      UltimoCenso.FechaCenso,
      POWER(get_pop_variation_rate(Paises.Id), 
            DATEDIFF(year, UltimoCenso.FechaCenso, CURRENT_DATE)) PoblacionEstimada
    FROM Paises
    JOIN (SELECT IdPais 
                 Poblacion, 
                 MAX(FechaCenso) FechaCenso
          FROM Censos
          GROUP BY FechaCenso) UltimoCenso
      ON UltimoCenso.IdPais = Paises.Id;
