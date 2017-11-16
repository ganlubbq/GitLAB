%% Part 1
%
% Jordan Smith
% ECE 714 - Digital Signal Processing
% Assignment #7 - Frequency Multiplexing Using Complex Analytic Signals
% December 09, 2016
%
% Load the three audio samples, which have the same length N, as w1, w2,
% and w3 using the audioread command. Also create the transpose of each
% audio vector. Then plot the frequency spectrum from 0 to fs and the
% vertical axis scaled from 0 to 500.

[w1, fs] = audioread('audio_7_1.wav');
[w2, fs] = audioread('audio_7_2.wav');
[w3, fs] = audioread('audio_7_3.wav');

w1 = w1';                               % Transpose
w2 = w2';
w3 = w3';

f = fs*(0:length(w1)-1)/length(w1);     % frequency axis

figure(1)
plot(f,abs(fft(w1))), xlabel('Frequency(Hz)'), ylabel('|w1(f)|');
title('Part 1 - w1 Frequency Spectrum')
axis([0 fs 0 500]);

figure(2)
plot(f,abs(fft(w2))), xlabel('Frequency(Hz)'), ylabel('|w2(f)|');
title('Part 1 - w2 Frequency Spectrum')
axis([0 fs 0 500]);

figure(3)
plot(f,abs(fft(w3))), xlabel('Frequency(Hz)'), ylabel('|w3(f)|');
title('Part 1 - w3 Frequency Spectrum')
axis([0 fs 0 500]);

%% Part 2
%
% Goal is to create a single real valued signal with all three audio
% waveforms, by allocating a third of the bandwidth via a third of fs/2.
% Need to create an FIR Lowpass Filter with a bandwidth slightly less than
% fs/12, or 1/6th of fs/2.

b = fir1(512,0.16);
fb = fs*(0:length(b)-1)/(length(b));    % frequency axis correlated to LPF

figure(4)
plot(fb,abs(fft(b))); xlabel('Frequency(Hz)'), ylabel('|b(f)|');
title('Part 2 - Lowpass FIR Filter Frequency Spectrum')
axis([0 48000 0 2.5]);

%% Part 3
%
% Create an "analytic" bandpass filter from the real valued lowpass filter
% so that only a single pass-band is present over the entire range 0 to fs.
% To do this, create a complex cosine (cc = cos + j sin) of frequency fs/12
% with the same number of time values as there are filter coefficients in 
% b. Then, multiply the filter coefficients b (the impulse response of the 
% FIR filter) by the complex cosine values to shift the pass band of the 
% filter to the right by fs/12. Add in a factor of 2 so that the final 
% filter will have a gain of 2. We need to do this because the analytic 
% pass-band filter will be filtering out half of the signal power (the 
% negative frequency components) and the gain of 2 will keep the resulting 
% signal power the same.

cc=cos(2*pi*(0:512)*(fs/12)/fs) + j*sin(2*pi*(0:512)*(fs/12)/fs);
bc =2*b.*cc;

f3 = fs*(0:length(bc)-1)/length(bc);

figure(5)
plot(f3,abs(fft(bc))), xlabel('Frequency(Hz)'), ylabel('|bc(f)|');
title('Part 3 - Analytic Bandpass Filter Frequency Spectrum');
axis([0 fs 0 2.5]);

%% Part 4
%
% Filter each part of the waveforms using the filter() function for each
% waveform. Information is retained, via listening to sound(real(w1c),fs)
% and sound(imag(w2c),fs).

w1c = filter(bc, 1, w1);
w2c = filter(bc, 1, w2);
w3c = filter(bc, 1, w3);

f41 = fs*(0:length(w1c)-1)/length(w1c);
f42 = fs*(0:length(w2c)-1)/length(w2c);
f43 = fs*(0:length(w3c)-1)/length(w3c);

figure(6)
plot(f41, abs(fft(w1c))), xlabel('Frequency(Hz)'), ylabel('|w1c(f)|');
title('Part 4 - Filtered Waveform w1c Frequency Spectrum');
axis([0 fs 0 500]);

figure(7)
plot(f42, abs(fft(w2c))), xlabel('Frequency(Hz)'), ylabel('|w2c(f)|');
title('Part 4 - Filtered Waveform w2c Frequency Spectrum');
axis([0 fs 0 500]);

figure(8)
plot(f43, abs(fft(w3c))), xlabel('Frequency(Hz)'), ylabel('|w3c(f)|');
title('Part 4 - Filtered Waveform w3c Frequency Spectrum');
axis([0 fs 0 500]);

%% Part 5
%
% At this point, each of the signals occupy the same third of the frequency
% spectrum so that they can not simply be added. Let ccr be the complex 
% cosine needed to shift the waveforms up in frequency (to the right along 
% the frequency axis) by fs/6, where N is the number of samples in each 
% individual waveform, and fshift is the amount we want to shift the 
% spectrum (fs/6). Form a new complex signal by multiplying w2c by ccr to 
% get w2cc:

fshift = fs/6;
N = length(w2);
ccr = cos(2*pi*(0:N-1)*(fshift)/fs) + j*sin(2*pi*(0:N-1)*(fshift)/fs);
w2cc = w2c.*ccr;

f5 = fs*(0:length(w2cc)-1)/length(w2cc);

figure(9)
plot(f5,abs(fft(w2cc))), xlabel('Frequency(Hz)'),ylabel('|w2cc(f)|');
title('Part 5 - Complex w2cc Frequency Spectrum')
axis([0 fs 0 500]);

%% Part 6
%
% Form a new complex signal by multiplying w3c by ccr, and then by ccr 
% again, to get w3cc:

w3cc = (w3c.*ccr).*ccr;

f6 = fs*(0:length(w3cc)-1)/length(w3cc);

figure(10)
plot(f6,abs(fft(w3cc))), xlabel('Frequency(Hz)'),ylabel('|w3cc(f)|');
title('Part 6 - Complex w3cc Frequency Spectrum')
axis([0 fs 0 500]);

%% Part 7
%
% The waveform w123c can now be formed, with each complex waveform produced
% in different frequency bands. The combined waveform is produced by simple
% addition.

w123c = w1c + w2cc + w3cc;

f7 = fs*(0:length(w123c)-1)/length(w123c);

figure(11)
plot(f7,abs(fft(w123c))),xlabel('Frequency(Hz)'),ylabel('|w123c(f)|');
title('Part 7 - Combined w123c Frequency Spectrum')
axis([0 fs 0 500])

%% Part 8
%
% Take the real portion of the complex w123c to form w123, and plot the
% frequency response for proper observation and analysis.

w123 = real(w123c);

f8 = fs*(0:length(w123)-1)/length(w123);

figure(12)
plot(f8,abs(fft(w123))),xlabel('Frequency(Hz)'),ylabel('|w123(f)|');
title('Part 8 - Real-Valued w123 Frequency Spectrum')
axis([0 fs 0 500])

%% Part 9
%
% Utilizing the analytic pass-band filter, the first waveform can be
% extracted from the signal that contains all three audio files.

w1rc = filter(bc, 1, w123);

f9 = fs*(0:length(w1rc)-1)/length(w1rc);

figure(13)
plot(f9,abs(fft(w1rc))),xlabel('Frequency(Hz)'),ylabel('|w1rc(f)|');
title('Part 9 - Recovered w1rc Frequency Spectrum');
axis([0 fs 0 500])

%% Part 10
%
% The real valued signal w1r can be recovered as well, by taking the real
% value of the filtered waveform from Part 9.

w1r = real(w1rc);

figure(14)
plot(f9,abs(fft(w1r))),xlabel('Frequency(Hz)'),ylabel('|w1r(f)|');
title('Part 10 - Real-Valued Reconstructed w1r Frequency Spectrum');
axis([0 fs 0 500])

%% Part 11
%
% Using another complex sinusoid, cl, the second audio signal can be
% reconstructed by frequency shifting the audio signal back down to
% baseband.

ccl = cos(2*pi*(0:N-1)*(-fshift)/fs) + j*sin(2*pi*(0:N-1)*(-fshift)/fs);
w231c = w123.* ccl;

figure(15)
plot(f9,abs(fft(w231c))),xlabel('Frequency(Hz)'),ylabel('|w231c(f)|');
title('Part 11 - Frequency Shifted w231c Frequency Spectrum');
axis([0 fs 0 500])

%% Part 12
%
% Waveform 2 can now be recovered, using the analytic bandpass filter to
% separate the 2nd waveform signal from the 3rd, which is still present in
% the band.

w2rc = filter(bc, 1, w231c);

figure(16)
plot(f9,abs(fft(w2rc))),xlabel('Frequency(Hz)'),ylabel('|w2rc(f)|');
title('Part 12 - 2^{nd} Waveform w2rc Frequency Spectrum')
axis([0 fs 0 500])

%% Part 13
%
% The real valued signal w2r can be extracted from the complex 2nd waveform
% that had been frequency shifted and filtered. Utilizing the "sound"
% command, the signal can be listened to and heard, noting that information
% was properly recovered.

w2r = real(w2rc);

figure(17)
plot(f9,abs(fft(w2r))),xlabel('Frequency(Hz)'),ylabel('|w2r(f)|');
title('Part 13 - Real-Valued w2r Frequency Spectrum')
axis([0 fs 0 500])

%% Part 14
%
% The third waveform had originally been modulated twice to place it in the
% upper third of the sampling frequency, whereas the second third was for
% the 2nd waveform. To frequency shift the third waveform, it will require
% the same treatment with demodulation.

w312c =(w123.*ccl).*ccl;

figure(18)
plot(f9,abs(fft(w312c))),xlabel('Frequency(Hz)'),ylabel('|w312c(f)|');
title('Part 14 - Frequency Shifted w312c Frequency Spectrum')
axis([0 fs 0 500])

%% Part 15
% 
% The third waveform can be recovered using the analytic bandpass to
% isolate the third waveform from the rest of the signal which had
% originally contained all three audio signals.

w3rc = filter(bc, 1, w312c);

figure(19)
plot(f9,abs(fft(w3rc))),xlabel('Frequency(Hz)'),ylabel('|w3rc(f)|');
title('Part 15 - Filtered w3rc Frequency Spectrum')
axis([0 fs 0 500])

%% Part 16
%
% The real valued signal w3r can be constructed by taking the real value of
% the complex signal which had been filtered in the previous portion of the
% assignment. The signal can be listened to by using the "sound" command
% within MATLAB.

w3r = real(w3rc);

figure(20)
plot(f9,abs(fft(w3r))),xlabel('Frequency(Hz)'),ylabel('|w3r(f)|');
title('Part 16 - Real Valued w3r Frequency Spectrum')
axis([0 fs 0 500])