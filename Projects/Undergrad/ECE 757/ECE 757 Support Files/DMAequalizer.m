% DMAequalizer.m find a DMA equalizer f for the channel b
b=[0.5 1 -0.6];              % define channel
m=1000; s=pam(m,2,1);        % binary source of length m
r=filter(b,1,s);             % output of channel
n=4; f=[0 1 0 0]';           % center spike initialization
mu=.01;                      % algorithm stepsize
for i=n+1:m                  % iterate
  rr=r(i:-1:i-n+1)';         % vector of received signal
  e=(f'*rr)*(1-(f'*rr)^2);   % calculate error
  f=f+mu*e*rr;               % update equalizer coefficients
end
