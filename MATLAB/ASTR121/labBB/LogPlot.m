%% Log-log Plot
%%
% Assuming that you already wrote a functional m-file called *|planck.m|*,
% which takes 2 input parameters (frequency $\nu$ and temperature $T$) and
% output the intensity ($I$). Now, let's plot the Planck function vs. 
% frequency, and see how the curve varies with different temperature.
%
% Remember to set the temperature in Kelvin:
T = 5.7e3;
%%
% Here we choose the effective Black Body temperature of the Sun, 5700K.
%% Why log-log plot?
% In astronomy, we are interested in a wide range of frequencies, say,
% $10^5$ to $10^{18}$ Hz. To plot the Planck Function as a function of
% frequency in this range, first we create a "frequency vector" using this 
% range:
LinearNu = linspace(10^5, 10^18, 100);
%%
% In case you don't remember, *|linspace(low, high, N)|* creates a vector
% from *|low|* to *|high|* with *|N|* elements equally spaced. 
%
% Now you can call the function *|planck.m|* and get the intensity as a
% function of frequency:
LinearI = planck(LinearNu,T);
%% 
% Then we can make the plot:
plot(LinearNu, LinearI, 'b.')
%%
% Since this is a large range of numbers (in both *|x|*- and
% *|y|*-directions), no structure can be observed in the linearly-spaced
% plot.
%% Log-log plot
% This is the reason to use log-log plot: when you are handling numbers
% with a wide range. 
%
% The function *|loglog()|* is similar to *|plot()|*, but it plots the data 
% on a grid log spaced in both *|x|* and *|y|*:
loglog(LinearNu, LinearI, 'b.')
%%
% The plot looks much better, but there's still a problem: When we use
% *|linspace|*, most of the elements in the vector are on the high-end of
% the range. If you check the vector *|LinearNu|*, except the first element
% ($10^5$), all elements are around $10^{18}$. Therefore, we are missing 
% structure for the low-end.
%% Log-space
% The solution is to use *|logspace|* instead of *|linspace|*. Similar to
% *|linspace|*, *|logspace(low, high, N)|* creates a vector, from
% $10^\mathrm{low}$ to $10^\mathrm{high}$, with *|N|* elements distributed
% equally in the log space
Nu = logspace(5, 18, 100);
%%
% The Planck function now looks much better!
Intensity = planck(Nu, T);
loglog(Nu, Intensity, 'b.')
xlabel('nu Hz');
ylabel('Intensity erg /s /Hz / str / cm^2')
title('Planck Function')
%%