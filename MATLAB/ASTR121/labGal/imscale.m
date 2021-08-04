function imr=imscale(im,maxv,minv)

% IMSCALE(im,maxv,minv) linearly rescales an image between 1 and 0 so 
% that maxv corresponds to a 1 and minv corresponds to a 0

imr=(im-minv)./(maxv-minv);
imr(imr<0)=0;
imr(imr>1)=1;
