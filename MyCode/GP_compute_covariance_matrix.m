function [ covMatrix ] = compute_covariance_matrix( distMatrix, sigmaPrior, scaledLength)

covMatrix = sigmaPrior^2 * exp(-distMatrix.^2 / scaledLength^2);

end


