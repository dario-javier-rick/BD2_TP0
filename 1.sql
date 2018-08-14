-- Motor: PostgreSQL 10.4

----------------------------------------------------------------------------------------
-- Tablas del trabajo práctico N°0

CREATE DATABASE TP0;

CREATE TABLE Continente
(
Id SERIAL,
Nombre VARCHAR(40) NOT NULL
);

CREATE TABLE Paises
(
Id SERIAL,
Nombre VARCHAR(40) NOT NULL,
FechaIndependencia DATE NOT NULL,
IdContinente INTEGER NOT NULL,
FormaGobierno VARCHAR(40),
Poblacion BIGINT
);
