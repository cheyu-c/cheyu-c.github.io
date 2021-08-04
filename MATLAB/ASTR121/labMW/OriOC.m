%% Distribution of the open clusters
% _This is a reference for you to see if you did everything correctly, what
% should be on your screen. Note that some commands in this page are
% blocked (using *|...|*) for you to figure out by yourself._
%% Read and Organize the data
% Let us plot the survey of open clusters in equatorial coordinates, namely 
% right ascension (in hours) and declination (in degrees) above or below 
% the equatorial plane. Note that, while the data source with the full data 
% is listed in the lab handout, the numerical values needed here have been 
% compiled into a simplified table found in *|clusters_relevant.txt|*.
%
% First, we have to load the data and save the data to a matrix variable,
% e.g., *|cr|*:
cr = load('clusters_relevant.txt');
%%
% In this table the first, second, and third columns contain the RA in
% hours, minutes, and seconds. These values must be combined into a single 
% decimal value of hours:
RA = cr(:,1) + cr(:,2)/60 + cr(:,3)/3600;
%%
% The same goes for the declination, though it is given by degrees, arcmin,
% and arcsec in the fourth, fifth, and sixth columns respectively. Note
% that the sign of the Declination is included in the _degree_ column.
%
% To determine the sign of the Declination, use the *|sign|* command, which
% returns *1* if the element is greater than zero, *0* if it equals zero
% and *-1* if it is less than zero:
pmDec = sign(cr(:,4));
%%
% Be careful that some elements of *|pmDec|* might be zero, which also
% correspond to positive declination. To fix this, we can use *|find|*
% command to locate those zero elements:
fixpm = find(pmDec==0);
%%
% and then substitute those zero elements by *1*:
pmDec(fixpm) = 1;
%%
% Now we can calculate the Declination:
dec = (abs(cr(:,4)) + cr(:,5)/60 + cr(:,6)/3600).*pmDec;
%%
% The *|pmDec|* term simply insures the sign of declination carried by the
% fourth column value is carried over to the other two values added, as
% they will have matching sign.
%% Distribution of the clusters
% Now let's plot the open clusters in RA vs dec, i.e. equatorial
% coordinates.
figure(1); clf
plot(RA,dec,'b.')
title('distribution of the open clusters')
xlabel('RA (hrs)')
ylabel('dec (degrees)')
%% The ecliptic
% First, create an array of linearly spaced points from 0 to 24 hours:
hrs = linspace(0, 24, 200);
%%
% To generate the ecliptic, use the sine function and remember to convert
% *|hrs|* to radians:
eclip = 23.5*sin(hrs*2*pi/24);
%%
% Overplot the ecliptic with the open clusters:
figure(1); hold on;
plot(hrs, eclip, 'm-')
legend('OCs', 'ecliptic', 'Location', 'SouthEast')
%% Bonus track
% We can also plot, with a red circle, the location of the galactic center
% in order to get a feel for how open clusters are distributed in the
% galactic plane:
figure(1);
gal = [17 + 45/60. + 40.04/3600, -29 - 28.1/3600];
plot(gal(1),gal(2),'ro', 'LineWidth', 3, 'MarkerSize', 10)
%%
% Since the equatorial plane is tilted with respect to the galactic plane, 
% the clusters, which gather mostly in the galactic plane, follow a 
% sinusoidal curve on this plot.
