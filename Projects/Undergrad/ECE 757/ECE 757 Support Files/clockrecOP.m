% clockrecOP.m:  clock recovery maximizing output power
% find tau to optimize J(tau)=|x(kT/m+tau)|^2

% prepare transmitted signal
n=5000;                            % number of data points
m=2;                               % oversampling factor
constel=2;                         % 2-pam constellation
beta=0.5;                          % rolloff parameter for srrc
l=50;                              % 1/2 length of pulse shape (in symbols)
chan=[1];                          % T/m "channel"
toffset=-0.3;                      % initial timing offset
pulshap=srrc(l,beta,m,toffset);    % srrc pulse shape
s=pam(n,constel,1);                % random data sequence with var=1
sup=zeros(1,n*m);                  % upsample the data by placing...
sup(1:m:end)=s;                    % ... p zeros between each data point
hh=conv(pulshap,chan);             % ... and pulse shape
r=conv(hh,sup);                    % ... to get received signal
matchfilt=srrc(l,beta,m,0);        % filter = pulse shape
x=conv(r,matchfilt);               % convolve signal with matched filter

% run clock recovery algorithm
tnow=l*m+1; tau=0; xs=zeros(1,n);   % initialize variables
tausave=zeros(1,n); tausave(1)=tau; i=0;
mu=0.05;                            % algorithm stepsize
delta=0.1;                          % time for derivative
while tnow<length(x)-l*m            % run iteration
  i=i+1;
  xs(i)=interpsinc(x,tnow+tau,l);   % interp at tnow+tau
  x_deltap=interpsinc(x,tnow+tau+delta,l);  % value to right
  x_deltam=interpsinc(x,tnow+tau-delta,l);  % value to left
  dx=x_deltap-x_deltam;             % numerical derivative
  tau=tau+mu*dx*xs(i);              % alg update (energy)
  tnow=tnow+m; tausave(i)=tau;      % save for plotting
end

% plot results
subplot(2,1,1), plot(xs(1:i-2),'b.')    % plot constellation diagram
title('constellation diagram');
ylabel('estimated symbol values')
subplot(2,1,2), plot(tausave(1:i-2))               % plot trajectory of tau
ylabel('offset estimates'), xlabel('iterations')

