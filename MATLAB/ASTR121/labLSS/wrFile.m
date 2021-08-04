%% Writing data to text file
% The simplest format for data is text files. These files are frequently
% also called ASCII files (ASCII -- pronounced aski -- stands for American
% Standard Code for Information Interchange, a standard for numerically 
% representing alphabets developed in the 1960s). There is more than one
% way to save data to a text file, depends on what kind of data we have.
%% Writing numeric matrix to file (1) -- 'save'
% Assuming we have 3 objects and for each of them we are going to measure 
% the wavelengths for *K* line and *H* line. Let's use the first rows of 
% *|waveK|* and *|waveH|* to save our wavelength measurements of object 1:
waveK(1) = 4030;
waveH(1) = 4060;
%%
% Then use the second rows for object 2:
waveK(2) = 4080;
waveH(2) = 4100;
%%
% and the third rows for object 3:
waveK(3) = 3900;
waveH(3) = 3990;
%%
% Then, use the vector operations, we have the velocity from K-line (note
% that we only want the absolute value):
velK = c*abs(waveK - Kline)/Kline;
%%
% and the velocity from H-line:
velH = c*abs(waveH - Hline)/Hline;
%%
% Taking the average of these two gives us the average velocity:
avgV = 0.5*(velK + velH);
%%
% Now we can combine our data into a matrix *|m|* (note the transpose!)
m = [avgV; waveK; velK; waveH; velH]'
%%
% When there are only numbers, the simplest (and least flexible) is to use 
% the command *|save|*, which tells MATLAB to save the contents of the 
% array *|m|* in text format in the file *|mydata1.txt|*, in 8-digit ASCII 
% format:
save mydata1.txt -ascii m
%%
% You can check your file by using *|type|*:
type mydata1.txt
%%
% Note that this only works when there are all numbers and no characters!
%% Writing numeric matrix to file (2) -- 'dlmwrite'
% However, for CLEA to read, this must be a comma-separated file, which is
% not supported by *|save|*. An alternative way is to use *|dlmwrite|*:
dlmwrite('mydata2.txt', m, 'delimiter', ',', 'precision', '%E')
%%
% The attribute *|delimiter|* and the following value (*|','|* here)
% defines the delimiter string to be used in separating matrix elements, 
% and *|precision|* gives the numeric precision, which can be specified by 
% the number of siginificant digits or a C-style format string starting in 
% *|%|*, such as *|%10.5f|*. The conversion character *|%E|* we used here 
% means exponential notation, using a uppercase *E* as in *3.1415E+00*.
% 
% Now we have the comma-separated file:
type mydata2.txt
%% Writing data to file -- 'fprintf'
% What about if we want to include the object name into the file? We have
% to use the C-like command *|fprintf|*. This allows for arbitrary output
% formats, so it is infinitely flexible.
% 
%
% Let's construct a vector to save the object names first:
objs = ['object1'; 'object2'; 'object3']
%%
% Note that, MATLAB treats *|objs|* as a character array so that
% *|objs(1,1)|* is *|o|*, and *|objs(2,3)|* is *|j|*. You can also use
% *|size|* to see this:
size(objs)
%%
% To combine the characters (or to tell MATLAB that "object1" is a word),
% we must transform this character array into a cell array of strings:
objNames = cellstr(objs)
%%
% Again, try use *|size|* to see what's the difference!
size(objNames)
%%
% Now we are ready to write the data into file. First, we must open a file 
% *|mydata2.txt|* for writing (the old contents are erased):
fout = fopen('mydata3.txt','w');
%%
% The permission argument *|'w'|* will discard any existing contents in the
% file *|mydata2.txt|*. To append data to the end of an already-existing 
% file, use *|'a'|* instead.
%
% Since we have both strings and numbers to write, let's use the *|for|*
% loop we learned last week:
for i=1:3
    fprintf(fout,'%s,', objNames{i}); 
    fprintf(fout,'%E,%E,%E,%E,%E\n', m(i,:)); 
end
%%
% The conversion character *|%s|* stands for *strings*. Other choices are 
% *|%d|* (integers), *|%c|* (sequence of characters), etc. And the 
% character *|\n|* is an escape character sequence we use to specify
% nonprinting characters in a format specification, means *new line*. You
% can find more specifiers by typing
help sprintf
%%
% After we finished writing, we use *|fclose|* to close the file.
fclose(fout);
%%
% And again, we can use *|type|* to check the file:
type mydata3.txt