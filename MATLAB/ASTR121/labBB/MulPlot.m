%% Multiple Plots
%%
% The easist way to compare two or more figures is to overplot them on the 
% same figure. Let's try to call *|functionExample|* with different input:
x = linspace(-1,1,200);
y1 = 1;
y2 = -0.5;
out1 = functionExample(x, y1);
out2 = functionExample(x, y2);
%%
% We can plot *|out1|* first:
figure(1); clf;
plot(x, out1);
xlabel('x-axis label');
ylabel('functionExample');
title('a plot of functionExample');
%%
% To overplot another curve on the original one, remember to use
hold on;
%%
% so the next *|plot|* command won't clean up the previous *|plot|*
% command. Then you can draw another curve
plot(x, out2)
%% Graph Legend
% When there are more than one line, you'll need to include graph legend 
% for lines to remind yourself which one represents what data set. The 
% syntax is simple:
legend('y = 1', 'y = -0.5', 'Location', 'NorthEastOutside');
%%
% Note that we wrote *|standard|* first because we plotted *|stdd|* first.
% The last parameter (*|'Location'|*) gives the specified location of the 
% legend box (*|'NorthEastOutside'|*) with respect to the axes. You can 
% type
help legend
%%
% in the Command Window to see more options.
%% Line Specification
% To make the overplotted figure easier to read, you may want to change the
% line specification, e.g. line style, color, and line width. Here are some
% examples:
%
% 1) Change the line style
figure(1); clf; hold on;
plot(x, out1)
plot(x, out2, '--')
xlabel('x-axis label');
ylabel('functionExample');
title('a plot of functionExample');
legend('y = 1', 'y = -0.5', 'Location', 'NorthEastOutside');
%%
% 2) Change the color:
figure(1); clf; hold on;
plot(x, out1, 'k')
plot(x, out2, 'c')
xlabel('x-axis label');
ylabel('functionExample');
title('a plot of functionExample');
legend('y = 1', 'y = -0.5', 'Location', 'NorthEastOutside');
%%
% 3) Change the line width:
figure(1); clf; hold on;
plot(x, out1, 'LineWidth', 2)
plot(x, out2)
xlabel('x-axis label');
ylabel('functionExample');
title('a plot of functionExample');
legend('y = 1', 'y = -0.5', 'Location', 'NorthEastOutside');
%%
% You can type
help plot
%%
% in the Command Window to find more options. Note that the default value
% is blue solid line (*|'b-'|*)
