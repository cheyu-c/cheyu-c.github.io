%% Vectors, Matrices, and Arrays: Statistical Analysis
%%
% Though most MATLAB functions are vectorized, we should be careful when
% using those functions which include usage of two or more array elements
% in the same time. This situation occurs frequently when dealing with
% data statistics.
%
% Here's a sample data array generated from the random number generator:
DataA = rand(3,5)
%% Comparison between Elements
% By default, in arrays of two or more dimensions, these operators do the 
% calculations along the first non-singleton dimension. For example:
max(DataA)
%%
min(DataA)
%%
% these print the maximum and minimum values of each row in array *|DataA|*.
% Another example is
sum(DataA)
%%
% this calculates the sum of the elements of each row in array *|DataA|*.
%% Specifying Subscripts
% If the default dimension is not the one along which you want to operate 
% the functions, you can add a second optional parameter that specifies 
% which dimension you want to collapse:
sum(DataA,2)
%%
% this will sum the columns (the *2nd* dimension). 
% 
% Note that in the case of *|max|* and *|min|*, these functions are
% supposed to compare _two_ arrays, so the second optional parameter of *|max|*
% and *|min|* is set to be an array. Therefore, to specify which dimension 
% we want to analysize, we need to add an empty second optional parameter 
% and indicate the dimension we want in the third argument:
max(DataA,[], 2)
%%
% _(Exercise: what will happen if you type_  *|max(DataA,2)|* _?)_
%% Colon Operator Again!
% In the case of data arrays, we want the operators to apply on every
% element in the array, instead of columns or rows. This can be achieved by
% using the colon operator. For example, if you want to sum all the numbers 
% in *|DataA|* irrespective of their position in the array, do
sum(DataA(:))
%% 
% which gives you the summation of every single element in array *|DataA|*.
% Similarly you can have
max(DataA(:))
min(DataA(:))
%% Simple Statistics
% MATLAB provides several internal function for the sake of data
% statistics. For example, the average value of each element in array *|DataA|* can
% be calculated by using the function *|mean|*:
mean(DataA(:))
%%
% For the standard deviation between each element of array *|DataA|*, use *|std|*:
std(DataA(:))
%% Exercise
% The goal of this exercise is to make you feel grateful to the MATLAB
% internal functions...
%
% Your professor gives you an unknown data set named *|BlackBox|*. You don't
% know what are the values in the data set, you don't even know the size of
% the data set. How could you calculate the average value of the data set, 
% without using the function *|mean|*?
%
% _(Hint: Use_ *|sum|* _and_ *|size|*_!)_
