% Jordan R. Smith
% ECE 757 - Fundamentals of Communication Systems
% 14 October 2016
% Exam 1 - MATLAB Addendum Problem
%
%
% Consider a symmetric (polar), periodic triangle waveform of fundamental
% frequency fo with peak amplitude 2.
%
% (a)   Calculate the Fourier Coefficients, leaving the frequency as fo.
%
% (b)   Use SpecSquare.m to compute the spectrum of the triangle wave where
%           fo = 10, 40, 120, and 300 Hz. Ts = 1/1000 & t = 2 sec. Plot
%           against log10, in dB, of the magnitude squared to include all
%           spectral values. What anomalies pop up in the Matlab code?
%           (Unexpected Features).
%
% (c)   Compare the generated spectra and the findings from part (a). What
%           needs to be adjusted to gain the expected spectrum from the DFT
%           array generated from SpecSquare.m? (Look at raw DFT, not the
%           logarithmically scaled powered values for the dB figure.)
%
% (d)   How does the spectra change from part (b) if the time is reduced?
%           Check t = 1, and t = 0.3. (Periodic --> Finite Window.)
% (e)   With the 40 Hz Triangle wave of t = 1, if its zero padded to create
%           a new duration of 2 seconds, compute the DFT and compare the
%           two spectra.


% Part B - E
%
% Uses Software Receiver Design Support Files. Creates a triangle wave
% utilizing the sawtooth command with 0.5 width as suggested.

f10 = 10;                             % Frequency Declaration.
f40 = 40;
f120 = 120;
f300 = 300;

time = 2;                                  % Time Vector.
time_1 = 1;
time_3 = 0.3;                              % Part (d) time correction
Ts = 1/1000;
t = Ts:Ts:time;
t_1 = Ts:Ts:time_1;                        % Reduced time vector. Part (d)
t_3 = Ts:Ts:time_3;

tri1 = 2*sawtooth(2*pi*t, 0.5);            % Triangle Wave Functions.
tri10 = 2*sawtooth(2*pi*f10*t,0.5);   
tri40 = 2*sawtooth(2*pi*f40*t,0.5);
tri120 = 2*sawtooth(2*pi*f120*t,0.5);
tri300 = 2*sawtooth(2*pi*300*t,0.5);

tri40_1 = 2*sawtooth(2*pi*f40*t_1,0.5);    % Part (e) & Part (d).
tri40_3 = 2*sawtooth(2*pi*f40*t_3,0.5);

figure(1)
plotspectrum(tri10,Ts)
title('10 Hz Power-scaled Spectrum')  % Modifies the 3rd subplot title.

figure(2)                             % Part (b)
plotspectrum(tri40,Ts)
title('40 Hz Power-scaled Spectrum')

figure(3)
plotspectrum(tri120,Ts)
title('120 Hz Power-scaled Spectrum')

figure(4)
plotspectrum(tri300,Ts)
title('300 Hz Power-scaled Spectrum')

figure(5)                             % Part (d)
plotspectrum(tri40_1,Ts)
title('40 Hz time=1 Power-scaled Spectrum')

figure(6)
plotspectrum(tri40_3,Ts)
title('40 Hz time=0.3 Power-scaled Spectrum')

tri40_1z = tri40;                     % Part (e) - time vector of t=2.
tri40_1z(1001:2000)=0;

figure(7)
plotspectrum(tri40_1z,Ts)
title('40 Hz Zero-padded Power-scaled Spectrum')


