%% Hubble's Law
%%
% By completing Project CLEA, you should now be able to write three arrays
% that include your measured data:
klines = [4474,4474,4476,4134,4136,4134,4022,4025,4024,4452,4452,4448,4214,4218,4220];
hlines = [4514,4514,4512,4172,4170,4172,4058,4058,4058,4490,4492,4492,4256,4256,4258];
appm = [16.6,16.8,16.8,14.5,14.7,14.6,12.8,12.5,12.7,16.5,16.8,16.7,15.4,15.5,15.1];
%%
% Let's calculate the redshift from the wavelength measurements:
zk = (klines-3933.7)./3933.7;
zh = (hlines-3968.5)./3968.5;
%%
% From the redshift, we can calculate the recessional velocities:
vh = 2.99792e5.*zh;
vk = 2.99792e5.*zk;
%%
% Take the average for each galaxy:
avgv = (vh + vk)./2;
%%
% Assuming that each galaxy has the same absolute magnitude, *M=22*:
M = -22;
%%
% Using the apparent magnitudes you recorded, the distance to all of the
% galaxies can be calculated:
dist = 10.^((appm-M+5)/5);
%%
% in the unit of *pc*. Or, in the unit of *Mpc*:
distmpc = dist./1e6;
%%
% Now you should have a redshift-distance relation for all galaxies:
figure(1); clf;
plot(distmpc,avgv,'k+', 'LineWidth', 1.2, 'MarkerSize', 7)
xlabel('Dist (Mpc)')
ylabel('Velocity (km/s)')
title('Hubble''s law')
xlim([0 600]); ylim([0 45000]);
%%
% _(Note the way I put *Hubble's law* in the title!)_
%
% Hubble's law tells us that our data can be fitted by a straight line,
% i.e., a polynomial with degree *1*:
p = polyfit(distmpc,avgv,1)
%%
% This gives us a fitted line of our data if we put *|p|* into the function
% *|polyval|*. Note that, since the data array *|distmpc|* is not sorted in
% ascending or descending way, if you just use:
vfit = polyval(p, distmpc);
%%
% to evaluate the fitted function, when you make plot of *|vfit|* using
% lines, it will look weird. The better way is to define a new array for
% the distance:
newdist = linspace(0, 600, 200);
vfit = polyval(p, newdist);
%%
% Now we can compare the fit to original data:
hold on;
plot(newdist, vfit, 'b:', 'LineWidth',2)
legend('measured', 'fit', 'Location', 'NorthWest');
%%
% This is the best fit of our data. However, note that the y-intercept is
% not zero, which is inconsistent with the idea of Hubble's law.
% 
% Alternatively, as described in the handout, we can apply the magic of 
% matrix math here to find the best slope of the Hubble's law:
a = avgv/distmpc
%%
% _(Basically, in MATLAB, if matrices *|A|* and *|B|* don't have the right
% dimensions to perform matrix division (e.g., *|A|* is not square), the
% right division *|X = B/A|* will be considered to be the solution in the
% least squares sense to the system of equations *|XA = B|*.)_
%
% Therefore, the solution *|a|* provides the slope we want:
plot(newdist, a*newdist, 'r--')
legend('measured', 'fit1', 'fit2', 'Location', 'NorthWest');
%%
%


