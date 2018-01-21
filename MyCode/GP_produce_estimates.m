function [ posTestArray, estimateArray, covEstimate ] = GP_produce_estimates( xLimits, yLimits, numTestPoints...
    , posTrainArray, measArray, stdMeas, meanGP, sigmaPriorGP, scaledLengthGP )
% Produces estimate values for the test points by a GP regarding measArray that is measured
...at posTrainArray = [xTrainArray yTrainArray]

numOfMeasurements = length(measArray);

% Determine the points at which the "occupancy function" is to be tested
xMin = xLimits(1);
xMax = xLimits(2);
yMin = yLimits(1);
yMax = yLimits(2);

xLen = xMax - xMin;
yLen = yMax - yMin;

numTestPointPerAxis = sqrt(numTestPoints);

xTestArray = linspace(xMin + xLen/(2*numTestPointPerAxis), xMax - xLen/(2*numTestPointPerAxis)...
    , numTestPointPerAxis);
yTestArray = linspace(yMin + yLen/(2*numTestPointPerAxis), yMax - yLen/(2*numTestPointPerAxis)...
    , numTestPointPerAxis);
[xTestMatrix, yTestMatrix] = meshgrid(xTestArray, yTestArray);
xTestArray = xTestMatrix(:);
yTestArray = yTestMatrix(:);
posTestArray = [xTestArray yTestArray];

% Calculate the distance matrices between each points of training and test points
distBtwTrainingMat = GP_compute_distance_matrix(posTrainArray, posTrainArray);
distBtwTestTrainingMat = GP_compute_distance_matrix(posTestArray, posTrainArray);
distBtwTestMat = GP_compute_distance_matrix(posTestArray, posTestArray);

% Calculate covariances
covTraining = GP_compute_covariance_matrix(distBtwTrainingMat, sigmaPriorGP, scaledLengthGP)...
    + stdMeas * eye(numOfMeasurements);
covTestTraining = GP_compute_covariance_matrix(distBtwTestTrainingMat, sigmaPriorGP, scaledLengthGP);
covTest = GP_compute_covariance_matrix(distBtwTestMat, sigmaPriorGP, scaledLengthGP);

% Compute the mean and covariance of the estimates
estimateArray = meanGP + covTestTraining * inv(covTraining) * (measArray-meanGP);
covEstimate = covTest - covTestTraining * inv(covTraining) * transpose(covTestTraining);

end

