from coremltools.models.nearest_neighbors import KNearestNeighborsClassifierBuilder

builder = KNearestNeighborsClassifierBuilder(
        input_name="input",
        output_name="output",
        number_of_dimensions=3,
        default_class_label="???",
        number_of_neighbors=5)

spec = builder.spec
spec.description.input[0].shortDescription = "fromStation"
spec.description.output[0].shortDescription = "Predicted Station"
spec.description.output[1].shortDescription = \
        "Probabilities for each possible station"

spec.description.predictedProbabilitiesName = "stationProbability"
spec.description.output[1].name = \
    spec.description.predictedProbabilitiesName
spec.description.trainingInput[0].shortDescription = 'Example input vector'
spec.description.trainingInput[1].shortDescription = 'Associated true label of each example vector'
builder.author = 'Ronan Furuta'
builder.license = 'MIT'
builder.description = 'Classifies {} dimension vector based on 3 nearest neighbors'.format(3)
builder.is_updatable
mlmodel_updatable_path = './UpdatableKNN.mlmodel'

# Save the updated spec
from coremltools.models import MLModel
mlmodel_updatable = MLModel(builder.spec)
mlmodel_updatable.save(mlmodel_updatable_path)