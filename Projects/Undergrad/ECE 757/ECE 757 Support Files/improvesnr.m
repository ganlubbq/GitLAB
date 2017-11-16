% improvesnr.m: using linear filters to improve SNR
time=3; Ts=1/20000;               % time and sampling interval
freqs=[0 0.29 0.3 0.4 0.41 1];    % filter design, bandlimited
amps=[0 0 1 1 0 0];               % ...between 3K and 4K
b=firpm(100,freqs,amps);          % BP filter
n=0.25*randn(1,time/Ts);          % generate white noise signal
x=filter(b,1,2*randn(1,time/Ts)); % do the filtering
y=filter(b,1,x+n);                % (a) filter the signal+noise
yx=filter(b,1,x);                 % or (b) filter signal 
yn=filter(b,1,n);                 % ...and noise separately
z=yx+yn;                          % add them
diffzy=max(abs(z-y))              % and make sure y = z 
snrinp=pow(x)/pow(n)              % SNR at input
snrout=pow(yx)/pow(yn)            % SNR at output

% check spectra
figure(1),plotspec(n,Ts)
figure(2),plotspec(x,Ts)
figure(3),plotspec(x+n,Ts)
figure(4),plotspec(y,Ts)

%Here's how the figure improvesnr.eps was actually drawn
N=length(x);                         % length of the signal x
t=Ts*(1:N);                          % define time vector
ssf=(-N/2:N/2-1)/(Ts*N);             % frequency vector
fx=fftshift(fft(x(1:N)+n(1:N)));
figure(5), subplot(2,1,1), plot(ssf,abs(fx))
xlabel('magnitude spectrum of signal + noise')
fy=fftshift(fft(y(1:N)));
subplot(2,1,2), plot(ssf,abs(fy))
xlabel('magnitude spectrum after filtering')
