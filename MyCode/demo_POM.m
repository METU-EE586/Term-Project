clc;
clear;
close all;

numOfMeasurements = 5000;
numTestPoints = 2500;

[ xTestMatrix, yTestMatrix, probOccupancyMatrix ] = produce_POM('ellipseAndDiamond.png'...
    ,numOfMeasurements, numTestPoints );

%% Plot results
figure;
hold on; grid on;
s = surf(xTestMatrix, yTestMatrix, probOccupancyMatrix, 'FaceAlpha', 0.7);
colorbar;
s.EdgeColor = 'none';
shading interp;
view(45, 25);
title('Probabilistic Occupancy Map Produced by GP');
xlabel('X axis (m)');
ylabel('Y axis (m)');