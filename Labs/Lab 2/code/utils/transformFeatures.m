function [Y] = transformFeatures(X,T)
%TRANSFORMFEATURES

Y(:,1) = T(1,1) * X(:,1) + T(1,2) * X(:,2) + T(1,3);
Y(:,2) = T(2,1) * X(:,1) + T(2,2) * X(:,2) + T(2,3);

k = T(3,1) * X(:,1) + T(3,2) * X(:,2) + T(3,3);

Y = Y ./ k;

end

