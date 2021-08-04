%% Vectors, Matrices, and Arrays: Basic Operations
%% Visualization
% Assume we have
SampleArray = [1:5;2:6;3:7;4:8;5:9];
%%
% We can plot this data array by calling the function *|imagesc|*
imagesc(SampleArray)
%%
% Use the *|colorbar|* command to see what the colorcode refers to:
colorbar;
%% Basic Calculation
% Simple math between two arrays with same size is straightforward. For
% example,
A = [1 2 3; 4 5 6];
B = [1 4 9; 16 25 36];
%%
% Try
A + B
%%
% and
A - B
%% Dot-Operators
% MATLAB uses the dot-operator (*|.|*) construction to distinguish between
% scalar-vectorized operations and matrix operations. Dot-operators are 
% meant to repeat operations on the members of the array. For example,
%%
A .* A
%%
% returns an array composed by square of each element in *|A|*.
% 
% _(Note: This differs from *|A*A|*, which would fail in this case, since the
% matrix multiplication is only mathematically defined for arrays with the 
% same number of rows and columns.)_
%
% Another example of dot-operator is the power (*|^|*) function:
B.^0.5
%%
% which applies the "raise to the 0.5 power" operation to each member of 
% the array B.
%
% The division between two arrays is also a dot-operator:
A ./ B
%%
% which allows us to divide elements in A by the corresponding elements in
% B.
%% Vectorized Functions
% MATLAB is a vectorized language. That means it operates automatically
% over each member of an array without the need for an explicit loop 
% (which would be necessary in C or FORTRAN). In fact, it is not only more 
% compact, but more efficient and faster to avoid loops if possible.
%
% Most (if not all) MATLAB functions are vectorized. For example:
B = [1 4 9; 16 25 36];
sqrt(B)
%%
% This uses the square root operator over each element of the array.
% Similarly, try:
log(B)
%%
sin(B)
%% Exercise
% Consider the three arrays:
SampleA = [1:3;4:6;7:9];
SampleB = [ones(1,3);zeros(1,3)];
SampleC = [1:2:5;2:2:6];
%%
% For the following sets of two commands, point out which sets have
% identical commands, and explain why the commands in other sets are
% different:
%
% 1)
SampleA*SampleA;
SampleA.*SampleA;
%%
% 2)
size(SampleB)./size(SampleC);
size(SampleB./SampleC);
%%
% 3)
SampleC.*SampleC;
SampleC.^2;
