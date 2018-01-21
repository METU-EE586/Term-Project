function [ xTestMatrix, yTestMatrix, probOccupancyMatrix ] = produce_POM( originalMapFile...
    , numOfMeasurements, numTestPoints )
% This function generates Probabilistic Occupancy Map for a given 2D map.
% It simply produces occupancy measurements from the input map 


% originalMapFile: A string indicating the full path of the input image. The image represents
% the original workspace. It may be grayscale or RGB.

% Dependencies: Matlab Robotics System Toolbox.

%% Parameters
gridPerMeter = 10; % It sets the resolution in the occupancy map. There will be this number
                                ...of distinct edges per meter
meanGP = 0;
sigmaPriorGP = 0.5;
scaledLengthGP = 1;
stdMeas = 0.2;

%% Convert the image to map
image = imread(fullfile(originalMapFile)); % Load the image
% image = image(:,:); % Crop it the way you like 
% Convert it to a grayscale image if necessary
if size(image,3) ~= 1 
    image = rgb2gray(image); 
end
imageNorm = double(image)/255;
binaryMap = (imageNorm < 0.01); % % Convert it into a binary matrix, (1: Occupied,  0: Free space)
map = robotics.BinaryOccupancyGrid(binaryMap, gridPerMeter);
show(map); % For checking the map by visual inspection
hold on;

%% Produce random samples from the map.
% A measurement taken from (xi,yi) is either +1 or -1.
% +1: The point is occupied, -1: The point is free.)
[posTrainArray, measArray] = generate_occupancy_measurements(map, numOfMeasurements, stdMeas);
xTrainArray = posTrainArray(:,1); 
yTrainArray = posTrainArray(:,2);

figure;
hold on;
scatter3(xTrainArray(measArray==-1), yTrainArray(measArray==-1), measArray(measArray==-1), 10,...
    'MarkerEdgeColor','r', 'MarkerFaceColor', 'r');
scatter3(xTrainArray(measArray==1), yTrainArray(measArray==1), measArray(measArray==1), 10,...
    'MarkerEdgeColor','b', 'MarkerFaceColor', 'b');
view(45, 25);
title('Occupancy Measurements (+1: Occupied, -1: Free)');

%% Produces estimates via a Gaussian Process to represent the map given occupancy measurements
xLimits = map.XWorldLimits;
yLimits = map.YWorldLimits;

[ posTestArray, estimateArray, covEstimate ] = GP_produce_estimates( xLimits, yLimits...
    , numTestPoints, posTrainArray, measArray, stdMeas, meanGP, sigmaPriorGP, scaledLengthGP );

% figure;
% ax1 = subplot(1,2,1);
% hold on; grid on;
% scatter3(xTrainArray, yTrainArray, measArray, 10, 'MarkerEdgeColor','r',...
%         'MarkerFaceColor', 'r');
% s = surf(xTestMat, yTestMat, estMat, 'FaceAlpha', 0.3);
% s.EdgeColor = 'none';
% shading interp;
% view(-30, 15);
% xlabel('X axis (m)');
% ylabel('Y axis (m)');
% zlabel('Estimated value of the function');
% colorbar;
% 
% ax2 = subplot(1,2,2);
% hold on; grid on;
% scatter3(xTrainArray, yTrainArray, measArray, 10, 'MarkerEdgeColor','r',...
%         'MarkerFaceColor', 'r');
% s = surf(xTestMat, yTestMat, covEstMat, 'FaceAlpha', 0.3);
% s.EdgeColor = 'none';
% shading interp;
% view(-30, 15);
% xlabel('X axis (m)');
% ylabel('Y axis (m)');
% zlabel('Covariance of the estimated value');
% colorbar;
% 
% Link = linkprop([ax1, ax2],{'View'});
% setappdata(gcf, 'StoreTheLink', Link);

%% Calculate Probabilistic Occupancy Grid
... Regarding estimates produced by the GP decide 
threshold = 0;
% Find the probability of being smaller than the threshold for each point considering the mean
% and the covariance of the estimate
probFreeArray = normcdf(threshold * ones(numTestPoints,1), estimateArray, sqrt(diag(covEstimate)));
probOccupancyArray = 1 - probFreeArray;

% Put the results in matrix form
xTestMatrix = reshape(posTestArray(:,1), [sqrt(numTestPoints), sqrt(numTestPoints)]);
yTestMatrix = reshape(posTestArray(:,2), [sqrt(numTestPoints), sqrt(numTestPoints)]);
probOccupancyMatrix = reshape(probOccupancyArray, [sqrt(numTestPoints), sqrt(numTestPoints)]);

% Arrange the order of the matrix so that (1,1) element corresponds to (xMin, yMax)
yTestMatrix = flipud(yTestMatrix);
probOccupancyMatrix = flipud(probOccupancyMatrix);

end

