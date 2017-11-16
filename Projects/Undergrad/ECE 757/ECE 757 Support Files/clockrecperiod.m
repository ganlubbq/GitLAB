% clockrecperiod.m: resample to change the time base
% find tau to optimize J(tau)=|x(kT/m+tau)|^2

% prepare transmitted signal
n=4000;                            % number of data points
m=2;                               % oversampling factor
constel=2;                         % 2-pam constellation
beta=0.5;                          % rolloff parameter for srrc
l=50;                              % 1/2 length of pulse shape (in symbols)
chan=[1];                          % T/m "channel"
toffset=-1;                        % initial timing offset
pulshap=srrc(l,beta,m,toffset);    % srrc pulse shape
s=pam(n,constel,1);                % random data sequence with var=1
sup=zeros(1,n*m);                  % upsample the data by placing...
sup(1:m:n*m)=s;                    % ... p zeros between each data point
hh=conv(pulshap,chan);             % ... and pulse shape
r=conv(hh,sup);                    % ... to get received signal
matchfilt=srrc(l,beta,m,0);        % filter = pulse shape
x=conv(r,matchfilt);               % convolve signal with matched filter

% clockrecperiod.m: resample to change period
fac=1.0001; z=zeros(size(x)); % percent change in period
t=l+1:fac:length(x)-2*l;      % vector of new times
for i=l+1:length(t)           % resample x at new rate
  z(i)=interpsinc(x,t(i),l);  % to create received signal
end                           % with period offset
x=z;                          % relabel signal

% run clock recovery algorithm
tnow=l*m+1; tau=0; xs=zeros(1,n);          % initialize variables
tausave=zeros(1,n); tausave(1)=tau; i=0;
mu=0.05;                                   % algorithm stepsize
delta=0.1;                                 % time for derivative
while tnow<length(x)-l*m                   % run iteration
  i=i+1;
  xs(i)=interpsinc(x,tnow+tau,l);          % interpolated value at tnow+tau
  x_deltap=interpsinc(x,tnow+tau+delta,l); % get value to the right
  x_deltam=interpsinc(x,tnow+tau-delta,l); % get value to the left
  dx=x_deltap-x_deltam;                    % calculate numerical derivative
  tau=tau+mu*dx*xs(i);                     % alg update (energy)
  tnow=tnow+m; tausave(i)=tau;             % save for plotting
end

% plot results
subplot(2,1,1), plot(xs(1:i-2),'b.')       % plot constellation diagram
title('constellation diagram');
ylabel('estimated symbol values')
subplot(2,1,2), plot(tausave(1:i-2))       % plot trajectory of tau
ylabel('offset estimates'), xlabel('iterations')

