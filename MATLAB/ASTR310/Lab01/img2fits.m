function img2fits(file)

fp=fopen(file,'r','b');
fseek(fp,160,'bof');
[v,cnt]=fread(fp,[384,576],'int16');
if (cnt~=(384*576)),
    disp('File corrupted. Length is incorrect.');
end
fn=[file(1:(end-4)),'.fits'];
wfits(v,fn)
