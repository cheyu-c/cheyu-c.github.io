%% Plotting -- review
%% 
% You probably have realized that the easiest way to load your *|.dat|*
% files is to use *|load|*:
load('binary1.dat');
%%
% Now you have a variable *|binary1|* 
binary1
%%
% with it's first row the wavelength
binary1(:,1)
%%
% and second row the normalized flux
binary1(:,2)
%%
% Recall your knowledge about *|plot|* function, and plot wavelength vs.
% normalized flux:
plot(binary1(:,1), binary1(:,2))
%%
% You may want to add title to your plot:
title('whatever you can think about');
%%
% Also, it's important to properly mark the axes so everyone can understand
% your figure. Simply use
xlabel('what is the x-coordinate?');
ylabel('this is normalized flux');
%% 