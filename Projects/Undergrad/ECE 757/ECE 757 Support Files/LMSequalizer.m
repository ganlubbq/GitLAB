% LMSequalizer.m find a LMS equalizer f for the channel b
b=[0.5 1 -0.6];              % define channel
m=1000; s=pam(m,2,1);        % binary source of length m
r=filter(b,1,s);             % output of channel
n=4; f=zeros(n,1);           % initialize equalizer at 0
mu=.01; delta=2;             % stepsize and delay delta
for i=n+1:m                  % iterate
  rr=r(i:-1:i-n+1)';         % vector of received signal
  e=s(i-delta)-rr'*f;        % calculate error
  f=f+mu*e*rr;               % update equalizer coefficients
end

