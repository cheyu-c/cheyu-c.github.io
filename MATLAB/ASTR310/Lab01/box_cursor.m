function [x0,y0,nx,ny]=box_cursor( ) 

k = waitforbuttonpress;
point1 = get(gca,'CurrentPoint');   % button down detected
finalRect = rbbox;                   % return figure units
point2 = get(gca,'CurrentPoint');   % button up detected
rect=zeros(1,4);
x0=round(min([point1(1,1);point2(1,1)]));
y0=round(min([point1(1,2);point2(1,2)]));
nx=round(max(abs([point1(1,1);point2(1,1)]-x0)));
ny=round(max(abs([point1(1,2);point2(1,2)]-y0)));

if (nargout==0),
    fprintf(1,'x0,y0,nx,ny=%d,%d,%d,%d\n',x0,y0,nx,ny);
end

