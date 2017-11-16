% agcvsfading.m: compensating for fading with an AGC
n=50000;                           % # steps in simulation
r=randn(n,1);                      % generate random inputs
env=0.75+abs(sin(2*pi*[1:n]'/n));  % the fading profile
r=r.*env;                          % apply to raw input r[k]
ds=0.5;                            % desired power of output
a=zeros(1,n); a(1)=1;              % initialize AGC parameter
s=zeros(1,n);                      % initialize outputs
mu=0.01;                           % algorithm stepsize
for k=1:n-1
  s(k)=a(k)*r(k);                  % normalize by a to get s
  a(k+1)=a(k)-mu*(s(k)^2-ds);      % adaptive update of a(k)
end


% draw agcgrad.eps
subplot(3,1,2), plot(a,'g')        % plot AGC values
axis([0,length(r),0,1.5])
title('Adaptive gain parameter')
subplot(3,1,1), plot(r,'r')        % plot inputs and outputs
axis([0,length(r),-7,7])
title('Input r(k)')
subplot(3,1,3),plot(s,'b')
axis([0,length(r),-7,7])
title('Output s(k)')
xlabel('iterations')


