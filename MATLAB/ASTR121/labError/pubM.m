%% Mark up comments for publishing
% _Partly copied from MATLAB Product Documentation_
%%
% You can mark up comments in your MATLAB files so that when you publish
% the code, it appears polished, rather than as a text file of code. To
% include comments (i.e., not MATLAB code) in your m-file, use the *|%|*
% symbol:
c = 3e8; % unit: m/s
%%
% Also, a line starting with *|'% '|* (a *|%|* followed by a space)
% represents descriptive text:
%here we define the speed of light
c=3e8;
%%
% which, after published, should look like
%
% here we define the speed of light
c=3e8;
%% Section titles
% A line starting with *|'%  '|* (a *|%|* followed by two spaces) specifies
% a section title:
%%Definition of c
%here we define the speed of light
c=3e8;
%%
% which becomes
%
% after published.
%
% To include a document title, just add a section title in the first line
% of your script, and it will look like this:
%% Adding cell breaks
% A line starting with *|'%  '|* (a *|%|* followed by two spaces) but has
% no content indicates a cell break, which is useful when you want to
% separate your MATLAB code into different section. Here's an example
% without cell break:
x = linspace(1,2,5)
x.*x
sin(x)
%%
% All the output mixed together, makes your published file hard to read. If
% you use cell breaks:
x = linspace(1,2,5);
%%%
x.*x;
%%%
sin(x);
%%%
%%
% it will look much better:
x = linspace(1,2,5)
%%
x.*x
%%
sin(x)
%% Use ; to shorten the output
% In the example above, you don't need to print out the value of *|x|*
% itself, only the calculation results *|x^2|* and *|sin(x)|*. You can use
% *|;|* to tell MATLAB "don't print out this line":
x = linspace(1,2,5);
%%
x.*x
%%
sin(x)
%%
% By properly use *|;|* in your script m-file, you can make the published
% file brief and clear!

