%% Part 1
% Jordan R. Smith
% ECE 714 - Assignment #2
% September 23, 2016
%
% Part 1 - a.
% Consider a discrete sequence x50d(n). Plot the discrete sequence versus
% t. f = 50 Hz, N = 100, fs = 1000.

clear all; close all;

fs = 1000;      % time steps per second
n = 0:99;       % 100 samples
f = 50;         % 50 Hz continuous
t = (1/fs)*n;     % time axis
figure
x50d = sin(2*pi*f*n/fs);
stem(t,x50d)
title('Part 1-a. 100 discrete samples of a 50 Hz Sine Wave');
ylabel('x50d(n)')
xlabel('t(seconds)')

% Part 1 - b.
% Plot the absolute value of the fast fourier transform of x50d(n). This
% will provide the magnitude spectrum of the discrete time sequence.
% Because the function is discrete, plot the magnitude as a sampled output
% as well.

figure
f1 = (0:99)*1000/100;       % frequency axis adjustment
stem(f1,abs(fft(x50d)))     % discrete magnitude spectrum
title('Part 1-b. Discrete Magnitude Spectrum of x50d(n)');
ylabel('|x50D(F)|');
xlabel('f(frequency)');

% Part 1 - c.
% The frequency domain effects of data sampling can be observed by
% downsampling the discrete time signal. If every other value of x50d(n) is
% set to zero, the signal will appear to be a 50 Hz wave sampled at fs=500
% instead of fs = 1000.

s(1:100) = 0;           % Every other value is equal to 0.
s(1:2:100) = 1;         % Each alternating value is 1, starting with s=2.
x50ds2 = x50d.*s;       % This creates x50d, with every other value 0.

figure
stem(t,x50ds2)
title('Part 1-c. Downsampled x50d(n) signal, with fs = 500')
ylabel('x50ds2(n)');
xlabel('t(seconds)');

% Part 1 - d.
% Plot the magnitude spectrum of the downsampled signal, and using the same
% modified frequency axis vector utilized in part B.

figure
stem(f1,abs(fft(x50ds2)))
title('Part 1-d. Magnitude Spectrum of Downsample fs = 500')
ylabel('|x50dS2(F)|');
xlabel('f(frequency)');

% Part 1 - e
% Making 3 of every 4 values 0, the downsampled signal will now have an fs
% = 250. A similar process to Part d, a vector consisting of 1's and 0's
% will be multiplied with the original sampled signal to form a new
% downsampled vector.

s2(1:100) = 0;
s2(1:4:100) = 1;
x50ds4 = x50d.*s2;

figure
stem(t,x50ds4);
title('Part 1-e. Downsampled Signal with fs = 250');
xlabel('t(seconds)');
ylabel('x50ds4');

% Part 1 - f
% Plot the Magnitude Spectrum of the downsampled signal of fs=250. The
% frequency axis still utilizes the f1, with the frequency scale extending
% from 0 to 990 Hz, despite the lowered sampling rate.

figure
stem(f1,abs(fft(x50ds4)))
title('Part 1-f. Downsampled fs = 250 Magnitude Spectrum');
xlabel('f(frequency)');
ylabel('|X50DS4(F)|');

%% Part 2
% Repeat parts a through f with a 200Hz sine wave.

f2 = 200;   % 200 Hz Sine Wave
x200d = sin(2*pi*f2*n/fs);

figure      % Part 2-a
stem(t,x200d)
title('Part 2-a. 100 discrete samples of a 200 Hz Sine Wave')
ylabel('x200d(n)')
xlabel('t(seconds)')

figure      % Part 2-b
stem(f1,abs(fft(x200d)))
title('Part 2-b. Discrete Magnitude Spectrum of x200d(n)');
ylabel('|x200D(F)|');
xlabel('f(frequency)');

x200ds2 = x200d.*s;     % Part 2-c
figure
stem(t,x200ds2)
title('Part 2-c. Downsampled x200d(n) signal, with fs = 500')
ylabel('x200ds2(n)');
xlabel('t(seconds)');

figure                  % Part 2-d
stem(f1,abs(fft(x200ds2)))
title('Part 2-d. Magnitude Spectrum of Downsample fs = 500')
ylabel('|x200dS2(F)|');
xlabel('f(frequency)');

x200ds4 = x200d.*s2;    % Part 2-e
figure
stem(t,x200ds4);
title('Part 2-e. Downsampled Signal with fs = 250');
xlabel('t(seconds)');
ylabel('x200ds4');

figure                  % Part 2-f
stem(f1,abs(fft(x200ds4)))
title('Part 2-f. Downsampled fs = 250 Magnitude Spectrum');
xlabel('f(frequency)');
ylabel('|X200DS4(F)|');

%% Part 3
% Repeat Repeat parts a-f for the discrete time signal xd(n), where
% xd(n) = x50d(n)+(0.5*x200d(n)). Repeat all of the plots and discussions
% from parts a-f for this new signal.

xd = x50d + (0.5*x200d);    % New summation signal

figure                      % Part 3-a
stem(t,xd)
title('Part 3-a. 100 discrete samples of a Modified Sine Wave')
ylabel('xd(n)')
xlabel('t(seconds)')

figure                      % Part 3-b
stem(f1,abs(fft(xd)))
title('Part 3-b. Discrete Magnitude Spectrum of xd(n)');
ylabel('|xD(F)|');
xlabel('f(frequency)');

xds2 = xd.*s;               % Part 3-c
figure
stem(t,xds2)
title('Part 3-c. Downsampled xd(n) signal, with fs = 500')
ylabel('xds2(n)');
xlabel('t(seconds)');

figure                      % Part 3-d
stem(f1,abs(fft(xds2)))
title('Part 3-d. Magnitude Spectrum of xd(n) Downsample fs = 500')
ylabel('|xdS2(F)|');
xlabel('f(frequency)');

xds4 = xd.*s2;              % Part 3-e
figure
stem(t,xds4);
title('Part 3-e. Downsampled Signal xd(n) with fs = 250');
xlabel('t(seconds)');
ylabel('xds4(n)');

figure                      % Part 3-f
stem(f1,abs(fft(xds4)))
title('Part 3-f. Downsampled fs = 250 xd(n) Magnitude Spectrum');
xlabel('f(frequency)');
ylabel('|XDS4(F)|');