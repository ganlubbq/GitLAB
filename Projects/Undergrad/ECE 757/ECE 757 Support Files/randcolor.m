% randcolor.m generating a colored noise spectrum
N=2^16;                          % how many random #'s
Ts=0.001; nyq=0.5/Ts;            % sampling and nyquist rates
ssf=(-N/2:N/2-1)/(Ts*N);         % frequency vector
x=randn(1,N);                    % N random numbers
fbe=[0 100 110 190 200 nyq]/nyq; % define desired filter
damps=[0 0 1 1 0 0];             % desired amplitudes
fl=70;                           % filter size
b=firpm(fl,fbe,damps);           % design impulse response
y=filter(b,1,x);                 % filter x with b
subplot(2,1,1), plot(ssf,fftshift(abs(fft(x))))  % plot spectrum of input
title('(a) Spectrum of random input signal'); xlabel('frequency in Hz');
ylabel('magnitude')
subplot(2,1,2), plot(ssf,fftshift(abs(fft(y))))  % plot spectrum of output
title('(a) Spectrum of the output'); xlabel('frequency in Hz');
ylabel('magnitude')
