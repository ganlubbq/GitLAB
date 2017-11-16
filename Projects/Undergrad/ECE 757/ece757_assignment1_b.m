time=3;                          % length of time
Ts=1/20000;                      % time interval between samples
x=randn(1,time/Ts);              % generate noise signal
figure(1),plotspec(x,Ts)         % draw spectrum of input

% Changing the sampling time to 1/20,000 extends the spectrum, from 5 kHz
% to 10 kHz. Adjusting the filters will be done by changing the
% percentages, matching the new total of 10 kHz. With a doubled spectrum,
% the percentages need to be divided in half.

freqs=[0 0.05 0.07 0.75 0.76 1];  % Exercise 2.10
amps =[0 0 1 1 1 1];             % filter all frequencies above 500 Hz.
b=firpm(100,freqs,amps);         % specify the HP filter.
yhp2=filter(b,1,x);              % filtering
figure(6),plotspec(yhp2,Ts)      % plot the output spectrum. Please work
 
freqs=[0 0.3 0.305 1];           % Filter all frequencies below 3 kHz.
amps =[1 1 0 0];                 % specify the amplitude positioning
b=firpm(100,freqs,amps);         % LP filter, at 60% of 5 kHz.
ylp2=filter(b,1,x);              % filtering
figure(7),plotspec(ylp2,Ts)      % plot the output spectrum.

freqs=[0 0.15 0.17 0.23 0.25 1];   % specify the BP filter
amps =[1 1 0 0 1 1];             % rejects frequencies 1.5 kHz to 2.5 kHz
b=firpm(100,freqs,amps);         % do the filtering
ybp2=filter(b,1,x);              % utilizes filter function.
figure(8),plotspec(ybp2,Ts)      % plot the spectrum

%Here's how the figure filternoise.eps was actually drawn
N=length(x);                     % length of the signal x
t=Ts*(1:N);                      % define a time vector
ssf=(-N/2:N/2-1)/(Ts*N);         % frequency vector
fx=fftshift(fft(x(1:N)));
figure(5), subplot(4,1,1), plot(ssf,abs(fx))
xlabel('magnitude spectrum at input')
fyl=fftshift(fft(ylp2(1:N)));
subplot(4,1,2), plot(ssf,abs(fyl))
xlabel('magnitude spectrum at output of low pass filter')
fybp2=fftshift(fft(ybp2(1:N)));
subplot(4,1,3), plot(ssf,abs(fybp2))
xlabel('magnitude spectrum at output of band pass filter')
fyhp2=fftshift(fft(yhp2(1:N)));
subplot(4,1,4), plot(ssf,abs(fyhp2))
xlabel('magnitude spectrum at output of high pass filter')