% LMSequalizerQAM.m 4-QAM LMS equalizer
b=[0.5+0.2*j 1 -0.6-0.2*j];  % define complex channel
m=1000;                      % how many data points
s=pam(m,2,1)+j*pam(m,2,1);   % 4-QAM source of length m
r=filter(b,1,s);             % output of channel
n=4; f=zeros(n,1);           % initialize equalizer at 0
mu=.01; delta=2;             % stepsize and delay delta
y=zeros(n,1);                % place to store output
for i=n+1:m                  % iterate
  y(i)=r(i:-1:i-n+1)*f;      % output of equalizer
  e=s(i-delta)-y(i);         % calculate error term
  f=f+mu*e*r(i:-1:i-n+1)';   % update equalizer coefficients
end
