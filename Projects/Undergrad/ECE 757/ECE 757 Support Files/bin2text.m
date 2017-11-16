% ztext=bin2text(z)
% transform a vector of 7-bit binary 0-1 into a text string
function ztext=bin2text(z)
rp=floor(length(z)/7);
rez=num2str(z(1:7*rp)')';
ztext=char(bin2dec(reshape(rez,7,rp)'))';
