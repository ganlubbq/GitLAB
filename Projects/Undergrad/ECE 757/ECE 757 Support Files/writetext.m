% writetext.m write in a text file
[fid,messagei] = fopen('OZ.doc','w');        % open file for writing
fdata=fwrite(fid, text);                     % write text to file
