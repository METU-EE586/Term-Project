function [ distMatrix ] = GP_compute_distance_matrix( posArray1, posArray2)
%The function computes the distance between two Cartesian coordinate arrays
% Produce a grid structure to be able to compute each distance

xArray1 = posArray1(:,1);
yArray1 = posArray1(:,2);
xArray2 = posArray2(:,1);
yArray2 = posArray2(:,2);

len1 = length(xArray1);
len2 = length(xArray2);

xGrid1 = repmat(xArray1, [1, len2]);
yGrid1 = repmat(yArray1, [1, len2]);
xGrid2 = repmat(transpose(xArray2), [len1, 1]);
yGrid2 = repmat(transpose(yArray2), [len1, 1]);

distMatrix = sqrt((xGrid1-xGrid2).^2 + (yGrid1-yGrid2).^2);
end

