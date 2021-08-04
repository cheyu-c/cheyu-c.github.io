% This function file defines the Planck function to be used in the BB and
% HR diagram lab:

function f = planck(lam,T)     % define the function
h = 6.626e-27; % erg s
c = 2.998e10; % cm /s
k_B = 1.381e-16; % erg / Kelvin

power = h*c ./ (lam*k_B.*T);

f = (2*h*c*c./(lam.^5)) ./ (exp(power)-1);  % calculate f, the returned value, from lam and T
