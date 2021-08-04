%% Scripts and Functions
% _Copied from MATLAB Product Help_
%%
% M-files are basically text files with a *|.m|* extension which contain
% commands that MATLAB can read. Based on the way we use them, there are
% two types of M-files: scripts and functions.
%% M-file scripts
% This is the simplest kind of M-file because they have no input or output
% arguments. They are useful for automating series of MATLAB commands, such 
% as computations that you have to perform repeatedly from the command
% line. You can think that a script M-file is a text file with each line is
% a command you are going to enter in the Command Window.
%
% Scripts share the base workspace with your interactive MATLAB session and
% with other scripts. They operate on existing data in the workspace, or
% they can create new data on which to operate. Any variables that scripts
% create remain in the workspace after the script finishes so you can use
% them for further computations. You should be aware, though, that running
% a script can unintentionally overwrite data stored in the base workspace
% by commands entered at the MATLAB command prompt.
%
% Try entering the following commands in an M-file called *|mytestS.m|*:
x = 1:100;
xnumber = length(x);
totalx = sum(x);
average_x = totalx/xnumber
%%
% This file is now a MATLAB script. Typing *|mytestS|* at the MATLAB command
% line executes the statements in the script.
%% M-file functions
% Functions are program routines, usually implemented in M-files, that
% accept input arguments and return output arguments. You define MATLAB
% functions within a function M-file; that is, a file that begins with a
% line containing the *|function|* key word. You cannot define a function
% within a script M-file or at the MATLAB command line.
%
% Functions always begin with a function definition line and end either
% with the first matching *|end|* statement, the occurrence of another function
% definition line, or the end of the M-file, whichever comes first. Using
% *|end|* to mark the end of a function definition is required only when the
% function being defined contains one or more nested functions.
%
% Functions operate on variables within their own workspace. This workspace
% is separate from the base workspace; the workspace that you access at the
% MATLAB command prompt and in scripts. While using MATLAB, the only
% variables you can access are those in the calling context. The variables 
% that you pass to a function must be in the calling context, and the 
% function returns its output arguments to the calling workspace context.    
%
% Here's a simple M-file function that calculate the average of the
% elements in a vector:
%function y = mytestF(x)
xnumber = length(x);
totalx = sum(x);
y = totalx/xnumber;
%%
% Try entering these commands in an M-file called *|mytestF.m|*. The
% *|mytestF|* function accepts a single input argument and returns a single
% output argument. To call the *|mytestF|* function, enter
x = 1:100;
mytestF(x)
%%
% Note that, there actually is a MATLAB internal function called *|mean|*
% which calculate the average of the elements in a vector.