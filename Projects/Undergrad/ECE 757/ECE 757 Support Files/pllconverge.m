% pllconverge.m simulate Phase Locked Loop

Ts=1/10000; time=1; t=Ts:Ts:time;     % time vector
fc=1000; phoff=-0.8;                  % carrier freq. and phase
rp=cos(4*pi*fc*t+2*phoff);            % simplified rec'd signal
fl=100; ff=[0 .01 .02 1]; fa=[1 1 0 0];
h=firpm(fl,ff,fa);                    % LPF design
mu=.003;                              % algorithm stepsize
f0=1000;                              % freq at receiver
theta=zeros(1,length(t)); theta(1)=0; % initialize estimates
z=zeros(1,fl+1);                      % initialize LPF
for k=1:length(t)-1                   % z contains past inputs
  z=[z(2:fl+1), rp(k)*sin(4*pi*f0*t(k)+2*theta(k))];
  update=fliplr(h)*z';                % new output of LPF
  theta(k+1)=theta(k)-mu*update;      % algorithm update
end
plot(t,theta)
title('Phase Tracking via the Phase Locked Loop')
xlabel('time'); ylabel('phase offset')
