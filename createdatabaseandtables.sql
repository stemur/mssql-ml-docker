-- Create the Database
CREATE DATABASE irissql
GO

USE irissql
GO


-- Create the Tables
-- iris_data
DROP TABLE IF EXISTS iris_data
GO

CREATE TABLE iris_data (
    id INT NOT NULL IDENTITY PRIMARY KEY,
    [Sepal.Length] FLOAT NOT NULL,
    [Sepal.Width] FLOAT NOT NULL,
    [Petal.Length] FLOAT NOT NULL,
    [Petal.Width] FLOAT NOT NULL,
    Species VARCHAR(100) NOT NULL,
    SpeciesId INT NOT NULL
)
GO

-- iris_models
DROP TABLE IF EXISTS iris_models
GO

CREATE TABLE iris_models (
    model_name VARCHAR(50) NOT NULL DEFAULT('default model') PRIMARY KEY,
    model VARBINARY(MAX) NOT NULL
)
GO
