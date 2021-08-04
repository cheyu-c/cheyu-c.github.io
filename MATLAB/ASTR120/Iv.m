% Iv, Planck's Law in frequency space
% Function m-file for use in "Black body 4-25-10"
% A.J. Melhus 4/25/10  

function Planck2 = I_v(v,T)
% Iv returns a blackbody spectrum in freq. space  
    
% Define the constants used in the functions/formulas:
h = 6.626069e-34;    % Planck's constant, units of J*s
c = 299792458;      % speed of light, units of m/s
kb = 1.38065e-23;    % Boltzmann constant, units of J/K

% Planck's law, in frequency domain
Planck2 = (8.*pi.*h.*v.^3)./(c.^2).*1./(exp(h.*v./(kb.*T))-1);    
