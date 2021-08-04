%% Importing data
%%
% The data file downloaded from SkyServer can be imported using MATLAB
% internal function *|importdata|*. Use *|help|* to view detailed
% specifications:
help importdata
%%
% For the sample file |cluster1.dat|, we have one line of header text, and
% the file uses comma as the column separator. Therefore, to properly load
% the file, try
dat1 = importdata('cluster1.dat', ',', 1);
%%
% The variable *|dat1|* now contains three part:
dat1
%%
% You can view the header text (i.e., *|textdata|*) to see the order of
% parameters by typing
dat1.textdata
%%
% This tells us what each column in the data matrix is. Note that the *|g|*
% column is the 11th and the *|r|* column is the 12.
%
% Now, create a matrix containing the data (i.e., *|data|* in *|dat1|*) only:
cluster1data = dat1.data;
%%
% This is the matrix with data from stars in the cluster (one star in each
% row).