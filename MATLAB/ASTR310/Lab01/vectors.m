%% MATLAB: Basics of Vectors, Matrices, and Arrays

%% Constructing vectors
% You can create a vertical vector by using semicolons:
%%
VectorExample1 = [2; 4; 6; 1; 3; 5]
%%
% which is a 6x1 size matrix. You can also choose to create a horizontal 
% vector by using spaces or commas:
%%
VectorExample2 = [2  4  6  1  3  5]
VectorExample3 = [2, 4, 6, 1, 3, 5]
%%
% which are both 1x6 size matrices. In combination, you can freely create
% NxM matrix:
%%
MatrixExample1 = [2  4  6; 1  3  5]
MatrixExample2 = [2  4; 6  1; 3  5]
%%
% It is frequently useful to generate arrays of running indices by using
% the colon operator:
%%
TryColon1 = [1:6]
TryColon2 = 1:6
%%
% A more general construction involves two colons, with the syntax
% StartingValue:Increment:NoLargerThan
TryColon3 = 1:1:6
TryColon4 = 1:2:6
%%
% Here are some examples of more complicated arrays of running indices:
%%
SampleArray1 = [2:2:6, 1:2:6]
SampleArray2 = [2:2:6; 1:2:6]
%%
%  
% It is considerably faster, less accident-prone, and much more convenient
% to predefine large arrays before using them. The functions "zeros" and
% "ones" work fantastic on defining arrays of zeros and ones:
ZeroArray = zeros(2,3)
OneArray = ones(2,3)
%%
% It also accepts the alternate syntax
%%
Size = [2,3] 
ZeroArray = zeros(Size)
%% Size and Length
% Many times it is important to find out the dimensions of an array. The
% function
%%
size(MatrixExample1)
size(MatrixExample2)
%% 
% returns a vector of dimensions. To save the numbers for future use, type
%%
[RowNumber, ColNumber] = size(MatrixExample1)
%%
% or use another vector to save the info:
%%
SizeNumber = size(MatrixExample1)
%%
% Sometimes we are not interested in all the dimen- sions, but just the
% longest one (as with 1xN arrays). MATLAB provides the handy function 
% "length" to obtain that number:
%%
length(VectorExample1)
length(VectorExample2)
%%
length(MatrixExample1)
length(MatrixExample2)
%%
% Note that the output of length() for the two vectors are the same, as
% well as the two matrices.
%% Accessing entries
% It is straightforward to access individual elements of a vector. Try:
%%
VectorExample1(1)
VectorExample1(6)
%%
% which print the first and last elements of VectorExample1. More 
% generally, we can refer to the last element of any array as
%%
VectorExample1(end)
%%
% Note that MATLAB departs from C in the convention for the indexing of
% arrays: indices start from 1 (just like FORTRAN or BASIC) and not from 
% zero.
%
% If you want to see a range of values, use the colon operator:
%%
SampleArray1(2:5)
%%
% For large arrays, MATLAB will automatically indicate the column range in
% each line.
%
% We can also use the colon operator to create sub-array:
%%
MainArray = [1, 2, 3, 4, 5; 2, 3, 4, 5, 6; 3, 4, 5, 6, 7]
%%
SubArray = MainArray(1:2, 3:5)
%%
% This is useful when we are interested in only a part of a matrix.
%% Indices and Subscripts
% There are two mechanisms for accessing data that has more than one
% dimension: subscripts and indices. Subscripts are the intuitive 
% mathematical representation. For example,
%%
SampleArray2
SampleArray2(1,2)
%%
% refers to the element in the first row, second column of SampleArray2.
% This can be easily generalized to an arbitrary number of dimensions, 
% although it can become cumbersome.
%
% Indices, on the other hand, use just one number to address (or index)
% any element of an array. It actually corresponds to the physical order in
% which elements are stored in the computer memory. In MATLAB matrices are 
% stored running through the rows first, then the columns, thus the fastest 
% running subscript of a matrix is the first subscript, the row subscript.
% For example,
%%
SampleArray2(2)
SampleArray2(2,1)
%%
% is the same, and
%%
SampleArray2(3)
SampleArray2(1,2)
%%
% is the same.
% 
% When used to address the contents of a matrixwhen used to address the
% contents of a matrix, the colon operator stands for everything. So one
% can obtain all the numbers in the first row of matrix SampleArray2 by 
% typing
%%
SampleArray2(1,:)
%%
% Similarly, all numbers in the 3rd column are obtained by issuing
%%
SampleArray2(:,3)
%%
% We can also specify a range of indices or subscripts:
%%
SampleArray2(3:6)
SampleArray2(:,2:3)
%%
% Note that the dimensions of the result are different.