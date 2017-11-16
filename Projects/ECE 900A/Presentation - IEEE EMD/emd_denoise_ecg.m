%% Video Presentation Script
% This will provide the ECG Signal and display how EMD denoises
% the ECG signal for more clarity. For video presentation Week 2.
% Open application in ~/Documents/MATLAB, and add "emd.m" to the path.

clear all, close all, clc;

snr = 2;

load(fullfile(matlabroot,'examples','signal','ecgSignals.mat'));
t = 1:length(ecgl);
dt_ecgl = detrend(ecgl);    % removes the linear trend.

ans = emd(dt_ecgl);         % Applies EMD algorithm.
[r,c] = size(ans);          %IMF number indicated by "r."

rec_ans = sum(ans);

awgn_dt_ecgl = awgn(dt_ecgl,snr,'measured');    % 10 SNR of AWGN.
w_ans = emd(awgn_dt_ecgl);                     % EMD-AWGN-ECG Application.

%% Savitz Golay Filtering
% This section will apply a single SG-FIR filter to each of the IMF's, and
% hopefully detrend the signal as expected.
sgf_matr = zeros(r,c);

% Applies an SG-Filter to each IMF.
for n = 1:15
    sgf_n = sgolayfilt(w_ans(n,1:c),3,41);
    sgf_matr(n,1:c)= sgf_n(1:c);
end

% Run the IMF's through a SECOND SG-Filter with the same parameters.
for m = 1:15
    sgf_2 = sgolayfilt(sgf_matr(m,1:c),3,41);
    sgf_matr_2(m,1:c) = sgf_2(1:c);
end

rec_sgf_w_ans = sum(sgf_matr_2);  % reconstruct the entire signal.

figure(4)
hold on
subplot(3,1,1),plot(t,dt_ecgl),grid;
title('Original ECG Signal'),xlabel('Time'),ylabel('Amplitude');
subplot(3,1,2),plot(t,awgn_dt_ecgl),grid;
title('Noise Contaminated ECG Signal'),xlabel('Time'),ylabel('Amplitude');
subplot(3,1,3),plot(t,rec_sgf_w_ans),grid;
title('Reconstructed EMD-SG Signal'),xlabel('Time'),ylabel('Amplitude');
hold off

%% Plot the findings.
% Plot for the AWGN, The Reconstructed Signal, and the
% reconstructed Gaussian white noise.

% Original Signal and AWGN Signal
hold on
figure(1)
subplot(2,1,1),plot(t,dt_ecgl,'r'),grid,ylim([-2 2]);
xlabel('Sample (n)'),ylabel('Amplitude'),title('Original ECG Signal');
subplot(2,1,2),plot(t,awgn_dt_ecgl,'b'),grid,ylim([-2 2]);
xlabel('Sample (n)'),ylabel('Amplitude');
title(['ECG Signal Contaminated with AWGN = ', num2str(snr) ,'dB']);
hold off


% Original Signal, IMF Iterations
figure(2)
hold on
for n=1:6
    subplot(7,1,n)
    plot(ans(n,1:c)');
    title(['IMF Iteration (',num2str(n),')']);
end
hold off

%Original Signal vs. Reconstructed IMF Sum
figure(3)
hold on
subplot(2,1,1),plot(t,dt_ecgl),grid;
title('Original ECG Signal'),xlabel('Sample (n)'),ylabel('Amplitude');
ylim([-2 2]);
subplot(2,1,2),plot(t,rec_ans),grid;
title('Reconstructed ECG Signal By Summing IMFs'),xlabel('Sample (n)');
ylabel('Amplitude'),ylim([-2 2]);
hold off

MSE = immse(dt_ecgl,rec_sgf_w_ans');