%% Function Introduction Exercises
% by Albert Ticona Jr.
%%
% In programming, often you would see a list of lines or phrases on a file that when you execute it, it somehow performs a specific task.
% How do they do it? Well all of these lines and phrases execute a certain purpose such as displaying a message, calculate the average of a data set,
% or any other tasks that can be done by a computer. In Matlab, if you type display(“Hello World”) on the window, the message “Hello World” will be printed below 
% the command window. The combinations of all those phrases will ultimately execute the task that the “program” was asked to do.
% In order to execute a certain overall task in a program, you have to break the task into parts such that each different part performs 
% different parts of the program's main task. 
% Sometimes certain tasks are repeated in a program several times, taking up a lot of space. In this case, it would be simple to write this sub-task 
% separately from the program and then type a command in the main program that executes the sub-task from its separate location. For example, suppose
% you wanted to write a program that wanted to calculate the average over five data sets. One part of this program would be to find the total sum of 
% the data for each data set. One could simplify the program by writing a separate function that calculates the total sum in a separeate location.
% Then one would only need to write the “shortcut” command five times in the main program. In structured programming, we refer to this as creating a 
% function, and the command that executes the function from within the main program is called a function call.
% MATLAB has a call for most elementary functions (if not all). 
% Some examples include the exponential function, the trigonemetric functions (sine and cosine), and some special ones such as the sync function. 
% Polynomial functions can be easily defined in MATLAB, almost the same way you would when writing them down on your algebra homework. 
% A list of MATLAB functions can be found if you enter the command: 
doc functions  
%%
% and then go under Functions-- Aphabetical list. If you're not sure, whether a function is defined as a MATLAB function, you can always find 
% out online either www.mathworks.com or just Googling it. Commonly used ones are: sin(x), cos(x), tan(x), acos(x), asin(x), atan(x), exp(x), 
% sind(x) ( returns the sine value for  a value expressed in degrees), sqrt(x), etc.
% As we saw earlier display() is itself a function that displays what ever value that is placed within the parantheses.
% The syntax for calling any function in MATLAB is:  function_name(parameter)
% The parameter is the input required by the function in order to return a result, which in most cases is just a number or a vector of numbers. 
% Usually if you omit the semi-colon after the function call, the result will be displayed on the MATLAB screen.
% Examples of Matlab Functions:
display(sin(pi)); % will display the sine value of pi (pi being in unit radians)
%%
display(acos(1/2)); % will display the arc cosine value of 1/2
%%
display(exp(1)); % will display the value of the natural number e