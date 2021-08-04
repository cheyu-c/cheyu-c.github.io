%% Script to plot an HR diagram
% Data for the brightest stars, taken from the SDSS web pages at 
% http://cas.sdss.org/dr7/en/proj/advanced/hr/simplehr.asp
% 
% AH 2010.1.29

%% Read in the data from a file called starsTmp.txt
% The file can be created by entering the values into a text-editor
% window and saving it.
X = importdata('starsTmp.txt',' ');     % read data file

%% Plot the data
clf                         % clear the figure
% First turn the x-axis around: more luminous is more negative
set(axes,'XDir','reverse', 'YDir', 'default')   
hold                        % lock plot with with these axis settings
plot(X(:,2), X(:,3), 'o')   % plot data
ylabel('B-V [mag]')         % make labels and title
xlabel('Absolute magnitude [mag]')
title('HR diagram of brightest stars, from the SDSS web pages')
hold                        % release plot