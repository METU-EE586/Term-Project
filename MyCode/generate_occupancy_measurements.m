function [ posArray, measArray ] = generate_occupancy_measurements( map, numOfMeasurements...
                                    , stdMeas)
% This function produces noisy occupancy measurements of an input map

% 'map': is a BinaryOccupancyGrid type variable representing the occupancy of the environment
        ...in a binary fashion. 

% Find position limits on X and Y axes
xLimits = map.XWorldLimits;
yLimits = map.YWorldLimits;

xLength = xLimits(2) - xLimits(1);
yLength = yLimits(2) - yLimits(1);

realXCoorArray = rand(numOfMeasurements, 1) * xLength + xLimits(1);
realYCoorArray = rand(numOfMeasurements, 1) * yLength + yLimits(1);

occupArray = getOccupancy(map, [realXCoorArray realYCoorArray]); % Real occupancy information 
% of corresponding points

% Add some noise to the locations of the measurements. This where measurement production
% procedure is rendered to be random.
xArray = realXCoorArray + stdMeas * randn(numOfMeasurements, 1);
yArray = realYCoorArray + stdMeas * randn(numOfMeasurements, 1);
posArray = [xArray yArray];

% A measurement taken from (xi,yi) is either +1 or -1.
% +1: The point is occupied, -1: The point is free.)
measArray = zeros(numOfMeasurements, 1);
measArray(occupArray) = 1;
measArray(~occupArray) = -1;

end

