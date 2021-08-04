%% Vectors, Matrices, and Arrays: Size, Length, and Subscripts
%%
% Let's say we have these sample arrays and vectors:
VectorExample1 = [2; 4; 6; 1; 3; 5];
VectorExample2 = [2  4  6  1  3  5];
MatrixExample1 = [2  4  6; 1  3  5];
MatrixExample2 = [2  4; 6  1; 3  5];
%%
% _(Exercise: do you know how these vectors/matrices look like without
% typing these commands in MATLAB?)_
%% Size of an Array
% Many times it is important to find out the dimensions of an array. The
% function *|size|* returns a vector of dimensions:
size(MatrixExample1)
%%
size(MatrixExample2)
%% 
% To save the numbers for future use, type
[RowNumber, ColNumber] = size(MatrixExample1)
%%
% or use a vector to save the info:
SizeNumber = size(MatrixExample1)
%% Length of a Vector
% In MATLAB, a vector is basically a 1xN (or Nx1) array. Therefore we don't
% really need the size; all we need is the *|length|* (i.e. the value of N)
length(VectorExample1)
%%
length(VectorExample2)
%% Length of an Array
% Sometimes we are not interested in all the dimensions, but just the 
% longest one (as with 1xN arrays). MATLAB provides the handy function 
% *|length|* to obtain that number:
length(MatrixExample1)
%%
length(MatrixExample2)
%%
% Note that the length for the two matrices are the same.
%% Subscripts
% Subscripts are the intuitive mathematical representation for accessing 
% data that has more than one dimension. For example,
VectorExample1(3)
%%
% refers to the third element of the vector *|VectorExample1|*, and 
MatrixExample1(1,2)
%%
% refers to the element in the first row, second column of the array 
% *|MatrixExample1|*.
%% Colon Operator as Subscript
% If you want to see a range of values, use the colon operator:
VectorExample2(2:5)
%%
MatrixExample1(1:2, 2:3)
%% Exercise
% We have
A = [1:5; zeros(1,3),ones(1,2); 10:-1:6];
S = size(A);
Q = S(1) + length(A) - A(2,5) + length(zeros(1,3));
%%
% What's the value of *|Q|*?