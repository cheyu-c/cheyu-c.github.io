%% The Main Sequence
%%
% This is the reference that you can use to check your work. Some parts of 
% the code are blocked (using *|...|*) for you to figure out yourself.
%
% You should have a vector of 100 different values of temperature between 
% 3000K and 30000K:
temp = linspace(3000, 30000, 100);
%%
% Consider two astronomical filters, B (4360 Angstroms) and V (5450 Angstroms). We 
% will not multiply by a wavelength band width, so our units will be 
% incorrect, but the qualitative behavior of the plot will remain. Don't
% forget to transfer the wavelengths from Angstroms to meters:
lamB = 4360*1e-10;
lamV = 5450*1e-10;
%%
% The intensities in B and V bands are:
IB = planck(lamB,temp);
IV = planck(lamV,temp);
%%
% The TOTAL intensities in B and V bands are:
ItotB = IB*940*1e-10;
ItotV = IV*850*1e-10;
%%
% The color index is roughly
BminusV = -2.5*log10(ItotB./ItotV);
%%
% A HR diagram can be made by plotting luminosity vs. color index. Since
% the luminosity scales as *|log(I)|*, we can use the intensity in V band
% to calculate a scale-free relative measure of luminosity:
Lv = log10(ItotV);
%%
% If you did everything properly, your data points should look like the
% main sequence of the HR diagram.
figure(1); clf
plot(BminusV, Lv,'o')
xlabel('B-V');
ylabel('Some kind of Luminosity')
title('Main Sequence?')
%%
% Note: the color index scales with reverse of temperature, i.e.
% *|BminusV|* $\propto$ *|1/temp|*. You can try to plot it out to see this
% behavior:
figure(2); clf;
plot(BminusV, temp)
xlabel('Color Index')
ylabel('T (K)');
title('Proper Title')
%%
% Keep this in mind and look at your theoretical HR diagram again. Which
% end of the x-coordinate represents stars with higher surface temperature?