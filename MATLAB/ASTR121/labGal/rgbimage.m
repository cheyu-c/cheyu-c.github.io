%% Making composite images
%%
% Assuming that now you have data from B, V, and R filters, and the
% structure is aligned in all three images:
imagesc(M81B)
colorbar
%%
imagesc(M81V)
colorbar
%%
imagesc(M81R)
colorbar
%%
% Note that they might have different scaling of data. We have to normalize
% each image so that the values are between 0 and 1:
M81Bn = imscale(M81B, Bmax, Bmin);
M81Vn = imscale(M81V, Vmax, Vmin);
M81Rn = imscale(M81R, Rmax, Rmin);
%%
% Now they all have the same scaling:
imagesc(M81Bn)
colorbar
%%
imagesc(M81Vn)
colorbar
%%
imagesc(M81Rn)
colorbar
%%
% and we are ready to make composite image. We also need to create a matrix
% that has 3 planes of the correct size 
rgb=zeros([size(M81Bn),3]); 
%%
% _(Since *|M81B|*/*|M81Bn|*, *|M81R|*/*|M81Rn|*, and *|M81V|*/*|M81Vn|*
% all have the same size, it doesn't matter which one you choose to
% generate *|rgb|*._
% 
% Now we can insert *|M81Bn|* in the first plane (the blue), *|M81Vn|* in
% the second (the green), and *|M81Rn|* in the last (the red):
rgb(:,:,1) = M81Bn;
rgb(:,:,2) = M81Vn;
rgb(:,:,3) = M81Rn;
%%
% Now we can display the image:
imagesc(rgb)
%%