%% Orbital velocity of the cloud
%%
% This lab, very similar to Lab 3, requires you to 1) load *|.dat|* files
% to MATLAB and make plots, 2) use *|ginput|* to pull out some info from 
% your plot, and 3) use MATLAB as a calculator to get some science ideas.
%
% Let's load the data first:
lon17 = load('lon17.dat');
%%
% The first column in *|lon17|* is the frequency channels used in the
% observation, and the second column is the relative strength of the 
% H-alpha line. Let's take a look on this spectrum:
figure(1); clf;
plot(lon17(:,1), lon17(:,2), 'b-');
xlabel('frequency'); ylabel('relative intensity');
title('Galactic Longitude = 17 (deg)');
%%
% Remember, the smallest frequency represents the largest redshift, which
% gives us the tangent velocity. Recall your knowledge about *|ginput|*:
[x(1), y(1)] = ginput(1);
%%
% Now *|x1|* is the smallest frequency we want. Use the redshift equation
% provided in the handout:
c = 2.997925e5;      % in km/s
f_rest = 1420.406;   % in MHz
vt = c*(f_rest - x1)/x1;
%%
% And the orbital velocity is: (note that you need to convert the longitude
% from degree to rad before you put it in the *|sin|* function!)
v_sun = 220;         % in km/s
vorb = vt + v_sun*sin(17*pi/180)
%%
% in unit of *km/s*.
