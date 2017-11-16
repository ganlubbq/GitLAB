% codex.m example of Huffman coding and decoding
m=1000;                   % number of code words
% codex.m step 1: generate a 4-PAM sequence
% with probabilities 0.5, 0.25, 0.125, and 0.125
x=[];
for i=1:m
  r=rand;
  if r<0.5,
    x(i)=+1;
  elseif (r>=0.5)  & (r<0.75)
    x(i)=-1;
  elseif (r>=0.75) & (r<0.875)
    x(i)=+3;
  else % r>=0.875
    x(i)=-3;
  end
end
% codex.m step 2: encode the sequence using Huffman code
j=1;
cx=[];
for i=1:m
  if x(i)==+1,         cx(j)=[1];         j=j+1;
  elseif x(i)==-1,     cx(j:j+1)=[0,1];   j=j+2;
  elseif x(i)==+3,     cx(j:j+2)=[0,0,1]; j=j+3;
  elseif x(i)==-3,     cx(j:j+2)=[0,0,0]; j=j+3;
  end
end
% codex.m step 3: decode the variable length sequence
j=1; i=1;
y=[];
while i<=length(cx)
  if cx(i)==[1],
    y(j)=+1; i=i+1; j=j+1;
  elseif cx(i:i+1)==[0,1],
    y(j)=-1; i=i+2; j=j+1;
  elseif cx(i:i+2)==[0,0,1],
    y(j)=+3; i=i+3; j=j+1;
  elseif cx(i:i+2)==[0,0,0],
    y(j)=-3; i=i+3; j=j+1;
  end
end
err=sum(abs(x-y))
