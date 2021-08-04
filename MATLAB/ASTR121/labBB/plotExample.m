%% Example script for a simple single plot of a function

%% Plot parameters
xStart = -1;        % starting x value                    
xEnd = 1;           % ending x value
nPoints = 200;      % number of points in plot
n = 1;              % a scalar

%% The function to plot
% For this example, the function is called 'functionExample' and is defined 
% in a separate file called <functionExample.m>.

%% Make x and y data vectors
x = linspace(xStart, xEnd, nPoints);   % independent variable vector
y = functionExample(x, n);             % dependent variable

%% Make the plot, adding labels and a title
figure(1); clf;             % clear the figure area, just in case
plot(x, y, 'b')             % plot y vs. x, with blue line
xlabel('x variable')        % x label
ylabel('y variable')        % y label
title('Plot of functionExample')   % title for plot
