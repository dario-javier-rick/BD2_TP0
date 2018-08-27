-- Motor: PostgreSQL 10.4

----------------------------------------------------------------------------------------

COPY Paises(Id,Nombre,IdContinente,FormaGobierno,Poblacion,FechaIndependencia) FROM 'paises.csv' DELIMITER ',' CSV HEADER;
