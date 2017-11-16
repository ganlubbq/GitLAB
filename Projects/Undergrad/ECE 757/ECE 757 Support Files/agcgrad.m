% agcgrad.m: minimize J(a)= avg{|a|(1/3 a^2 r^2 - ds)} by choice of a
n=10000;                           % number of steps in simulation
vr=1.0;                            % power of the input
r=sqrt(vr)*randn(n,1);             % generate random inputs
ds=0.15;                           % desired power of output
mu=0.001;                          % algorithm stepsize
lenavg=10;                         % length over which to average
a=zeros(n,1); a(1)=1;              % initialize AGC parameter
s=zeros(n,1);                      % initialize outputs
avec=zeros(1,lenavg);              % vector to store terms for averaging
for k=1:n-1
  s(k)=a(k)*r(k);                  % normalize by a(k)
  avec=[sign(a(k))*(s(k)^2-ds),avec(1:lenavg-1)];  % incorporate new update into avec
  a(k+1)=a(k)-mu*mean(avec);       % average adaptive update of a(k)
end

% draw agcgrad.eps
subplot(3,1,1)
plot(a)              % plot AGC values
title('Adaptive gain parameter')
subplot(3,1,2)
plot(r,'r')          % plot inputs and outputs
axis([0,10^4,-5,5])
title('Input r(k)')
subplot(3,1,3)
plot(s,'b')
axis([0,10^4,-5,5])
title('Output s(k)')
xlabel('iterations')

