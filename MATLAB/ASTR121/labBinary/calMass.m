%% Calculation example
%%
% Maximum line-of-sight velocity together with the orbital period gives
% limit on orbital radius, and then the oribital period and radius gives 
% total mass. 
%
% Consider your *|fit|* results. Note that the two stars must have the same
% orbiting period, so we take the average of *|vrfit1.b1|* and
% *|vrfit2.b1|*:
b = (vrfit1.b1+vrfit2.b1)/2;
%% 
% Now you can calculate the orbiting period of the binary system: (in days)
T = (2*pi)/b
%%
% The amplitude *|a1|* in the sine function (the results you got by using
% *|fit|*) corresponds to the maximum orbital velocity of each star. This
% can be used to calculate the semi-major axis of each orbit around the
% center of mass.
% 
% Be careful on transforming the units:
%
% kilometer in AU units
km2au = 6.68e-9;
%%
% second in year units
s2yr = 3.17e-8;
%%
% Recall that the oribital period is (in year)
P = T/365
%%
% The semi-major axis *|a_shallow|* and *|a_deep|* are (in AU):
a_shallow = vrfit1.a1*(km2au/s2yr)*P / 2 / pi
a_deep = vrfit2.a1*(km2au/s2yr)*P / 2 / pi
%%
% _Note: What can *|a1|* tell you about which star corresponds to which 
% (shallow or deep)?_
% 
% Finally, the separation between the stars is
a = a_shallow + a_deep;
%%
% The total mass of the two stars: (in solar masses):
M = a^3 / P^2
%%
% The fact that the velocity shifts of the lines are greater for one star
% than the other would imply unequal masses. Using the definition of center
% of mass, we can find the masses of the two components: (in solar masses)
M_shallow = M*a_deep / (a_shallow + a_deep)
M_deep = M*a_shallow / (a_shallow + a_deep)
%%
