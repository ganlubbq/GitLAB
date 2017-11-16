% n=text2bin(textstring)
% transform text string into a vector of binary 0-1
function n=text2bin(textstring)
bintext=dec2bin(double(textstring));  % text into binary
[rp,cp]=size(bintext);
n=str2num(reshape(bintext',1,rp*cp)')';

