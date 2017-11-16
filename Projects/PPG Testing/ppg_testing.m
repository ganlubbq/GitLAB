%% ppg_testing.m
%
% Similarly utilizes [1]. To compute the RIFV, separate into intervals,
% apply a hamming window, with a slider increment of 1s. 1 second is equal
% to approximately 300 samples. With a window size of 15, 1:4500 becomes
% 301:4800, and continually increments.

clear all, close all, clc;

S = load('0009_8min.mat');  % load the .MAT file
ppg = S.signal.pleth.y.';   % PPG
ecg = S.signal.ecg.y.';     % ECG
co2 = S.signal.co2.y.';     % Breathing Rate

Tsize = 4500;               % 15 second window size.
dt = 300;                   % increments of 1 second.
n = 1;                      % indicate what multiple of 15s to look at.

t1 = n*Tsize - (n*Tsize - 1);   % lower limit.
t2 = n*Tsize;                   % upper limit.
fH = 10;                    % upper frequency limit for window.
Fs = 300;                   % sampling frequency
T = 1/Fs;                   % sampling period
L = Tsize;                  % length of signal
t = (0:L-1)*T;              % time axis

ppg_frac = ppg(1,t1:t2);    % windowing.
ecg_frac = ecg(1,t1:t2);
co2_frac = co2(1,t1:t2);

%% FIR Filtering
%
% Create an Equiripple FIR filter with 10 Hz cutoff and check to see if any
% notable artifacts are removed with a simple linear approach.

Hd = fdesign.lowpass('Fp,Fst,Ap,Ast',7,10,1,60,Fs); % filter design
d = design(Hd,'equiripple');                        % filter object
fvtool(d)

ppg_filtered = filter(d,ppg_frac);                  % filtering operation

figure(9)
subplot(2,1,1)
plot(ppg_frac);grid;title('Original PPG Signal');
subplot(2,1,2)
plot(ppg_filtered);grid;title('FIR Filtered PPG');

fft_plot(ppg_frac,10,'Fractional PPG');
fft_plot(ppg_filtered,11,'Filtered PPG');

%% FFT with Hamming Window.

dim = 2;                    % row by column dimension
h = hamming(L);             % n-point hamming window
h = h.';                    % transpose
hppg = ppg_frac .* h;       % convolve with hamming window
n = 2^nextpow2(L);          % zero padding for FFT
Y = fft(hppg,n,dim);        % FFT application.
P2 = abs(Y/n);              % Double/single sided Spectrums.
P1 = P2(:,1:n/2+1);
P1(:,2:end-1) = 2*P1(:,2:end-1);

figure(1)
plot(0:(Fs/n):(Fs/2-Fs/n),P1(1,1:n/2)),grid;
title('Hamming Windowed PPG Interval FFT');
xlabel('Frequency (Hz)');
ylabel('|Y(f)|');
xlim([0 fH]);               %limit FFT frequency-range

figure(2)
subplot(3,1,1)
plot(t,ppg_frac);grid;xlabel('Time(s)');title('Windowed PPG Interval');
subplot(3,1,2)
plot(h);grid;xlabel('Sample(n)');
title(['Hamming Window, L = ',num2str(L),'']);
subplot(3,1,3)
plot(t,hppg);grid;xlabel('Time(s)');
title('Hamming Window Convolved PPG Interval');

%% Spectrogram Application
%
% The first section provided what an atypical single window would look
% like, time to split the 8 minute signal into 15-second intervals with
% hamming or hanning window application to see if the breathing rate is
% centralized in terms of frequency range.
% 
% Nx = length(ppg);
% ns = 32;
% ov = 0.5;
% nsc = floor(Nx/ns);
% lsc = floor(Nx/(ns-(ns-1)*ov));
% nff = max(512,2^nextpow2(nsc));
% 
% figure(3)
% spectrogram(ppg,lsc,floor(ov*lsc),nff,'yaxis');ylim([0 0.04]);

%% Evelope Formation & Experimentation
%

[ppg_upper ppg_lower] = envelope(ppg_frac,20,'peak');

figure(5)
plot(t,ppg_upper,t,ppg_lower,t,ppg_frac);grid;title('Envelope of PPG');

for i=1:size(ppg_frac,2)
   meanUp(1,i) = (ppg_upper(1,i) + ppg_lower(1,i)) / 2; 
end

figure(6)
plot(t,ppg_upper,t,ppg_lower,t,ppg_frac,t,meanUp);grid;title('Mean Signal');

%% IEEE Results
% This will display the RIFV, RIAV, and RIIV.

SFx = S.SFresults.x;            % Results from IEEE paper.
RIFV = S.SFresults.RIFV.y;
RIAV = S.SFresults.RIAV.y;
RIIV = S.SFresults.RIIV.y;

figure(4)
subplot(3,1,1);plot(SFx,RIFV);grid;ylabel('RIFV');
subplot(3,1,2);plot(SFx,RIAV);grid;ylabel('RIAV');
subplot(3,1,3);plot(SFx,RIIV);grid;ylabel('RIIV');

%% FFT Plot Function
%
% arguments indicate the input stream and the figure number.

function fft_plot(X,fig_num,fig_name)

Fs = 300;               % PPG Data Fs.
L = size(X,2);          % ROW-ORIENTED Data
n = 2^nextpow2(L);      % zero-padding
Y = fft(X,n);           % FFT.
P2 = abs(Y/n);          % Double sided
P1 = P2(:,1:n/2+1);     % Show one side of FFT.
P1(:,2:end-1) = 2*P1(:,2:end-1);

figure(fig_num)
plot(0:(Fs/n):(Fs/2-Fs/n),P1(1,1:n/2)),grid;
title(['FFT ', fig_name, '']);
xlabel('Frequency(Hz)');

end