-- Motor: PostgreSQL 10.4

----------------------------------------------------------------------------------------
-- Tablas del trabajo práctico N°0

/*
DROP TABLE IF EXISTS Censos;
DROP TABLE IF EXISTS Limites;
DROP TABLE IF EXISTS Paises;
DROP TABLE IF EXISTS Continentes;
DROP DATABASE IF EXISTS TP0;
*/

CREATE DATABASE TP0;

CREATE TABLE Continentes
(
  Id SERIAL PRIMARY KEY,
  Nombre VARCHAR(40) NOT NULL
);

CREATE TABLE Paises
(
  Id SERIAL PRIMARY KEY,
  Nombre VARCHAR(40) NOT NULL,
  IdContinente INTEGER NOT NULL,
  FormaGobierno VARCHAR(40) NOT NULL,
  Poblacion BIGINT NOT NULL,
  FechaIndependencia DATE,
  FOREIGN KEY (IdContinente) REFERENCES Continentes (Id)
);

CREATE TABLE Limites
(
  Pais_Id1 INTEGER NOT NULL,
  Pais_Id2 INTEGER NOT NULL,
  ExtensionFrontera REAL NOT NULL,
  PRIMARY KEY(Pais_Id1, Pais_Id2),
  FOREIGN KEY (Pais_Id1) REFERENCES Paises (Id),
  FOREIGN KEY (Pais_Id2) REFERENCES Paises (Id)
);

CREATE TABLE Censos
(
  Id SERIAL PRIMARY KEY,
  FechaCenso SMALLINT NOT NULL,
  IdPais INTEGER NOT NULL,
  Poblacion BIGINT NOT NULL,
  FOREIGN KEY (IdPais) REFERENCES Paises (Id)
);
