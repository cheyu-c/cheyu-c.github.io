%% Means and Standard Deviations of Box Pixels
% The following MATLAB procedure should be in your directory. Read the 
% commands to see how it works.
%
%% How to call the function?
% Suppose you have obtained the the average of the bias corrected images 
% and have called called it "sav" and the variance image is called "sdif2". 
% First display "sav":
%%
imagesc(sav);
%%
% Then invoke the procedure with 
%%
box_vals(sav, sdif2);
%% What does the function do?
% (You don't need to enter the commands below. They are already included in 
% the function "box_vals". This part of document is only for you to learn 
% what's inside the blackbox.)

%%
% The function "box_cursor" allows you to select the region of the image in 
% which you want to carry out the calculation, and save the location of the 
% box in (x0,y0) and the size in (nx,ny).
%%
[x0,y0,nx,ny]=box_cursor;
%%
% Now you will obtain two box pixels:
%%
avbox=av(y0:(y0+ny),x0:(x0+nx));
difbox=difs(y0:(y0+ny),x0:(x0+nx));
%%
% And the mean values of both boxes are calculated by using the MATLAB 
% internal function "mean":
avm=mean(avbox(:));
dfm=mean(difbox(:));
%%
% Similarly, you can use MATLAB function "std" to calculate the standard 
% deviations:
sigav=std(avbox(:));
sigdif=std(difbox(:));
%%
% Now you can print out the means of the box pixels of both "sav" and 
% "sdif2": (these numbers are just examples, so don't worry if you got 
% different numbers!)
%%
fprintf(1,'avm=%0.3f, sigav=%0.3f\n',avm,sigav);
%%
% Print out the standard deviations of the box pixels of both "sav" and 
% "sdif2":
%%
fprintf(1,'dfm=%0.3f, sigdif=%0.3f\n',dfm,sigdif);
%%
% You can also Print out the location and the size of the box:
%%
fprintf(1,'box=%d,%d,%d,%d\n',x0,y0,nx,ny);
%%
