%% Variables and Arithmetic Operators
%% Using Variables
% In MATLAB, when you type
myVar = 3.7;
%%
% in the command window, it means the variable *|myVar|* is assigned the value
% *|1|*. You can obtain the values of your variables by typing their names:
myVar
%%
% Variable names must begin with a letter, followed by letters, numbers or
% underscores. MATLAB recognizes only the first 31 characters of a variable
% name.
%% Arithmetic Operators
% Basic arithmetic operations in MATLAB include six operations: 
%
% <html>
% <table width="250" border="1">
% <tr><td>addition</td><td align="center">+</td></tr>
% <tr><td>subtraction</td><td align="center">-</td></tr>
% <tr><td>multiplication</td><td align="center">*</td></tr>
% <tr><td>division</td><td align="center">/ or \</td></tr>
% <tr><td>exponentiation</td><td align="center">^</td></tr>
% </table>
% </html>
%%
% Note that the right division (*|/|*)
% and the left division (*|\|*) do not produce the same results:
rd = 2/5
%%
ld = 2\5
%% Variables in Calculation
% When you assign a value to a variable, it can be used in numerical
% calculations. For example:
x = 2;
y = x^2;
z = y^3;
%%
% then you'll have *|z|* as 2^6 = 64:
z
%% Clearing variables
% The MATLAB internal function *|clear|* will remove all variables you
% assigned.
x
%%
clear
%%
%x
%%
% This is useful when you want to restart your work. In addition, it is a
% good idea to include *|clear|* as the first line in your script M-files
% (you'll learn more about this later).
%% Keep in mind...
% Be careful -- you should NOT use the MATLAB internal functions as the 
% names of your variables. You will lose that function by doing so. For 
% example, MATLAB provide the trigonometric function sine:
sin(pi/2)
%%
% _(Note that the constant *|pi = 3.14159...|* is saved in MATLAB by default.)_
%
% However, if you accidentally make *|sin|* a variable by typing
sin = 0.3333;
%%
% Then you will get error message next time when you want to calculate the
% trigonometric function sine:
sin(pi/2)
%%
% That sucks, right? So you must be careful. Well, at least you can use the
% command *|clear|* to erase it:
clear sin
%%
% This will only remove the assigned value of *|sin|*; other variables will
% remain unaffected.

