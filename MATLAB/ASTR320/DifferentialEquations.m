%% Solving differential equations (DEs) with Matlab

% A.J. Melhus, 4/11/10

% Types of solvers available
% Matlab has a host of DE solvers which can be used to solve almost any conceivable DE.  However, for most purposes we only care about getting a "pretty good" numerical result.  For this reason, we will focus our efforts here on using the solver <ode45>.
  
%   The basic syntax for ode45 is as follows:
    
% ode45(function, tspan, IC)
  % function   is the DE of interest, usually in terms of y'.  
  % **Be careful about how you define function for your DE - it usually isn't a problem for 1st order ODEs, but, as shown below setting up 2nd order ODEs can be a bit tricky to get right.
   % tspan   is the interval over which the DE is to be solved.  It is usually easier to define this explicitly before the ode45 line, instead of inline.
   % IC   is a vector containing the initial condition(s) for the problem - 1 initial condition for 1st order, 2 initial conditions for 2nd order, etc.
         f3.m
         
% Example 1:  1st order ODE, y' = cos(t)-2*y+5   (uses function m-file f1.m)

tspan1 = [0, 2*pi];   % set solver range t=0 to t=2*pi
IC_1 = 1;     % initial condition          
[t, y1] = ode45('f1', tspan1, IC_1);     % Numerically solves ODE and gives you a matrix [t,y1] where y1 is one or more variables defined in the f1 function
plot(t,y1);      % plot the numerical solution over the tspan1 range         
         
         
%  Example 2:  System of 1st order ODEs  (uses function m-file f2.m)

% System to solve:  (ideas taken from http://www.owlnet.rice.edu/~math211/manual3/Chapter08.pdf)
% v1' = v2 - v1^2
% v2' = -v1 - 2*v1*v2        

tspan2 = [0, 10];       % solve over range t=0 to t=10
IC_2 = [0;1];      % 2 initial conditions:  v1(0)=0, v2(0)=1
[t,v] = ode45('f2',tspan2, IC_2);   % As before, numerically solves system of ODEs and creates a maxtrix [t v1 v2]
plot(t,v(:,1), 'k')    % plot v1 vs. t, in black
hold on      % Allow more actions on the current figure
plot(t, v(:,2), 'r')    % plot v2 vs. t, in red
hold off      % Release figure
               
         
% Example 3:  2nd order ODE,  y'' = -y*y'-y     (uses function m-file f3.m)
                    
  % As shown in the f3 m-file, we need to break up a 2nd order ODE into a system of 1st order ODEs (similar in nature to Example 2)  
   % x1 = y, x2 = y'
         
tspan3 = [0,10];      % solve over range t=0 to t=10
IC_3 = [0; 1];        % 2 intial conditions for 2nd order:  y(0)=0, y'(0)=1            
[t,y2] = ode45('f3',tspan3, IC_3);       % As before, numerically solves ODE and creates a matrix [t, y, y']         
plot(t,y2(:,1))      % plot numerical solution over tspan2 range, only use y2(:,1) because y2 contains [y, y'] and we want to plot y vs. t


% Example 4:  Using dsolve to find explicit solution

% If the ODE of interest is simple enough, you can sometimes use the dsolve command to solve the equation symbolically:

%Syntax:
% dsolve('Eq', 'y0', 'var')
  % Eq   is the equation of interest - here Matlab goes by Dy = y', D2y = y'', D3y = y''', etc.
  % y0   is the initial condition(s), if specified (otherwise Matlab will return constants, C1,C2,etc.)
  % var  is the independent variable.  The default variable is t.

dsolve('Df = f + sin(t)', 'f(0)=1', 't')    % Explicitly solves f' = f + sin(t), with initial condition f(0) = 1

%  dsolve can solve more complicated expressions and systems of equations, just type help dsolve



%  Exercises:  (1) From Examples 1-3, use ode45 to plot a numerical solution for the simple harmonic oscillator, given by the following equation:
  % x'' = -(k/m)*x , with intial conditions x(0)=1, x'(0)=0
  % where m and k are the mass and spring constant, respectively (you can set them as arbitrary constants, m = 1, k = 0.5)

% (2) From Example 4, use dsolve to show explicitly the solution is of the form x = cos(a*t)

