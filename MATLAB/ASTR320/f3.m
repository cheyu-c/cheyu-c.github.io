%% 2nd order ODE function for use in "Differential equations, 4-10-11" exercises
    % A.J. Melhus 4-11-10
    
    % Function to solve:  y'' = -y*y' - y   (ideas taken from http://www.owlnet.rice.edu/~math211/manual3/Chapter08.pdf)
    % Define 2 new variables x1 and x2, then we have:
    % x1 = y,  x2 = y'          (1)
    % x1' = y' = x2             (2)  
    % x2' = y'' = -y*y' - y     (3) 
    %           = -x1*x2 - x1   (4)
    
    function y2_prime = f2(t,x)  % define function
    y2_prime = zeros(2,1);  % make a 2x1 vector to fill with y' and y''; output must be column vector!!
    y2_prime(1) = x(2);   % from (2), above
    y2_prime(2) = -x(1)*x(2)-x(1);    % from (4), above
    end
     