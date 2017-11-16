%naivecode.m:  Try a naive encoding scheme

mesLen=1000;                         %message length
bits=(sign(rand(1,mesLen)-.5)+1)/2;  %binary message to send
%index into constl = 1+ bits(i) + 2*bits(i+1)
constl=[-3 1 -1 3];
k=1;
pam4mes=zeros(1,length(bits)/2);
for i=1:2:length(bits)
  pam4mes(k)=constl(1+bits(i)+2*bits(i+1));  %switch to a PAM4 constellation
  k=k+1;
end

v=.5; %noise variance

%pass the signal through a noisy channel
noisyPam=sqrt(v)*randn(1,length(pam4mes))+pam4mes;

%quantize the received signal
recSig=quantalph(noisyPam,[-3,-1,1,3]);

k=1;
recBits=zeros(1,2*length(recSig));
%decode the signal using the naive code
for i=1:length(recSig)
  if recSig(i)==3
    recBits(k)=1;
    recBits(k+1)=1;
  elseif recSig(i)==1
    recBits(k)=1;
    recBits(k+1)=0;
  elseif recSig(i)==-1
    recBits(k)=0;
    recBits(k+1)=1;
  elseif recSig(i)==-3
    recBits(k)=0;
    recBits(k+1)=0;
  end
  k=k+2;
end

%calculate the percentage error
percErrs=sum((recBits~=bits))/length(recBits)
