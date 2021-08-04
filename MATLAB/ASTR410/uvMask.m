function [maskMat] = uvMask(h, d, az, el, lat, dec, nstep, n, uvsc) 
%% Make a masking matrix with a uv track for a single antenna pair
%
% Inputs
%   h; hour angle values [rad]
%   d;  baseline length
%   az; baseline azimuth angle [rad]
%   el; baseline elevation angle [rad]
%   lat; observatory latitude [rad]
%   dec; source declination [rad]
%   nstep; number of steps in calculation
%   n; size of mask matrix
%   uvsc; scaling for matrix transfer
% Output
%   mask matrix with dimension n*n, values 0. or 1. 
%
% AH 2010.3.16


%% Set up

maskMat = zeros(n, n);

%% Calculations

% calculate uv track
UVW = uvTrack(h, d, az, el, lat, dec, nstep);

% generate mask matrix with 1s where uv track passes
% normalize u, v (and w) by maximum values, then to array indices
% fill matrix with where uv track passes
ctr = n/2 + 1;
for i=1:nstep
    maskMat(ctr+round(UVW(i,1)*uvsc), ctr+round(UVW(i,2)*uvsc)) = 1.;
    maskMat(ctr-round(UVW(i,1)*uvsc), ctr-round(UVW(i,2)*uvsc)) = 1.;
end
