function disp_statistics( X )
%STATISTICS Summary of this function goes here
%   Detailed explanation goes here

if iscell(X)
    disp('Cell with dim: ');
    disp(size(X));
    
elseif ismatrix(X)
    disp('Matrix with dim: ');
    disp(size(X));

elseif isvector(X)
    disp('Matrix with dim: ');
    disp(size(X));
elseif isscalar(X)
    disp('Scalar with value: ');
    disp(X);
end

end

