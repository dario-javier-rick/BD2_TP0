-- Motor: PostgreSQL 10.4

----------------------------------------------------------------------------------------

SELECT *
FROM Limites l
JOIN Paises p1
  ON l.Pais_Id1 = p1.Id
JOIN Paises p2
  ON l.Pais_Id2 = p2.Id
ORDER BY l.ExtensionFrontera DESC;
