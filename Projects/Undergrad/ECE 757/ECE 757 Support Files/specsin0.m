% specsin0.m: naive and deceptive spectrum of a sine wave via the FFT
f=100; Ts=1/1000; time=5.0;    % freq, sampling interval, time
t=Ts:Ts:time;                  % define a time vector
w=sin(2*pi*f*t);               % define the sinusoid
N=2^10;                        % size of analysis window
fw=abs(fft(w(1:N)));           % find magnitude of DFT/FFT
subplot(2,1,1), plot(fw)       % plot the waveform

title('What do these mean?');  % label the x axis
xlabel('N=2^{10}')
ylabel('magnitude')            % label the y axis
N=2^11;                        % size of analysis window
fw=abs(fft(w(1:N)));           % find magnitude of DFT/FFT
subplot(2,1,2),plot(fw)
xlabel('N=2^{11}')
ylabel('magnitude')            % label the y axis
