function f = functionExample(A, y)  
%
%  - Make sure the name you gave the function matches your 
%  file name (minus the .m).
%  - The f is what you call the result later in the file that you 
%  want the function to return.
%  - When naming functions, make sure that the name is not an
%  existing function in MATLAB.  MATLAB will get confused if it
%  is an existing function.  You can test if the function exists by
%  typing it in the command window.  If it doesn't exist, MATLAB
%  will tell you it's an undefined function or variable.
%  - This function accepts 2 variables, A (an array) and y (a number).
%
f = mean(A(:, y));
%
%  - Lastly, the final result that you want the function to return
%  should be named the same as the variable you used in the 
%  first line of the file declaring the function.  So, in this case,
%  since we used function f = ..., we want the result to be 
%  called f.
