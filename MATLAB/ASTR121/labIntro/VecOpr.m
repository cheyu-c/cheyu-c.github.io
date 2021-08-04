%% Basic Operations
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
%%