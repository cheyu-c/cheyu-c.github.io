%% Age of cluster
%% Cluster HR Diagram
% Now you should have both the isochrones and data from cluster NGC 188. To
% remind you what are the variables, use
who
%%
% Let's make a HR diagram for NGC 188 by plotting *|V|* vs. *|B-V|* (don't
% forget to reverse the y-coordinate):
figure(3); clf;
plot(B-V, V, 'bo');
set(gca, 'YDir', 'reverse');
title('NGC 188');
xlabel('B-V'); ylabel('V');
%% Isochrone Matching
% Look carefully at the turning point of the main sequence, compare with
% your isochrones, and find out which isochrone has the same *|B-V|* value
% of the turning point. 
figure(4); clf; hold on;
plot(isoc.e9.five.B-isoc.e9.five.V, isoc.e9.five.V, 'm+');
plot(isoc.e9.eight.B-isoc.e9.eight.V, isoc.e9.eight.V, 'r+');
plot(isoc.e9.ten.B-isoc.e9.ten.V, isoc.e9.ten.V, 'y+');
set(gca, 'YDir', 'reverse');
legend('5e9 yr', '8e9 yr', '1e10 yr', 'Location', 'SouthWest');
title('isochrones');
xlabel('B-V'); ylabel('V');
xlim([-0.5 2]);
%%
% Now, consider the difference in *|V|* value between cluster NGC 188 and
% the isochrone you chose. Move the isochrone up and down to find the best
% matching:
figure(5); clf; hold on; 
plot(B-V, V, 'bo');
plot(isoc.e9.eight.B-isoc.e9.eight.V, isoc.e9.eight.V+10, 'm+');
plot(isoc.e9.eight.B-isoc.e9.eight.V, isoc.e9.eight.V+11, 'r+');
plot(isoc.e9.eight.B-isoc.e9.eight.V, isoc.e9.eight.V+12, 'y+');
set(gca, 'YDir', 'reverse');
legend('NGC 188', 'V+10', 'V+11', 'V+12', 'Location','NorthWest');
xlabel('B-V'); ylabel('V');
%%
