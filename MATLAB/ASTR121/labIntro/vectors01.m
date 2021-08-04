%% Writing Vectors, Matrices, and Arrays

%% Constructing Vectors
% You can create a vertical vector by using semicolons:
VectorExample1 = [2; 4; 6; 1; 3; 5]
%%
% which is a 6x1 size matrix. You can also choose to create a horizontal 
% vector by using spaces or commas:
VectorExample2 = [2  4  6  1  3  5]
VectorExample3 = [2, 4, 6, 1, 3, 5]
%%
% which are both 1x6 size matrices. 
%% Constructing Matrices and Arrays
% Combine semicolons and commas/spaces, you can freely create NxM matrices 
% or arrays:
MatrixExample1 = [2  4  6; 1  3  5]
MatrixExample2 = [2  4; 6  1; 3  5]
%% Colon Operator
% It is frequently useful to generate arrays of running indices by using
% the colon operator:
TryColon1 = [1:6]
TryColon2 = 1:6
%%
% A more general construction involves two colons, with the syntax
% (Starting Value) : (Increment) : (No Larger Than)
TryColon3 = 1:1:6
TryColon4 = 1:2:6
%%
% Here are some examples of more complicated arrays of running indices:
SampleArray1 = [2:2:6, 1:2:6]
SampleArray2 = [2:2:6; 1:2:6]
%% Zero/Unit Arrays 
% It is considerably faster, less accident-prone, and much more convenient
% to predefine large arrays before using them. The functions *|zeros|* and
% *|ones|* work fantastic on defining arrays of zeros and ones:
ZeroArray = zeros(2,3)
OneArray = ones(2,3)
%%
% It also accepts the alternate syntax
Size = [2,3] 
ZeroArray = zeros(Size)
%% Linearly/Logarithmically Spaced Vector
% There are two handy MATLAB internal functions which creates vectors with
% equally spaced points between the range you want: *|linspace|* and
% *|logspace|*.
linearVec = linspace(0, 1, 5)
%%
% The function *|linspace(X1, X2, N)|* generates *|N|* linearly equally 
% spaced points between *|X1|* and *|X2|*. Note that if *|N|*<2 it returns 
% *|X2|*. The default value of *|N|* is 100.
logVec = logspace(0, 1, 5)
%%
% The function *|logspace(X1, X2, N)|* generates *|N|* logarithmically 
% equally spacedpoints between *|10^X1|* and *|10^X2|*. Note that if 
% *|N|*<2 it returns *|10^X2|*. The default value of *|N|* is 50.
%% Exercise
% Use colon operators to generate the following array:
A = [1:3;2:2:6;3:3:9]
%% 