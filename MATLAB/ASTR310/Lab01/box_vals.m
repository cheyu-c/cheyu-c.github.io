function box_vals(av,difs)

[x0,y0,nx,ny]=box_cursor;
avbox=av(y0:(y0+ny),x0:(x0+nx));
difbox=difs(y0:(y0+ny),x0:(x0+nx));
avm=mean(avbox(:));
dfm=mean(difbox(:));
sigav=std(avbox(:));
sigdif=std(difbox(:));
fprintf(1,'mean intensity = %0.3f, std of intensity = %0.3f\n',avm,sigav);
fprintf(1,'mean variance = %0.3f, std of variance = %0.3f\n',dfm,sigdif);
