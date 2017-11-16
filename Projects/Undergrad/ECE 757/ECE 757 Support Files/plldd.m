% plldd.m: decision directed phase tracking
% (must run pulrecsig first)
fl=100; fbe=[0 .2 .3 1];             % LPF parameters
damps=[1 1 0 0 ]; h=firpm(fl,fbe,damps); % & impulse response
fzc=zeros(1,fl+1);fzs=zeros(1,fl+1); % initialize filters
theta=zeros(1,N); theta(1)=-0.9;     % initial phase
mu=.03; j=1; f0=fc;                  % algorithm stepsize
for k=1:length(rsc)                  
  cc=2*cos(2*pi*f0*t(k)+theta(j));   % cosine for demod
  ss=2*sin(2*pi*f0*t(k)+theta(j));   % sine for demod
  rc=rsc(k)*cc; rs=rsc(k)*ss;        % do the demods
  fzc=[fzc(2:fl+1),rc];              % states for LPFs
  fzs=[fzs(2:fl+1),rs];
  x(k)=fliplr(h)*fzc';               % LPF gives x
  xder=fliplr(h)*fzs';               % & its derivative
  if mod(0.5*fl+M/2-k,M)==0          % downsample for timing
    qx=quantalph(x(k),[-3,-1,1,3]);  % quantize to alphabet
    theta(j+1)=theta(j)-mu*(qx-x(k))*xder; % algorithm update
    j=j+1;
  end
end

plot(theta)
xlabel('time')
ylabel('phase estimates')

