%% Image Processing: Graphical Input
% Here we have a sample data array *|A|* which looks like dark sky with
% some bright stars:
imagesc(A)
%%
% This is the typical situation you may face: you have a very large data
% array with only a tiny part that are meaningful, and it takes a long time
% for you to find out where are those pixels which contain information
% you want. MATLAB provides a nice function called *|ginput|*, which allows
% you to obtain information from pixels you are interested in.
%
% After the image is showed, type
ginput
%%
% and then you can select points from the figure using the mouse for cursor
% positioning (just click your mouse button when the cursor is on the point
% you want). After you select all points you want, press the *Return* key
% on your keyboard. 
%
% This returns the x- and y-coordinates of those points you have selected.
%
% You can also specify the number of points you want to select:
ginput(2)
%%
% So that the function is automatically terminated after three points are 
% selected.
%
% If you want to save the coordinates for future use, you can save them in
% the vectors *|x|* and *|y|*:
[x, y] = ginput
%%
% Again, use the *Reture* key to terminate the input, or use
[x, y] = ginput(2)
%%
% to specify the number of points you want to select. The coordinate of the
% first point you select is *|(x(1), y(1))|*, the second is *|(x(2),
% y(2))|*, and so on.
%
% For example, now you can calculate the distance between the first two
% points you select:
D_Horizontal = x(2) - x(1)
%%
D_Vertical = y(2) - y(1)
%%
D = sqrt(D_Horizontal^2 + D_Vertical^2)
%%
% Note that, the first coordinate (*x*-) actually corresponds to the _second_
% dimension (column number) of the data array, and the second coordinate 
% (*y*-) corresponds to the _first_ dimension (row number). As a result, if 
% you find the coordinate of a point is *|(a, b)|*, then the location of this 
% pixel in the data array is actually *|(b, a)|* (round down to integer).