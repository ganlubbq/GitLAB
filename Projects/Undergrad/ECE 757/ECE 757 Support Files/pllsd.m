% pllsd.m: phase tracking minimizing SD

Ts=1/10000; time=1; t=0:Ts:time-Ts;    % time interval & vector
fc=100; phoff=-0.8;                    % carrier freq. and phase
rp=cos(4*pi*fc*t+2*phoff);             % simplified rec signal
mu=.001;                               % algorithm stepsize
theta=zeros(1,length(t)); theta(1)=0;  % initialize estimates
fl=25; h=ones(1,fl)/fl;                % averaging coefficients
z=zeros(1,fl); f0=fc;                  % buffer for avg
for k=1:length(t)-1                    % run algorithm
  filtin=(rp(k)-cos(4*pi*f0*t(k)+2*theta(k)))*sin(4*pi*f0*t(k)+2*theta(k));
  z=[z(2:fl), filtin];                 % z contains past inputs
  theta(k+1)=theta(k)-mu*fliplr(h)*z'; % update = z convolve h
end

plot(t,theta)                             % plot estimated phase
title('Phase Tracking via SD cost')
xlabel('time'); ylabel('phase offset')
