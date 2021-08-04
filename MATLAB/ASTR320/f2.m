%%  System of 1st order ODEs for use in "Differential equations, 4-11-10" exercises
  %  A.J. Melhus, 4-11-10
  
% System to solve:
% v1' = v2 - v1^2
% v2' = -v1 - 2*v1*v2

  
  function vprime = f2(t,v)
    vprime = zeros(2,1);  % the output is a 2x1 column vector - output must be a column vector!
    vprime(1) = v(2) - v(1)^2;
    vprime(2) = -v(1) -2*v(1)*v(2);
    end