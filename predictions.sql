USE irissql
GO

CREATE PROCEDURE predict_species (@model VARCHAR(100))
AS
BEGIN
    DECLARE @nb_model VARBINARY(max) = (
            SELECT model
            FROM iris_models
            WHERE model_name = @model
            );

    EXECUTE sp_execute_external_script @language = N'Python'
        , @script = N'
import pickle
irismodel = pickle.loads(nb_model)
species_pred = irismodel.predict(iris_data[["Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width"]])
iris_data["PredictedSpecies"] = species_pred
OutputDataSet = iris_data[["id","SpeciesId","PredictedSpecies"]] 
print(OutputDataSet)
'
        , @input_data_1 = N'select id, "Sepal.Length", "Sepal.Width", "Petal.Length", "Petal.Width", "SpeciesId" from iris_data'
        , @input_data_1_name = N'iris_data'
        , @params = N'@nb_model varbinary(max)'
        , @nb_model = @nb_model
    WITH RESULT SETS((
                "id" INT
              , "SpeciesId" INT
              , "SpeciesId.Predicted" INT
                ));
END
GO

-- Execute the Predictions Model
EXEC predict_species 'Naive Bayes'
GO

