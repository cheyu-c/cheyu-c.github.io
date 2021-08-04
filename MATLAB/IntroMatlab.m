%%Introductory MATLAB exercises
% A.J. Melhus 3/7/10

% Here are some exercises that are a helpful way of introducing Matlab to the 
% first-time student:

%% 2 important areas where first-time users forget/neglect to look:
%  The directory - this is the current computer directory where Matlab looks for 
% code/files, should you call upon a created file.  This is especially important 
% when using m-files for classes/homeworks.
    
%  The workspace - this area looks very similar to an Excel GUI that many people 
% are used to.  The workspace lists the current matrices/vectors/data that are 
% stored in Matlab's working memory.  Picking through the workspace is sometimes 
% helpful when sorting out plotting problems - "why does my plot look like a
% straight line?"
    
%% Creating and using vectors    
% 1) Try typing: 
x = [0:50]  % a huge (unnecessary) list of numbers!  (with default step 1)
    
% As you can see, this command generates a huge list of numbers.  Suppress 
% command-line echo with the semicolon operator, ;
% Instead, type: 
x = [0:50];   
% huge list is still there, just supressed.  To check? - open the workspace 
% entry for x
    
%You can manually set the step between values:  
x1 = [0:.5:50]; 
% this generates a row vector 1-50 with spacing 0.5 between each value
    
% To create a vector with a SET number of entries, uses the <linspace> command:
x2 = linspace(0,50,200);   
% this creates a vector containing 200 entries, numbering 1 to 50 with equal 
% spacing between (linearly spaced entries).
    
    
% 2) When performing arithmetic operations with vectors in Matlab, make sure 
% to put a period <.> after the vector in question.  Otherwise, you will usually 
% get error messages.  The period tells Matlab to perform that command at every 
% vector position:
    
    y = x^3 +x^2/(x^2 - 1)         %NO, wrong format
    y = x.^3 + (x.^2)./(x.^2 - 1 ) % YES, correct format 
% (note: you do not need to use the period with addition/subtraction)
    
    
    %3) Matlab is very good at plotting, but you have to know how to tell it what you want.
    
    x = linspace(0, 2*pi);
    y1 = sin(x);
    y2 = cos(x);
    y3 = (cos(x))^2;
    hold on   % allows more actions to in the plot/figure window
    clf       % "clear figure"
    plot(x,y1, 'b--')  % this says to plot y1 vs. x using a blue dashed line
    plot(x,y2, 'ro')  % plot with red circles
    plot(x,y3, 'g-o-')  % plot with green connected circles
    % There are many other variations of plot subroutines, just type <help plot>
    
    
    
     
