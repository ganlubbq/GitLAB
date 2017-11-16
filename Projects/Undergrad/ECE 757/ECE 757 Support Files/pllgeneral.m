% pllgeneral.m the Phase Locked Loop with an IIR LPF

Ts=1/10000; time=1; t=Ts:Ts:time;        % time vector
fc=1000; phoff=0.8;                      % carrier freq. and phase
rp=cos(4*pi*fc*t+2*phoff);               % simplified received signal
mu=.003;                                 % algorithm stepsize
a=[1 -1]; lena=length(a)-1;              % autoregressive coefficients
b=[-2 2-mu]; lenb=length(b);             % moving average coefficients
xvec=zeros(lena,1); evec=zeros(lenb,1);  % initial states in filter
f0=1000.0;                               % assumed freq. at receiver
theta=zeros(1,length(t)); theta(1)=0;    % initialize vector for estimates
for k=1:length(t)-1                      % e contains past fl+1 inputs
  e=rp(k)*sin(4*pi*f0*t(k)+2*theta(k));  % input to filter
  evec=[e;evec(1:lenb-1)];               % past values of inputs
  x=-a(2:lena+1)*xvec+b*evec;            % output of filter
  xvec=[x;xvec(1:lena-1,1)];             % past values of outputs
  theta(k+1)=theta(k)+mu*x;              % algorithm update
end
plot(t,theta)
title('Phase Tracking via the Phase Locked Loop')
xlabel('time'); ylabel('phase offset')
