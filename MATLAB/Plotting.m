%%  Plotting examples in Matlab
%  A.J. Melhus, 4-18-10

%% Using ezplot command

% Use ezplot if you have a simple function and want a plot very quickly
    
% Syntax:
%  ezplot(f)  
% -  plots a function f over default domain [-2pi, 2pi]
% - f can be symbolic, vector, or string
% - displays title 'f' and independent variable 'x' on figure
  
%  explot(f, [xmin,xmax])
% - plots a function f over the given domain [xmin, xmax]
  
% To try:
    
clf % clear figure space
ezplot('x^2')    % plots y = x^2 over [-2pi, 2pi]
    
f = 'cos(x)+1';
ezplot(f, [0, 2*pi])    % plots f = cos(x) + 1 over [0, 2pi]
        
        
%% Using plot command          
% plot is a much more robust plotting tool

% Basic syntax:
%  plot(x,y)
% - x and y are vectors containing the data you wish to plot
% - x and y must be of same length and type

x1 = 0:2*pi;    % a vector from 0 to 2pi, using the default step of 1
y1 = sin(x1);
clf % clear figure space
plot(x1,y1)

%% 
%  THIS PLOT LOOKS BAD because x1 only contains 7 points (we need more 
% points to make a smooth graph).  

%  Instead, use <linspace> to make a much more smooth graph:

x2 = linspace(0, 2*pi);    % a vector from 0 to 2pi containing 100 linearly 
                           % spaced points
y2 = sin(x2);
clf % clear figure space
plot(x2,y2)
%  THIS PLOT LOOKS GOOD because x2 contains many more points, creating a 
% smoother graph


%% Plot aesthetics  
% (taken/edited from http://www.engin.umich.edu/group/ctm/extras/plot.html)

% The color and point marker can be changed on a plot by adding a third 
% parameter (in single quotes) to the plot command.
% Syntax:
% plot(x,y, 'aesthetic')
% - aesthetic consists of one to three characters which specify a color 
% and/or point marker type
%
% color and point marker types:
%     y     yellow        .     point
%     m     magenta       o     circle
%     c     cyan          x     x-mark
%     r     red           +     plus
%     g     green         -     solid
%     b     blue          *     star
%     w     white         :     dotted
%     k     black         -.    dashdot
%  	                     --    dashed

% For example, to plot y2 as a red, dotted line, the command should be 
% changed to:
  
clf % clear figure space
plot(x2,y2, 'r:')    % plots a red dotted line, instead of the default 
                     % blue straight line
  

%%    Multiple Plots, 2 ways

%  1.  Use multiple arguments within one plot command:
%  Syntax:
% plot(x,y,'aesthetic',...,x,y_n,'aesthetic')

% For example:
t=linspace(0,2*pi);
clf % clear figure space
plot(t,sinc(t),'r.',t,(cos(t)).^2,t,(sin(t)).^2+(cos(t)).^2,'ko')    
% plots sinc(t), cos^2(t), and sin^2+cos^2(t) all on the same plot, with 
% different point markers
%%

%  2.  Use hold on/off command:
% You can use the <hold> command to make adjustments to the current figure 
% without erasing objects or information.
% hold is a more logical way of plotting multiple objects at once, and is 
% not as crammed.

% For example:
t1 = linspace(0,2*pi);
v1 = sinc(t1);
clf % clear figure space
hold on    % toggles figure to allow more figure actions
plot(t1,v1,'r.')    % plots sinc(t) in red points
v2 = (cos(t1)).^2;
plot(t1,v2,'k')    % plots cos^2(t) in black
v3 = (sin(t1)).^2 + (cos(t1)).^2;
plot(t1,v3,'g-.')   % plots sin^2 + cos^2(t) in green dash-dot
hold off    % release figure toggle

%% Reversing axes
% Reversing axes is often useful in astronomy: think about the magnitude
% scale, where brighter is more negative.

%  Reverse the plotted axes by using the set command:
%          set(axes, 'XDir', 'reverse', 'YDir', 'reverse')    
% This reverses both the x-axis and y-axis (positive is now left and down, 
% negative is right and up)
% - Use only 'XDir' to flip x-axis
% - Use only 'YDir' to flip y-axis 

clf % clear figure space
set(axes, 'XDir','reverse', 'YDir', 'reverse')    % Reverses both axes 
hold on    % toggles figure to allow more figure actions
plot(t1,v1,'r.')    % plots sinc(t) in red points
v2 = (cos(t1)).^2;
plot(t1,v2,'k')    % plots cos^2(t) in black
v3 = (sin(t1)).^2 + (cos(t1)).^2;
plot(t1,v3,'g-.')   % plots sin^2 + cos^2(t) in green dash-dot
hold off    % release figure toggle

