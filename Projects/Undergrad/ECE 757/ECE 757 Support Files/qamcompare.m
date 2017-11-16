% qamcompare.m: compare real and complex QAM implementations
N=1000; M=10; Ts=.0001;       % # symbols, oversampling factor
time=Ts*(N*M-1); t=0:Ts:time; % sampling interval and time
s1=pam(N,4,1); s2=pam(N,4,1); % length N real 2-level signals
ps=hamming(M);                % pulse shape of width M
fc=1000; th=-1.0; j=sqrt(-1); % carrier freq. and phase
s1up=zeros(1,N*M); s2up=zeros(1,N*M); 
s1up(1:M:end)=s1;             % oversample by M
s2up(1:M:end)=s2;             % oversample by M
sp1=filter(ps,1,s1up);        % convolve pulse shape with s1
sp2=filter(ps,1,s2up);        % convolve pulse shape with s2
% make real and complex-valued versions and compare
vreal=sp1.*cos(2*pi*fc*t+th)-sp2.*sin(2*pi*fc*t+th);
vcomp = real((sp1+j*sp2).*exp(j*(2*pi*fc*t+th)));
max(abs(vcomp-vreal))         % verify that they're the same
