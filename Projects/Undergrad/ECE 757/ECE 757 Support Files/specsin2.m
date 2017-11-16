% specsin2.m: spectrum of a sine wave via the FFT/DFT
f=100; Ts=1/1000; time=10.0;               % freq, sampling interval, time
t=Ts:Ts:time;                              % define a time vector
w=sin(2*pi*f*t);                           % define the sinusoid
N=2^10;                                    % size of analysis window
ssf=(-N/2:N/2-1)/(Ts*N);                   % frequency vector
fw=fft(w(1:N));                            % do DFT/FFT
fws=fftshift(fw);                          % shift it for plotting
figure(1), plot(t(1:N),w(1:N))             % plot the waveform
xlabel('seconds'); ylabel('amplitude')     % label the axes
figure(2), plot(ssf,abs(fws))              % plot magnitude spectrum
xlabel('frequency'); ylabel('magnitude')   % label the axes

