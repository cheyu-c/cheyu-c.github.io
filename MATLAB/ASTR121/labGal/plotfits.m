%% Visualizing FITS data
% _Make sure that you have the *|rfits.m|* function file in your current
% directory!_
%
%% Reading FITS file
% The syntax for *|rfits|* is similar to *|load|*, which you should now be
% familiar with:
colorB = rfits('MESSIER_081-I-B-pasp1997-b3x120s.fits');
%%
% To see what type of variable *|colorB|* is, we can use *|whos|*:
whos
%%
% Or, type *|colorB|* to see all its structure fields:
colorB
%% Plotting FITS file
% Note that, though there are a lot of fields in *|colorB|*, the image data
% is only stored in the field *|data|*. Therefore we want to extract the
% image data from the imported data structure:
M81B = colorB.data;
%%
% Then we can use *|imagesc|* to visualize it (with proper title and axis 
% labels): 
imagesc(M81B)
axis square
title('M81 (B filter)');
xlabel('pixel #'); ylabel('pixel #');
%%
% _Don't forget to use *|axis square|* to make the pixels square!_
%
% You can also call *|colorbar|* to add the color code info:
colorbar;
%%
% Note that, some images may have bad pixels that gives negative values. To
% remove these data points, try
M81B(M81B < 0) = 0;
%%
% This will replace every pixel with negative value by zero. Even though
% not all images have bad pixels, you should better do this step before you
% adopt the log-scale plot because you can take *|log|* on negative values!
%% Optimizing the plot
% As you can read from the colorbar, there is a large range of values in
% this image and thus some dimmer structures may not be resolved. Recall
% that, in this case, we can plot in log-scale to reveal those structures:
imagesc(log10(M81B))
axis square
colorbar
title('M81 in log10 scale (B filter)');
xlabel('pixel #'); ylabel('pixel #');
%%
% Now we see there are spiral arms! 
%
% But the image still doesn't look good enough because of the scaling. Note
% that, *|imagesc|* scales the data automatically, but you, the user, can 
% adjust the scaling boundary values by adding second argument *|[min 
% max]|*. The point to specify the boundary values is that sometimes the
% structure we are interested in is the dimmer part in the image, which
% can't be resolved because of some bright spots, just like the *|M81B|* we
% have here. 
%
% When a set of spicified boundary values is given, every pixel with value
% higher than the upper boundary will be shown in the same color as the
% upper boundary, and those with values smaller than the lower boundary
% will be shown as the lower boundary:
imagesc(log10(M81B), [2 4])
axis square
colorbar
title('M81 in log10 scale (B filter)');
xlabel('pixel #'); ylabel('pixel #');
%%
% As you can see, when we force *|imagesc|* to focus on the values between
% *|2|* and *|4|*, the dimmer structure is revealed. However, in the
% mean time, structures with values higher than *|4|* (e.g. the central 
% part of the galaxy) or lower than *|2|* (e.g. the outer part of the 
% galaxy) are not resolved. Therefore you must try many different boundary 
% values to find the best values.