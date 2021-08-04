% Example of a function, computes the square of a number
% Function returns square of input value x.
% x may be a vector.

% The comment lines above the blank line appear if you type 
% 'help functionExample' (since the file is called functionExample.m) 
% at the command line

% Always put your name and the date so you know who wrote it, and when
% AH 2010.1.29

% Define the function and compute the return value.
% The definition includes input x, also output f, which it 
% calculates below.

function f = functionExample(x);     % define the function
f = x.^2;        % calculate f, the returned value, from x

% Note that the exponentiation is written as .^ (dot carat);
% this way it will operate on each element of an input vector x.
% Element-by-element multiplication would be .*, division ./, etc.
