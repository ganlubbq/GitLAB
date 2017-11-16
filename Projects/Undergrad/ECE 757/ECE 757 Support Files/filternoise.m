% filternoise.m filter a noisy signal three ways
time=3;                          % length of time
Ts=1/10000;                      % time interval between samples
x=randn(1,time/Ts);              % generate noise signal
figure(1),plotspec(x,Ts)         % draw spectrum of input
freqs=[0 0.2 0.21 1];
amps=[1 1 0 0];
b=firpm(100,freqs,amps);         % specify the LP filter
ylp=filter(b,1,x);               % do the filtering
figure(2),plotspec(ylp,Ts)       % plot the output spectrum

freqs=[0 0.24 0.26 0.5 0.51 1];
amps=[0 0 1 1 0 0];
b=firpm(100,freqs,amps);         % BP filter
ybp=filter(b,1,x);               % do the filtering
figure(3),plotspec(ybp,Ts)       % plot the output spectrum

freqs=[0 0.74 0.76 1];
amps=[0 0 1 1];
b=firpm(100,freqs,amps);         % specify the HP filter
yhp=filter(b,1,x);               % do the filtering
figure(4),plotspec(yhp,Ts)       % plot the output spectrum

%Here's how the figure filternoise.eps was actually drawn
N=length(x);                     % length of the signal x
t=Ts*(1:N);                      % define a time vector
ssf=(-N/2:N/2-1)/(Ts*N);         % frequency vector
fx=fftshift(fft(x(1:N)));
figure(5), subplot(4,1,1), plot(ssf,abs(fx))
xlabel('magnitude spectrum at input')
fyl=fftshift(fft(ylp(1:N)));
subplot(4,1,2), plot(ssf,abs(fyl))
xlabel('magnitude spectrum at output of low pass filter')
fybp=fftshift(fft(ybp(1:N)));
subplot(4,1,3), plot(ssf,abs(fybp))
xlabel('magnitude spectrum at output of band pass filter')
fyhp=fftshift(fft(yhp(1:N)));
subplot(4,1,4), plot(ssf,abs(fyhp))
xlabel('magnitude spectrum at output of high pass filter')
