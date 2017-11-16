% textman.m read in raw text file and remove excess spaces
% fix capitalization and punctuation. Output is a .mat file
% that can be read by textsim.m
bookname='Fred:repub11.txt'                   % input filename
[fid,messagei] = fopen(bookname,'r');         % open file
fdata=fread(fid)';                            % read in text
fclose(fid);                                  % close file
k=find((fdata>=44 & fdata<=46) | fdata==13);  % remove LFs
fdata(k)=32*ones(size(k));
k=find(fdata>=65 & fdata<=90);                % change capitals
fdata(k)=fdata(k)+32*ones(size(k));           %   to small letters
k=find((fdata<97 | fdata>123) & fdata~=32);   % remove other
k=[k length(fdata)];                          %   extraneous characters
f=fdata(1:k(1)-1);
for i=1:length(k)-1
  f=[f fdata(k(i)+1:k(i+1)-1)];
end
k=find(f(1:length(f)-1)==abs(' ') & f(2:length(f))==abs(' '));
k=[k length(f)];                              % remove excess spaces
fdata=f(1:k(1)-1);
for i=1:length(k)-1
  fdata=[fdata f(k(i)+1:k(i+1)-1)];
end
text=setstr(fdata);                           % from vector to character
save file.mat text                            % save as .mat file
