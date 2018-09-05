-- Motor: PostgreSQL 10.4

----------------------------------------------------------------------------------------

-- Forma 1
SELECT count(*)
FROM paises p1, paises p2, paises p3
WHERE 1=1
AND (p1.Id, p2.Id) IN (SELECT pais_id1, pais_id2 FROM limites);
AND (p2.Id, p3.Id) IN (SELECT pais_id1, pais_id2 FROM limites);
AND (p1.Id, p3.Id) IN (SELECT pais_id1, pais_id2 FROM limites);

-- Forma 2

SELECT *
FROM Limites l1
JOIN Limites l2
  ON l1.pais_id1 = l2.pais_id2
JOIN Limites l3
  ON ((l1.pais_id1 = l3.pais_id1 AND l2.pais_id1 = l3.pais_id2)
      OR (l1.pais_id1 = l3.pais_id2 AND l2.pais_id1 = l3.pais_id1));