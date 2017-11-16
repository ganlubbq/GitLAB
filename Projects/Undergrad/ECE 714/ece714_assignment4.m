%% Part 1
% Jordan R. Smith
% ECE 714 - Assignment #4
% 24 October 2016
%
% Part 1-a.
% Assume a sampling rate of 10 kHz. Design two FIR LPF's using the
% assignment equation, (1) with N = 33, and (2) with N = 129. For each
% filter, the cut-off is 600 Hz. Stem the filter plots, FIR coefficients
% versus n.


fs = 10000;         % 10 kHz sampling rate
flp = 600;          % cutoff frequency
fc = 2400;          % 2.4 kHz center frequency
fhp = 4400;         % highpass frequency
wlp = 2*pi*flp/fs;  % normalized lowpass
wc = 2*pi*fc/fs;    % normalized cutoff


N33 = 33;           % Filter 1 Values
n33 = 0:N33-1;
d33 = (N33-1)/2;

N129 = 129;         % Filter 2 Values
n129 = 0:N129-1;
d129 = (N129-1)/2;

hlp33(n33+1) = (wlp/pi)*sinc((wlp/pi)*(n33-d33));       %LPF Coefficents
hlp129(n129+1) = (wlp/pi)*sinc((wlp/pi)*(n129-d129));

figure(1)
subplot(2,1,1)
stem(n33, hlp33)
title('Part 1-a. Order 32 Lowpass Filter Coefficients')
xlim([0 32])
subplot(2,1,2)
stem(n129, hlp129)
title('Order 128 Lowpass Filter Coefficients')
xlim([0 128])

% Part 1-b.
% Determine the frequency response of the two filters using the freqz()
% command, evaluating at 1024 points along the horizontal axis. Comment on
% differences in the report.

figure(2)
freqz(hlp33,1,1024,'whole',fs)
title('Part 1-b. Order 32 LPF Frequency Response')

figure(3)
freqz(hlp129,1,1024,'whole',fs)
title('Part 1-b. Order 128 LPF Frequency Response')

% Part 1-c.
% Repeat 1-a, but instead multiply the coefficient results by a blackman
% window, length N.

hlp33t = hlp33.';       % transposed vector, to operate with blackman().
hlp129t = hlp129.';

hlpblck33 = hlp33t.*blackman(N33);
hlpblck129 = hlp129t.*blackman(N129);

figure(4)
subplot(2,1,1)
stem(n33,hlpblck33)
title('Part 1-c. Order 32 Blackman Windowed Filter Coefficients')
subplot(2,1,2)
stem(n129,hlpblck129)
title('Part 1-c. Order 128 Blackman Windowed Filter Coefficients')

% Part 1-d.
% Determine the frequency response using freqz() of the newly windowed
% coefficients. Comment on the differences observed between the blackman
% frequency response, and the originally generated frequency response from
% part b.

figure(5)
freqz(hlpblck33,1,1024,'whole',fs)
title('Part 1-d. Order 32 Windowed Frequency Response')

figure(6)
freqz(hlpblck129,1,1024,'whole',fs)
title('Part 1-d. Order 128 Windowed Frequency Response')

% Part 1-e.
% Generate a bandpass filter from the original lowpass coefficients. The
% bandwidth is 1.2 kHz, due to the 600 Hz cutoff.

hbp33 = 2.*hlp33.*cos(wc.*(n33-d33));
hbp129 = 2.*hlp129.*cos(wc.*(n129-d129));

figure(7)
subplot(2,1,1)
stem(n33,hbp33)
title('Part 1-e. Order 32 Bandpass Filter Coefficients')
subplot(2,1,2)
stem(n129,hbp129)
title('Part 1-e. Order 128 Bandpass Filter Coefficients')

% Part 1-f.
% Determine the frequency response of the bandpass filter, and comment on
% the similarities and differences between the two filters.

figure(8)
freqz(hbp33,1,1024,'whole',fs)
title('Part 1-f. Order 32 Bandpass Filter Frequency Response')

figure(9)
freqz(hbp129,1,1024,'whole',fs)
title('Part 1-f. Order 128 Bandpass Filter Frequency Response')

% Part 1-g.
% Convert into two highpass filters, utilizing fhp = 4.4 kHz. Stem plot the
% FIR coefficients of the highpass filters.

hhp33 = hlp33.*cos(pi.*(n33-d33));
hhp129 = hlp129.*cos(pi.*(n129-d129));

figure(10)
subplot(2,1,1)
stem(n33,hhp33)
title('Part 1-g. Order 32 Highpass Filter Coefficients')
subplot(2,1,2)
stem(n129,hhp129)
title('Part 1-g. Order 128 Highpass Filter Coefficients')

% Part 1-h.
% Determine the frequency response of the highpass filter, and comment on
% the differences and similarities between the two filters.

figure(11)
freqz(hhp33,1,1024,'whole',fs)
title('Part 1-h. Order 32 Highpass Filter Frequency Response')

figure(12)
freqz(hhp129,1,1024,'whole',fs)
title('Part 1-h. Order 128 Highpass Filter Frequency Response')

% Part 1-i.
% Load the data from the wave4.wav file, using [x,fs] =
% audioread('wave4.wav'), and plot the frequency spectrum of the signal.

[x,fs] = audioread('wave4.wav');    % Load audio data
f = fs*(0:length(x)-1)/length(x);   % determine frequency for fft plotting.

figure(13)
plot(f,abs(fft(x)))                 % Frequency Spectrum of wave4.
title('Part 1-i. Frequency Spectrum of the Sound Signal')
xlabel('Frequency(Hz)')

% Part 1-j.
% The output of an FIR system is the impulse convolved with the input. The
% signal x is the input, with the lowpass, highpass, and bandpass signals
% the convolving function. Compute the output with the 129 term versions of
% the filters, designed using the Blackman window.

hbp129t = hbp129.';
hhp129t = hhp129.';

hbpblck129 = hbp129t.*blackman(N129);
hhpblck129 = hhp129t.*blackman(N129);

xlp = conv(hlpblck129,x); 
xbp = conv(hbpblck129,x); 
xhp = conv(hhpblck129,x);

fj = fs*(0:length(xlp)-1)/length(xlp);  %Convolved Matrices are same size.

figure(14)
plot(fj,abs(fft(xlp)))
title('Part 1-j. Convolved Lowpass Blackman Order 128 Frequency Spectra')
xlabel('Frequency(Hz)')

figure(15)
plot(fj,abs(fft(xbp)))
title('Part 1-j. Convolved Bandpass Blackman Order 128 Frequency Spectra')
xlabel('Frequency(Hz)')

figure(16)
plot(fj,abs(fft(xhp)))
title('Part 1-j. Convolved Highpass Blackman Order 128 Frequency Spectra')
xlabel('Frequency(Hz)')

%% Part 2
% With f = 20 to 20 kHz for a specific audio analog output, Ha, a
% pre-compensation FIR filter with fs = 40 000 requires an ideally flat
% frequency response.
%
% Part 2-a.
% Plot Ha versus f on a linear scale, where f = 20 to 20,000 Hz, in 
% increments of 20 Hz (in MATLAB: f=20:20:20000 ).

f = 20:20:20000;
fs = 40000;
Ha = 1.2e8*(((200+f)./(800+f))./(8000 + f))./(8000 + f);

figure(17)
plot(f,Ha);
title('Part 2-a. Linear Scale of Signal versus Frequency')
xlabel('Frequency (Hz)')
ylabel('Ha Output')

% Part 2-b.
% Plot the ideal pre-compensation filter gain Hipc(f) versus f on a linear 
% scale, where f = 20 to 20000 Hz, in increments of 20 Hz. Remember, the 
% ideal pre-compensation filter has a gain Hipc(f) = 1/Ha(f).

Hipc = Ha.^-1;

figure(18)
plot(f,Hipc)
title('Part 2-b. Ideal Pre-Compensation filter gain Hipc(f) vs. f')
xlabel('Frequency (Hz)')
ylabel('Hipc(f)')

% Part 2-c.
% Use firls() to design a 16th order FIR filter with gain Hipc for flat
% frequency response.

n = 0:16;
hpc = firls(16, f/(fs/2), Hipc);

figure(19)
hold on
stem(n,hpc,'r')
plot(n,hpc,'b')
title('Part 2-c. 16th order FIR filter with Hpc(f) gain')
ylabel('Magnitude')
xlabel('Coefficients')
xlim([0 16])
hold off

% Part 2-d.
% Determine the actual pre-compensation filter gain by using a frequency
% spectra plotting script line.

hpc_d = abs(fft(hpc,2000));
adj_freq = fs*((0:length(hpc_d)-1)/length(hpc_d));

figure(20)
plot(adj_freq,hpc_d)
title('Part 2-d. Pre-compensation filter gain')
xlabel('Frequency (Hz)')
ylabel('Gain')

% Part 2-e.
% Plot Hpc(f)Ha(f), which should be ideally 1 across all frequencies. Plot
% against frequency, from 0 to 20 kHz.

hpc_e = hpc_d(1:1000);
convolved = hpc_e.*Ha;
adj_freq2 = fs*((0:length(hpc_e)-1)/length(hpc_e));

figure(21)
plot(adj_freq2, convolved)
title('Part 2-e. Hpc(f)Ha(f) Compensation versus Frequency')
xlabel('Frequency (Hz)')
ylabel('Ha(f)Hpc(f)')

% Part 2-f,g,h.
% Redo parts (c), (d), and (e), but instead with a filter length of 65, or
% 64th order filter. Rehashes the code from those sections with N=65.

n = 0:64;
hpc64 = firls(64, f/(fs/2), Hipc);      % 2-f.

figure(22)
hold on
stem(n,hpc64,'r')
plot(n,hpc64,'b')
title('Part 2-f. 64th order FIR filter with Hpc(f) gain')
ylabel('Magnitude')
xlabel('Coefficients')
xlim([0 64])
hold off

hpc_g = abs(fft(hpc64,2000));           % 2-g.
adj_freq3 = fs*((0:length(hpc_g)-1)/length(hpc_g));

figure(23)
plot(adj_freq3,hpc_g)
title('Part 2-g. Pre-compensation filter gain')
xlabel('Frequency (Hz)')
ylabel('Gain')


hpc_h = hpc_g(1:1000);                  % 2-h.
convolved2 = hpc_h.*Ha;
adj_freq4 = fs*((0:length(hpc_h)-1)/length(hpc_h));

figure(24)
plot(adj_freq4, convolved2)
title('Part 2-h. Hpc(f)Ha(f) Compensation versus Frequency')
xlabel('Frequency (Hz)')
ylabel('Ha(f)Hpc(f)')