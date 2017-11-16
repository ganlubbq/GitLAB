% redundant.m redundancy of written english in bits and letters
textm='It is clear, however, that by sending the information in a redundant form the probability of errors can be reduced.'
% 8-bit ascii (binary) equivalent of text
ascm=dec2bin(double(textm),8); 
% turn into one long binary string
binm=reshape(ascm',1,8*length(textm));
per=.01;                    % probability of bit error
for i=1:8*length(textm)
  r=rand;                   % swap 0 and 1 with probability per
  if (r>1-per) & binm(i)=='0', binm(i)='1'; end
  if (r>1-per) & binm(i)=='1', binm(i)='0'; end
end
ascr=reshape(binm',8,length(textm))'; % to ascii binary
textr=setstr(bin2dec(ascr)')          % to text
biterror=sum(sum(abs(ascr-ascm)))     % # of bit errors
symerrror=sum(sign(abs(textm-textr))) % # of symbol errors
numwords=sum(sign(find(textm==32)))+1 % # of words in textm
letterror=symerrror/length(textm)     % # of letter errors
