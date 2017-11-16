% noisychan.m generate 4-level data and add noise
m=1000;                          % length of data sequence
p=1/15; s=1.0;                   % power of noise and signal
x=pam(m,4,s);                    % 4-PAM input with power 1...
L=sqrt(1/5);                     % ...with amp levels L
n=sqrt(p)*randn(1,m);            % noise with power p
y=x+n;                           % output adds noise to data
qy=quantalph(y,[-3*L,-L,L,3*L]); % quantize to [-3*L,-L,L,3*L]
err=sum(abs(sign(qy'-x)))/m;     % percent transmission errors
