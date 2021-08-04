%% 1st order ODE function for use in "Differential equations, 4-11-10" exercises
    % A.J. Melhus 4-11-10
  
  function y1_prime = f1(t,y1)  % define function
      y1_prime = cos(t)-2*y1 + 5;  % 1st order ODE
   end