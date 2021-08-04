function f = functionExample(x,y)  
%  - Make sure the name you gave the function matches your 
%  file name (minus the .m).
%  - The f is what you call the result later in the file that you 
%  want the function to return.
%  - When naming functions, make sure that the name is not an
%  existing function in MATLAB.  MATLAB will get confused if it
%  is an existing function.  You can test if the function exists by
%  typing it in the command window.  If it doesn't exist, MATLAB
%  will tell you it's an undefined function or variable.
%  - This function accepts 2 variables, x and y, one or both of 
%  which can be arrays.
h = 1;
%  - You can set constants within the function, and any variable
%  names you use will only be used within that function.  So,
%  if you had a variable h already defined in your workspace,
%  the function will use the value of h given in the function file,
%  but that value of h will not be saved in your workspace.
b = h*x.^2;
%  - You can also define variables in a function, and again, any
%  variable names that you use in the function file will not 
%  affect variables of the same name that may already be in 
%  your workspace.
%  - Remember, if you plan on passing vectors to your function,
%  and you don't want MATLAB to do matrix math on the vectors,
%  you need to use the . before *, /, and ^.  The . is not needed
%  before the * in h*x because h is a scalar.
f = b.^2 + y;
%  - Lastly, the final result that you want the function to return
%  should be named the same as the variable you used in the 
%  first line of the file declaring the function.  So, in this case,
%  since we used function f = ..., we want the result to be 
%  called f.
%  That's it!  