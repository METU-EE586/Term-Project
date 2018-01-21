% This file illustrates how to produce a Probabilistic Occupacy map by using 'produce_POM'
% function.
clc;
clear;
close all;

% Parameters
mapFile = 'mazeWithThickWalls.png';
numOfMeasurements = 2000;
numTestPoints = 1600; % Set the value as X^2

% Call produce_POM
[ xTestMatrix, yTestMatrix, probOccupancyMatrix ] = produce_POM(mapFile, numOfMeasurements...
    , numTestPoints);

% Plot results
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