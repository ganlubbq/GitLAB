% clockrecDD.m: clock recovery minimizing 4-PAM cluster variance
% to minimize J(tau) = (Q(x(kT/M+tau))-x(kT/M+tau))^2

% prepare transmitted signal
n=10000;                         % number of data points
m=2;                             % oversampling factor
beta=0.3;                        % rolloff parameter for srrc
l=50;                            % 1/2 length of pulse shape (in symbols)
chan=[1];                        % T/m "channel"
toffset=-0.3;                    % initial timing offset
pulshap=srrc(l,beta,m,toffset);  % srrc pulse shape with timing offset
s=pam(n,4,5);                    % random data sequence with var=5
sup=zeros(1,n*m);                % upsample the data by placing...
sup(1:m:n*m)=s;                  % ... m-1 zeros between each data point
hh=conv(pulshap,chan);           % ... and pulse shape
r=conv(hh,sup);                  % ... to get received signal
matchfilt=srrc(l,beta,m,0);      % matched filter = srrc pulse shape
x=conv(r,matchfilt);             % convolve signal with matched filter

% clock recovery algorithm
tnow=l*m+1; tau=0; xs=zeros(1,n);   % initialize variables
tausave=zeros(1,n); tausave(1)=tau; i=0;
mu=0.01;                            % algorithm stepsize
delta=0.1;                          % time for derivative
while tnow<length(x)-2*l*m          % run iteration
  i=i+1;
  xs(i)=interpsinc(x,tnow+tau,l);   % interp value at tnow+tau
  x_deltap=interpsinc(x,tnow+tau+delta,l); % value to right
  x_deltam=interpsinc(x,tnow+tau-delta,l); % value to left
  dx=x_deltap-x_deltam;             % numerical derivative
  qx=quantalph(xs(i),[-3,-1,1,3]);  % quantize to alphabet
  tau=tau+mu*dx*(qx-xs(i));         % alg update: DD
  tnow=tnow+m; tausave(i)=tau;      % save for plotting
end

% plot results
subplot(2,1,1), plot(xs(1:i-2),'b.')        % plot constellation diagram
title('constellation diagram');
ylabel('estimated symbol values')
subplot(2,1,2), plot(tausave(1:i-2))        % plot trajectory of tau
ylabel('offset estimates'), xlabel('iterations')

