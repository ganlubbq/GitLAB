% LSequalizer.m find a LS equalizer f for the channel b
b=[0.5 1 -0.6];                    % define channel
m=1000; s=sign(randn(1,m));        % binary source of length m
r=filter(b,1,s);                   % output of channel
n=3;                               % length of equalizer - 1
delta=3;                           % use delay <=n*length(b)
p=length(r)-delta;
R=toeplitz(r(n+1:p),r(n+1:-1:1));  % build matrix R
S=s(n+1-delta:p-delta)';           % and vector S
f=inv(R'*R)*R'*S                   % calculate equalizer f
Jmin=S'*S-S'*R*inv(R'*R)*R'*S      % Jmin for this f and delta
y=filter(f,1,r);                   % equalizer is a filter
dec=sign(y);                       % quantize and find errors
err=0.5*sum(abs(dec(delta+1:m)-s(1:m-delta)))

