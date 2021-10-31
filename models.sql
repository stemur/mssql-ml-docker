USE irissql
GO

CREATE PROCEDURE generate_iris_model (@trained_model VARBINARY(max) OUTPUT)
AS
BEGIN
    EXECUTE sp_execute_external_script @language = N'Python'
        , @script = N'
import pickle
from sklearn.naive_bayes import GaussianNB
GNB = GaussianNB()
trained_model = pickle.dumps(GNB.fit(iris_data[["Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"]], iris_data[["SpeciesId"]].values.ravel()))
'
        , @input_data_1 = N'select "Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "SpeciesId" from iris_data'
        , @input_data_1_name = N'iris_data'
        , @params = N'@trained_model varbinary(max) OUTPUT'
        , @trained_model = @trained_model OUTPUT;
END
GO

-- Create and Train the Models
DECLARE @model VARBINARY(max);
DECLARE @new_model_name VARCHAR(50)
SET @new_model_name = 'Naive Bayes'
EXECUTE generate_iris_model @model OUTPUT;
DELETE iris_models WHERE model_name = @new_model_name;
INSERT INTO iris_models (model_name, model) 
VALUES(@new_model_name, @model);
GO

-- Verify the Model was created
SELECT *
FROM iris_models
GO
