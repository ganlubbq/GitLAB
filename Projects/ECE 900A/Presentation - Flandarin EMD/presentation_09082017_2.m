%% Introduction
%
% This presentation is more suited for covering lowpass, bandpass, and high
% pass filters, utilizing the ECG Signal from the previous attempt. The
% layout should be such that it introduces signal denoising and its
% importance, displays a signal with an SNR of 10 dB (completely
% distorted), and asking how to go about denoising the signal.
%
% Introduce the lowpass filter, show its Bode plot and circuitry, show that
% it can remove the high frequency noise. Show that it can't remove noise
% that is within the lowpass region, then show the highpass filter.
% Question that noise can be across multiple frequencies, and a more
% complicated filter may be required. Show the SG filter, and indicate that
% parameters need to be set - a more "adaptive" tool is needed. Introduce
% EMD, and without getting too technical, show that it can be used for
% denoising.

close all, clear all, clc;

f1 = 23;        %sinusoid component 1
f2 = 97;        %sinusoid component 2
Fs = 2000;      %sampling frequency
fch = 720;      %highpass cutoff
fcl = 690;
L = 2000;       %Length of signal
order = 8;      %filter order
snr = -4;      %AWGN SNR

%% ECG Signal & Sinusoid Setup

load(fullfile(matlabroot,'examples','signal','ecgSignals.mat'));
clear ecgnl;
ecg = detrend(ecgl);
t_ecg = 1:length(ecg);

T = 1/Fs;           % Time
t = (0:L-1) * T;    % Time vector

y = sin(2*pi*f1*t) + sin(2*pi*f2*t);

figure(1)
plot(t,y);grid;
title(['Sinusoid with ',num2str(f1),' and ',num2str(f2),' Hz Components']);
xlabel('Time (t)');
ylabel('Amplitude');
close 1;

%% Generic Filter Graphs

tel1 = fir1(80,0.3,kaiser(81,8));
figure(7),freqz(tel1,1),ylim([-80 20]);
title('Lowpass Filter')

tel2 = fir1(80,0.7,'high',kaiser(81,8));
figure(8),freqz(tel2,1),ylim([-80 20]);
title('Highpass Filter')

tel3 = fir1(80,[0.3 0.7],'bandpass',kaiser(81,8));
figure(9),freqz(tel3,1),title('Bandpass Filter'),ylim([-80 20]);


%% High Frequency Noise - LPF Application
%
% Create high frequency noise, pass the vector through a highpass filter to
% isolate the range of frequencies it exists at, and add it to the ECG
% signal. For demonstration, apply the lowpass filter, and show that the
% noise can be removed. Make the point that there's still noise, and
% a more complex tool could be useful,(proceed to SG slide.)

noise = randn(1,L);                         %randomized noise.
[b,a] = butter(order,fch/(Fs/2),'high');    %highpass

hpf_noise = filter(b,a,noise);              %isolate freq. range of noise
hpf_noise = hpf_noise.';                    %correct orientation

noise_ecg = hpf_noise + ecg;                %combine the two signals.
figure(2),plot(t_ecg,noise_ecg);            %plot
grid;title('High Frequency Noise Contaminated ECG Signal');

[c,d] = butter(order,fcl/(Fs/2),'low');     %lowpass
filtered_ecg = filter(c,d,noise_ecg);       %filter to remove spec. noise.

figure(3),plot(t_ecg,filtered_ecg);         %plot
grid;title('ECG Signal with Lowpass Filter Application');
xlabel('Sample (n)');

figure(4)
subplot(2,1,1),plot(t_ecg,noise_ecg),grid;
title('ECG Signal with High Frequency Noise');ylim([-2 2]);
subplot(2,1,2),plot(t_ecg,filtered_ecg),grid;
title('ECG Signal With Lowpass Filter Application');ylim([-1 1]);

%% Savitzky-Golay Filter
%
% Show that this can show the trends of an ECG much more readily, but the
% noise level is across multiple frequencies. Use AWGN on the ECG signal.
% White noise provides a consistent noise across multiple frequencies, if
% unexpected/unknown noise sources were interferring, a simple LPF/HPF
% wouldn't work!

awgn_ecg = awgn(ecg,snr,'measured');
sg_ecg = sgolayfilt(awgn_ecg,3,41);

figure(5)
subplot(2,1,1),plot(t_ecg,awgn_ecg),grid;
title(['ECG Signal with AWGN SNR = ',num2str(snr),' dB']);
ylim([-1.2 1.2]);
subplot(2,1,2),plot(t_ecg,sg_ecg),grid;
title('Additive White Noise Contaminated ECG Signal with SG-Filtering');
ylim([-1.2 1.2])

%% EMD Application
%
% Utilizing Flandrin's EMD code, remove the first IMF and see how it
% reconstructs.

IMF = emd(awgn_ecg);
[r,c] = size(IMF);

for n=1:3   %clear the first 3 IMF's
    IMF(n,1:c)=0;
end

rec_emd_ecg = sum(IMF);     %partial reconstruction.

figure(6)
subplot(2,1,1),plot(t_ecg,awgn_ecg),grid;
title(['ECG Signal with AWGN SNR = ',num2str(snr),' dB']);
ylim([-1.2 1.2]);
subplot(2,1,2),plot(t_ecg,rec_emd_ecg),grid;
title('Reconstructed ECG Signal With First 3 IMFs Discarded');
ylim([-1.2 1.2])

%% EMD-SG Application
%
% Apply the EMD-SG recombination to the additive white gaussian noise ECG
% signal. Reconstruct and compare.

for m=1:r
   sgf_1 = sgolayfilt(IMF(m,1:c),3,41);
   sgf_matr(m,1:c) = sgf_1(1:c);
end

for j=1:3
   sgf_matr(j,1:c) = 0;     % discarding IMF's. 
end

rec_emd_sg = sum(sgf_matr);

figure(10)
subplot(2,1,1),plot(t_ecg,awgn_ecg),grid;
title(['ECG Signal with AWGN SNR = ',num2str(snr),' dB']);
ylim([-1.2 1.2]);
subplot(2,1,2),plot(t_ecg,rec_emd_sg),grid;
title('Reconstructed ECG Signal after EMD-SG Filtering');
ylim([-1.2 1.2]);