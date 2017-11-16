%% Part 1
%
% Jordan Smith
% ECE 714 - Digital Signal Processing
% Assignment #6 - Decimation & Interpolation
% November 22, 2016
%
% In this assignment, downsampling, (decimation), and upsampling,
% (interpolation), will be assessed. The speech file has a sample rate of
% 32000 samples per second. The initial import, without any up or down
% sampling, will be named x32. The raw speech file is 86,756 data points.
% Using the sound function, the audio file can be listened to.

[x32 fs] = audioread('speech6.wav');
sound(x32,fs);

%% Part 2
%
% The speech signal should be displayed against the time axis in seconds, 
% with the vertical axis scaled to -1.2 and 1.2. Using this normalization
% in seconds will be important for cross reference amongst several graphs
% with the same time scaling.

t=(0:length(x32)-1)/fs;     % time axis

figure(1)
plot(t,x32)
ylim([-1.2 1.2])
xlim([0 2.8])
xlabel('Time(seconds)');
ylabel('x32(t)');
title('Part 2 - x32 Time Signal');
pause(2);

%% Part 3
%
% Plot the normalized magnitude of the estimated frequency spectrum from 0
% to fs of x32. Use a linear scale for magnitude, and the spectrum ought to
% be calibrated to Hz.

f = fs*(0:length(x32)-1)/length(x32);
normx32 = abs(fft(x32))/length(x32);

figure(2)
plot(f,normx32);
xlim([0 fs]);
xlabel('Frequency(Hz) 0 to f_{s}')
ylabel('|x32(f)|')
title('Part 3 - Normalized Frequency Spectrum')

%% Part 4
%
% In this section, the signal is downsampled by a factor of 4. This is done
% by selecting every 4th value present within the x32 vector. Because of
% the downsampling, the sample rate is now 32000/4 = 8000 samples/sec. Play
% the audio as well, noting how it sounds.

x32d8 = x32(1:4:length(x32));
fsd8 = 8000;
pause(2);
sound(x32d8,8000)
pause(2);

%% Part 5
%
% Plot the downsampled signal against the time axis, calibrated in seconds
% specific to the lowered quality signal.

td8 = (0:length(x32d8)-1)/8000;     % time calibrated to downsampled freq.

figure(3)
plot(td8, x32d8)
ylim([-1.2 1.2])
xlim([0 2.8])
xlabel('Time(seconds)')
ylabel('x32d8(t)')
title('Part 5 - Downsampled M = 4 Time Signal')

%% Part 6
%
% Plot the normalized magnitude of the estimated frequency spectrum from 0
% to fs of x32d8. Use a linear scale for magnitude, and the spectrum ought 
% to be calibrated to Hz.

fd8 = fsd8*(0:length(x32d8)-1)/length(x32d8);
normfd8 = abs(fft(x32d8))/length(x32d8);


figure(4)
plot(fd8,normfd8)
xlim([0 fsd8]);
ylim([0 0.01])
xlabel('Frequency(Hz) 0 to f_{s} Downsampled by M = 4')
ylabel('|x32d8(f)|')
title('Part 6 - Normalized Frequency Spectrum of Downsampled M = 4 Signal')

%% Part 7
%
% Part 4 did not include an anti-aliasing filter. x32 needs to pass through
% a lowpass filter with cutoff frequency w = pi/4. This is a cutoff
% frequency of 4000 Hz, and then downsample the filtered sequency by M = 4.

B = fir1(64, 1/4);

figure(5)
stem(B)
title('Part 7 - 64^{th} Order Anti-aliasing FIR Filter \omega = \pi/4')
xlabel('Coefficients')
ylabel('Coefficient Magnitude')
xlim([0 65]);
ylim([-0.10 0.32])

%% Part 8
%
% Plot the frequency response of the FIR Filter from Part 7 using the
% freqz() command.

figure(6)
freqz(B,1,'whole')
title('Part 8 - FIR Filter Frequency Response')

%% Part 9
%
% Create the signal x32f by filtering x32 with the filter created by Part
% 7. Use the Matlab filter() command to accomplish this. Also use sound()
% to determine the effects of the anti-aliasing filter.

x32f = filter(B,1,x32);

pause(2);
sound(x32f,32000);
pause(2);

%% Part 10
%
% Plot the normalized magnitude of the estimated frequency spectrum from 0
% to fs for x32f. Use a linear scale for magnitude, and the spectrum ought 
% to be calibrated to Hz.

x32f_f = fs*(0:length(x32f)-1)/length(x32f);
normx32f = abs(fft(x32f))/length(x32f);


figure(7)
plot(x32f_f,normx32f);
xlabel('Frequency(Hz) 0 to f_{s}')
ylabel('|x32f(f)|')
xlim([0 fs])
ylim([0 0.01])
title('Part 10- Normalized Frequency Spectrum of the Filtered x32f Signal')

%% Part 11
%
% Down-sample x32f by a factor of 4 to create x32fd8 (similar to step 4). 
% Play the waveform again using sound(). Remember that the sampling rate 
% for x32fd8 is 32000/4 = 8000 samples per second. How does this sound 
% relative to the original audio signal?

x32fd8 = x32f(1:4:length(x32f));

pause(2);
sound(x32fd8,8000);
pause(2);

%% Part 12
%
% Plot the entire signal x32fd8 as a function of time. The time axis 
% should be calibrated in seconds. Remember that the sampling rate for 
% x32fd8 is 32000/4 = 8000 samples per second. The magnitude axis should 
% be adjusted to the range -1.2 to 1.2. It is important to use this scaling 
% for direct visual comparison of waveforms throughout this assignment. 

tfd8 = (0:length(x32fd8)-1)/fsd8;

figure(8)
plot(tfd8,x32fd8)
xlabel('time(seconds)');
ylabel('x32fd8(t)');
axis([0 2.8 -1.2 1.2]);
title('Part 12 - Filtered Downsampled x32fd8 Time Signal')

%% Part 13
%
% Plot the normalized magnitude of the estimated frequency spectrum of the 
% signal x32fd8 over the range 0 to fs. Remember that the sampling rate for 
% x32fd8 is 32000/4 = 8000 samples per second. Use a linear scale for 
% magnitude (the standard plot() function). The frequency axis should be 
% calibrated in Hz.

x32fd8_f = fsd8*(0:length(x32fd8)-1)/length(x32fd8);
normx32fd8 = abs(fft(x32fd8))/length(x32fd8);


figure(9)
plot(x32fd8_f,normx32fd8)
xlim([0 fsd8])
ylim([0 0.01])
xlabel('Frequency(Hz) 0 to f_{s}')
ylabel('|x32fsd8(f)|')
title('Part 13 - Normalized Frequency Spectrum of the Filtered Downsampled Signal')

%% Part 14
%
% This section upsamples the downsampled signal, being defined as
% x32df8u32. Matlab will insert the necessary zeroes in the main line of 
% code below. By upsampling, the sampling frequency returns to 32000. This
% should hopefully sound like the original signal, but some data loss
% may've occurred by decimating the signal and interpolating afterwards.

x32fd8u32(4*(1:length(x32fd8)))=x32fd8(1:length(x32fd8));

pause(2);
sound(x32fd8u32,32000)
pause(2);

%% Part 15
%
% Plot the upsampled signal in the time domain, with the x-axis
% corresponding to seconds. Remember that the sampling frequency is 32000
% again.

td8u32 = (0:length(x32fd8u32)-1)/fs;

figure(10)
plot(td8u32,x32fd8u32);
ylim([-1.2 1.2])
xlim([0 2.8])
title('Part 15 - Upsampled Time Signal')
xlabel('Time(seconds)')
ylabel('x32fd8u32(t)')

%% Part 16
%
% Plot the normalized magnitude of the estimated frequency spectrum of the 
% signal x32fd8u32 over the range 0 to fs. fs = 32000. Linear scaling of
% magnitude.

fd8u32 = fs*(0:length(x32fd8u32)-1)/length(x32fd8u32);
normx32fd8u32 = abs(fft(x32fd8u32))/length(x32fd8u32);

figure(11)
plot(fd8u32,normx32fd8u32);
xlim([0 fs])
ylim([0 0.01])
title('Part 16 - Normalized Frequency Spectrum of the Upsampled Signal')
xlabel('Frequency(Hz) 0 to f_{s}');
ylabel('|x32fd8u32(f)|');

%% Part 17
%
% A lowpass filter is required once again to remove the spectral images
% present within the upsampled signal. Using the filter established in part
% 7, the spectrum's unwanted components can be filtered out.

x32fd8u32f_mag = filter(B,1,x32fd8u32);     % Filtering Operation
x32fd8u32f = 4.*x32fd8u32f_mag;             % Gain Correction

pause(2);
sound(x32fd8u32f,32000);
pause(2);

%% Part 18
%
% Plot the filtered upsampled signal versus time, with the x-axis
% calibrated to seconds. The sampling rate remains at 32000.

tfd8u32f = (0:length(x32fd8u32f)-1)/fs;

figure(12)
plot(tfd8u32f,x32fd8u32f)
title('Part 18 - Filtered Upsampled Time Signal')
xlabel('Time(Seconds)')
ylabel('x32fd8u32f(t)')
axis([0 2.8 -1.2 1.2])

%% Part 19
%
% Plot the normalized magnitude of the estimated frequency spectrum of the
% filtered upsampled signal from 0 to fs. fs = 32000. Linear scaling of
% magnitude.

x32fd8u32f_f = fs*(0:length(x32fd8u32f)-1)/length(x32fd8u32f);
normx32fd8u32f = abs(fft(x32fd8u32f))/length(x32fd8u32f);


figure(13)
plot(x32fd8u32f_f,normx32fd8u32f)
xlim([0 fs])
title('Part 19 - Normalized Frequency Spectrum of the Filtered Upsampled Signal')
xlabel('Frequency(Hz) 0 to f_{s}')
ylabel('|x32fd8u32f(f)|')
