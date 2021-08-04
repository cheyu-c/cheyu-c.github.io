%% Plotting the HR diagram
%%
% In order to plot the HR diagrams for the clusters we first want to 
% extract the relevant data for clarity. We want two arrays containing the 
% red and green magnitudes:
g1 = cluster1data(:,11);
r1 = cluster1data(:,12);
%%
% Now we can make the HR diagram by using these two sets. Firstly, because
% of the reverse nature of magnitudes (brighter object has lower value) we 
% reverse the y axis:
figure(1)
set(axes, 'YDir', 'reverse')
%%
% Then we plot the stellar magnitudes of the cluster with blue points:
plot(g1-r1, r1,'b.')
%%
% You can also add the axis information:
xlabel('g-r magnitude')
ylabel('r magnitude')
