%% White Noise Analysis
%
% White noise, 160 kbps, Mono. Average level -18 dBFS. RMS value is -4.8
% dB. 10 seconds. White_noise.ogg will be imported, can be played, and an
% FFT of the display can show the distribution.


[w_noise, fs] = audioread('White_noise.ogg');

w_noise = w_noise.';
f = fs*(0:length(w_noise)-1)/length(w_noise);
t = (0:length(w_noise)-1)/fs;

figure(1)
plot(f,abs(fft(w_noise))), xlabel('Frequency(Hz)'), ylabel('|W(f)|');
title('Part 1 - White Noise Frequency Spectrum')
axis([0 fs 0 500]);

figure(2)
plot(t,w_noise),xlabel('Time(s)'), ylabel('w(t)');
title('White Noise Distribution')