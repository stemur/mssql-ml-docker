USE irissql
GO

CREATE PROCEDURE get_iris_dataset
AS

BEGIN
    EXEC sp_execute_external_script @language = N'Python', 
    @script = N'
from sklearn import datasets
iris = datasets.load_iris()
iris_data = pandas.DataFrame(iris.data)
iris_data["Species"] = pandas.Categorical.from_codes(iris.target, iris.target_names)
iris_data["SpeciesId"] = iris.target
',
    @input_data_1 = N'',
    @output_data_1_name = N'iris_data'
    WITH RESULT SETS (("Sepal.Length" float not null, "Sepal.Width" float not null, "Petal.Length" float not null, "Petal.Width" float not null, "Species" varchar(100) not null, "SpeciesId" int not null));
END;
GO

-- Run the Stored Procedure to get the iris data and populate the iris_data table
INSERT INTO iris_data([Sepal.Length], [Sepal.Width], [Petal.Length], [Petal.Width], Species, SpeciesId)
EXEC dbo.get_iris_dataset
GO

-- Check the dataset has loaded correctly by querying the table
SELECT *
FROM iris_data
GO
