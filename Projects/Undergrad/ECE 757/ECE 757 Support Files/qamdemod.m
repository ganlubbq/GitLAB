% qamdemod.m: modulate and demodulate a complex-valued QAM signal
N=10000; M=15; Ts=.0001; j=sqrt(-1);   % # symbols, oversampling factor
time=Ts*(N*M-1); t=0:Ts:time;          % sampling interval and time vectors
m=pam(N,4,1)+j*pam(N,4,1);             % signals of length N
ps=hamming(M).';                       % pulse shape of width M
fc=1000; th=0;                         % carrier freq. and phase

mup=zeros(1,N*M); mup(1:M:end)=m;      % oversample by integer length M
mp=filter(ps,1,mup);                   % convolve pulse shape with data
v=real(mp.*exp(j*(2*pi*fc*t+th)));     % complex carrier

cng = 0.25;
noise = cng*randn(N*M,1).';            % Gaussian Noise
nc = noise+j*noise;                    % Complex signal
v=v+nc;
figure(7),subplot(2,1,1),plot(real(nc)),subplot(2,1,2),plot(imag(nc));
figure(8),plotspec(nc,1/M)


f0=1000; ph=0;                         % freq. and phase of demod
x=v.*exp(-j*(2*pi*f0*t+ph));           % demodulate v
l=50; f=[0,0.2,0.25,1]; a=[1 1 0 0];   % specify filter parameters
b=firpm(l,f,a);                        % design filter
s=filter(b,1,x);                       % s=LPF{x}

figure(1),plotspec(mp,1/M)             % spectrum of message
title('Original Message')
figure(2),plotspec(v,1/M)              % spectrum of transmitted signal
title('Noisy Transmitted Waveform')
figure(3),plotspec(x,1/M)              % demodulated signal
figure(4),plotspec(s,1/M)              % demodulated signal after LPF
figure(5),subplot(2,1,1),plot(real(mp(500:1000)))     % compare transmitted and received
hold on
plot(real(2*s(500+25:1000+25)),'r')                    % real parts
hold off
title('Transmitted Vs. Received (Real)')
subplot(2,1,2),plot(imag(mp(500:1000)))     % compare transmitted and received
hold on
plot(imag(2*s(500+25:1000+25)),'r')          % imaginary parts
title('Transmitted Vs. Received (Imaginary)')
hold off


xeye=real(2*s);
neye=5;                             % size of groups
c=floor(length(xeye)/(neye*M));     % number of eyes to plot
xp=xeye(N*M-neye*M*c+1:N*M);        % ignore transients at start

xeye2=imag(2*s);
c2=floor(length(xeye2)/(neye*M));
xp2=xeye2(N*M-neye*M*c2+1:N*M);

figure(9)
subplot(2,1,1),plot(reshape(xp,neye*M,c))
title('Eye Diagram (Real) Noise Power 0.15');
subplot(2,1,2),plot(reshape(xp2,neye*M,c2))
title('Eye Diagram (Imaginary) Noise Power 0.15');

