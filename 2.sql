-- Motor: PostgreSQL 10.4

----------------------------------------------------------------------------------------

COPY Continentes(Id,Nombre) FROM 'C:\Users\dario\source\repos\BD2_TP0\csv\Datos_paises - Continente.csv' DELIMITER ',' CSV HEADER;
COPY Paises(Id,Nombre,FechaIndependencia,IdContinente,FormaGobierno,Poblacion) FROM 'C:\Users\dario\source\repos\BD2_TP0\csv\Datos_paises - Pais.csv' DELIMITER ',' CSV HEADER;
COPY Censos(IdPais,FechaCenso,Poblacion) FROM 'C:\Users\dario\source\repos\BD2_TP0\csv\Datos_paises - Censo.csv' DELIMITER ',' CSV HEADER;
COPY Limites(Pais_Id1,Pais_Id2,ExtensionFrontera) FROM 'C:\Users\dario\source\repos\BD2_TP0\csv\Datos_paises - Frontera.csv' DELIMITER ',' CSV HEADER;