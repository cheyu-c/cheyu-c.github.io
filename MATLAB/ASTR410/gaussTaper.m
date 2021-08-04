function [T] = gaussTaper(A, fwhm)
% Make a matrix with Gaussian taper for weighting in uv plane
% Input
%  A:    matrix with size to be weighted
%  fwhm: full width to half maximum in index coordinates
% Result
%  matrix with weighting function
%
% AH 2010.3.17

T = A;
[nr, nc] = size(T);

sc = -4.*log(2)/fwhm^2;

rctr = nr/2 + 1;
cctr = nc/2 + 1;

for i = 1:nr
    for j = 1:nc
        T(i, j) = exp(sc*((i-rctr)^2 + (j-cctr)^2));
    end
end
