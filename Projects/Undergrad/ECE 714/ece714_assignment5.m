%% Part 1
% Jordan Smith
% ECE 714 - Digital Signal Processing
% Assignment #5 - IIR Filter Implementation
% November 4, 2016
%
% The IIR filter is a 4th order Band reject filter with stopbands between w
% =0.4*pi and w2 = 0.6*pi. The frequency range should include 0 to 2*pi,
% using the axis adjustment provided in the assignment. A has the
% coefficients of the denominator and B has numerator coefficients.
%
% To scale the frequency axis, use f = fs*(0:length(x)-1)/length(x), and
% plot(f,abs(fft(x))). For a time axis of an input signal, such as the .wav
% file included, t = (0:length(x)-1)/fs; plot(t,x), with [x,fs]=audioread()

clc
clear all; close all;

[B A] = butter(2,[0.4 0.6],'stop');     % Filter Coefficients

figure(1)
zplane(B,A)
title('Part 1 - Poles & Zeroes of H(z)')

%% Part 2
%
% Compute the filter frequency response of H(w), which is H(z) where z =
% e^-jw. The term z^-2 becomes exp(-j*2*w) when interpreting. For w, the
% frequency is assessed from 0 to 2*pi across 1024 points.

w = linspace(0, 2*pi, 1024);

den = exp(-j*w*0).*A(1) + exp(-j*w*1).*A(2) + exp(-j*w*2).*A(3) +...
    exp(-j*w*3).*A(4) + exp(-j*w*4).*A(5);

num = exp(-j*w*0).*B(1) + exp(-j*w*1).*B(2) + exp(-j*w*2).*B(3) +...
    exp(-j*w*3).*B(4) + exp(-j*w*4).*B(5);

Hw = num./den;
mag = abs(Hw);  % magnitude of the frequency response

figure(2)
plot(w,mag)     % output versus the normalized 1024 point frequency
axis([0 2*pi 0 1.2]);
title('Part 2 - Filter H(\omega) 1024-Point Frequency Response')
ylabel('|H(\omega)|')
xlabel('Frequency (\omega = 0 to 2\pi)')

%% Part 3
%
% Write code that will compute y(n) from any discrete time input x(n),
% where the length of the computed sequence y(n) is the same length of the
% input sequence x(n). All initial I/O states are assumed to be zero.

[x3,fs] = audioread('speech5.wav'); % signal and sampling rate import
N = length(x3);                     % discrete time length of input signal
x = x3.';                           % transpose Matrix
t = (0:length(x)-1)/fs;             % time axis
y = 0:length(x)-1;                  % establishes matrix length of input
y(1:length(x)) = 0;                 % fills vector with zero (init. cond.)

for n=5:length(x);                  % starts at n=5 to prevent neg. index

    y(n) = (1/A(1)).*(B(1).*x(n) + B(2).*x(n-1) + B(3).*x(n-2) + ...
        B(4).*x(n-3) + B(5).*x(n-4) - A(2).*y(n-1) - A(3).*y(n-2) - ...
        A(4).*y(n-3) - A(5).*y(n-4));
    
end

%% Part 4
%
% Generate d(n) with amplitude 1 at N=0, and N=1:1023 are all valued at
% amplitude zero. x(n) = d(n), and y(n) = h(n), utilizing the filter
% established in Part 3.
%
% Approximating this response would be with a 29th order FIR filter, that
% matches the output h[n]. Due to the filter's asymetrical shape, the
% filter exhibits a nonlinear phase resposne.

d(1:1024) = 0;                      % zero-padded points for d(n)
d(5) = 1;                           % discrete time impulse function
h(1:length(d)) = 0;                 % output vector initialization

for n2 = 5:1024;
    
     h(n2) = (1/A(1)).*(B(1).*d(n2) + B(2).*d(n2-1) + B(3).*d(n2-2) + ...
         B(4).*d(n2-3) + B(5).*d(n2-4) - A(2).*h(n2-1) - A(3).*h(n2-2) -...
         A(4).*h(n2-3) - A(5).*h(n2-4));
    
end

figure(3)
stem(h);
xlim([0 30]);
xlabel('Discrete Time Impulse d(n)')
ylabel('Impulse Response h(n)')
title('Part 4 - Time Impulse Response of IIR Filter')

%% Part 5
%
% We know that the filter's frequency response H(w) = DTFT{h(n)}, so 
% compute 1024 samples of H(w),  using the 1024- point DFT{h(n)}. Plot the 
% magnitude of H(w) versus w scaled as described above. Compare this to 
% the results from part 2.


figure(4)
plot(w,abs(fft(h)));
axis([0 2*pi 0 1.2]);
title('Part 5 - 1024-point H(\omega) Impulse Response');
xlabel('Frequency \omega = 0 to 2\pi');
ylabel('|H(\omega)|');

%% Part 6
%
% Utilizing the speech file, apply the filter and name the input variable
% x. The sampling rate is fixed at 2000 samples/sec. In part 3, the audio
% file was imported, and the signal was properly filtered, and processed as
% the variable y. A majority of this portion is already written in Part 3.

[x2,fs] = audioread('speech5.wav'); % signal and sampling rate import
N2 = length(x2);                    % discrete time length of input signal
x6 = x2.';                          % transpose Matrix
t6 = (0:length(x6)-1)/fs;           % time axis
y6 = 0:length(x6)-1;                % establishes matrix length of input
y6(1:length(x6)) = 0;               % fills vector with zero (init. cond.)

for n6 = 5:length(x6);

    y6(n6) = (1/A(1)).*(B(1).*x6(n6) + B(2).*x6(n6-1) + B(3).*x6(n6-2)+ ...
        B(4).*x6(n6-3) + B(5).*x6(n6-4) - A(2).*y6(n6-1)-A(3).*y6(n6-2)- ...
        A(4).*y6(n6-3) - A(5).*y6(n6-4));

end

%% Part 7
%
% Plot the entire signal x as a function of time. The time axis should be 
% calibrated in seconds.  The magnitude axis should be adjusted to the 
% range -1.2 to 1.2.

figure(5)
plot(t,x);
ylim([-1.2 1.2]);
xlim([0 2.6]);
xlabel('Time (seconds)')
ylabel('x[n]')
title('Part 7 - Time Function of the Speech File')

%% Part 8
%
% Plot the estimated frequency spectrum of the signal x over the range 0 
% to fs, following MATLAB help item 6 above. Make sure to use the plot( ) 
% function and to scale it as described above. The frequency axis should 
% be calibrated in Hz (as shown in MATLAB help item 6). Label the axes 
% correctly, etc.

f = fs*(0:length(x)-1)/length(x); 

figure(6)
plot(f,abs(fft(x)));
axis([0 fs 0 200]);
xlabel('Frequency(Hz) 0 to f_{S} = 20,000');
ylabel('|X(f)|');
title('Part 8 - Input Signal Estimated Frequency Spectrum')

%% Part 9
%
% Re-plot the filter response from Part 2, but scaled to the physical
% frequency f, rather than the normalized frequency "w", using the value of
% fs from the sound signal x, scaling the axis from 0 to fs and 0 to 1.2.


f9 = fs*(0:length(Hw)-1)/length(Hw);
figure(7)
plot(f9,abs(Hw));
axis([0 fs 0 1.2]);
title('Part 9 - Filter Response across Physical Frequency');
ylabel('|H(f)|');
xlabel('Frequency(Hz)');

%% Part 10
%
% Use your MATLAB filtering code from step 3 to compute the signal y, the 
% filter's response to the input signal x from part 6. Play the audio 
% waveform signal y using sound(). How does it sound compared to the sound 
% quality in part 6?

pause(2);           % Incorporates a pause after generating figures
sound(x,fs);        % Original Input signal
pause(3);           % Delay between input signal and output signal
sound(y,fs);        % Output of IIR filtered speech file

%% Part 11
%
% Plot the entire output signal as a function of time. The time axis should
% be calibrated in seconds, and the magnitude of the vertical axis should
% span -1.2 to 1.2.

figure(8)
plot(t,y);
ylim([-1.2 1.2]);
xlim([0 2.6]);
xlabel('Time (s)');
ylabel('y[n]');
title('Part 11 - Output Speech File Post IIR Filtering versus Time')

%% Part 12
%
% Plot the estimated frequency spectrum of the signal y over the range 0 to
% fs, following MATLAB help item 6. Make sure to use the plot( ) function 
% and to scale it as described in the assignment. The frequency axis 
% should be calibrated in Hz (as shown in MATLAB help item 6).

f12 = fs*(0:length(y)-1)/length(y);
mag12 = abs(fft(y));

figure(9)
plot(f12,mag12);
title('Part 12 - Estimated Frequency Spectrum of IIR Filtered Output');
xlabel('Frequency (Hz)');
ylabel('|Y(f)|');
axis([0 fs 0 200]);