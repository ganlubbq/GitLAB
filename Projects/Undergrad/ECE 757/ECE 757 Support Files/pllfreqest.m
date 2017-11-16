% pllfreqest.m: direct estimation of frequency in the time domain

Ts=1/10000; time=50; t=Ts:Ts:time;      % time vector
fc=100; phoff=-0.1;                     % carrier freq. and phase
r=cos(2*pi*fc*t+phoff);                 % construct carrier
fl=100; ff=[0 .01 .02 1]; fa=[1 1 0 0];
h=firpm(fl,ff,fa);                      % LPF design
mu=.003;                                % algorithm stepsize
f0=99.5;                                % assumed freq. at receiver
fest=zeros(1,length(t)); fest(1)=f0+2;  % initialize vector for estimates
z=zeros(1,fl+1);                        % initialize buffer for LPF
for k=1:length(t)-1                     % z contains past fl+1 inputs
  z=[(r(k)-cos(2*pi*fest(k)*t(k)))*sin(2*pi*fest(k)*t(k)), z(1:fl)];
  update=fliplr(h)*z';                  % new output of filter
  fest(k+1)=fest(k)-mu*update;          % algorithm update
end
plot(t,fest)
title('Frequency Tracking via the Direct method')
xlabel('time'); ylabel('frequency estimate')
