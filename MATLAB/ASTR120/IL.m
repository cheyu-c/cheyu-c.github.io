% IL, Planck's Law in wavelength space
% Function m-file for use in "Black body 4-25-10"
% A.J. Melhus 4/25/10  
  
function Planck1 = IL(L,T)
% IL returns a blackbody spectrum in wavelength-space
  
% Constants:  
h = 6.626069e-34;    % Planck's constant, units of J*s
c = 299792458;      % speed of light, units of m/s
kb = 1.38065e-23;    % Boltzmann constant, units of J/K
    
% Planck's law, in wavelength domain    
Planck1 =(8.*pi.*h.*c.^2)./(L.^5)*1./(exp(h.*c./(L.*kb.*T))-1);    













