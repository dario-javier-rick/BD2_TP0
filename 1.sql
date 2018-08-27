-- Motor: PostgreSQL 10.4

----------------------------------------------------------------------------------------
-- Tablas del trabajo práctico N°0

/*
DROP DATABASE IF EXISTS TP0;
DROP TABLE IF EXISTS Censos;
DROP TABLE IF EXISTS Paises;
DROP TABLE IF EXISTS Continentes;
*/

CREATE DATABASE TP0;

CREATE TABLE Continentes
(
  Id SERIAL,
  Nombre VARCHAR(40) NOT NULL
);

CREATE TABLE Paises
(
  Id SERIAL,
  Nombre VARCHAR(40) NOT NULL,
  IdContinente INTEGER NOT NULL,
  FormaGobierno VARCHAR(40) NOT NULL,
  Poblacion BIGINT NOT NULL,
  FechaIndependencia DATE NOT NULL,
  FOREIGN KEY (IdContinente) REFERENCES Continentes (Id)
);

CREATE TABLE Limites
(
  Pais_Id1 INTEGER NOT NULL,
  Pais_Id2 INTEGER NOT NULL,
  ExtensionFrontera REAL NOT NULL,
  FOREIGN KEY (Pais_Id1) REFERENCES Paises (Id),
  FOREIGN KEY (Pais_Id2) REFERENCES Paises (Id)
);

CREATE TABLE Censos
(
  Id SERIAL,
  FechaCenso DATE NOT NULL,
  IdPais INTEGER NOT NULL,
  Poblacion BIGINT NOT NULL,
  FOREIGN KEY (IdPais) REFERENCES Paises (Id)
);
