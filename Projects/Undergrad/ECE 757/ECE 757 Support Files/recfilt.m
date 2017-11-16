% recfilt.m: undo pulse shaping using correlation
str='Transmit this text string';         % message to be transmitted
m=letters2pam(str); N=length(m);         % 4-level signal of length N
M=10; mup=zeros(1,N*M); mup(1:M:N*M)=m;  % oversample by M
ps=hamming(M);                           % blip pulse of width M
x=filter(ps,1,mup);                      % convolve pulse shape with data
y=xcorr(x,ps);                           % correlate pulse with received signal
z=y(N*M:M:2*N*M-1)/(pow(ps)*M);          % downsample to symbol rate and normalize
mprime=quantalph(z,[-3,-1,1,3])';        % quantize to +/-1 and +/-3 alphabet
pam2letters(mprime)                      % reconstruct message
sum(abs(sign(mprime-m)))                 % calculate number of errors
