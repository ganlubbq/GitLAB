%% Video Presentation Script
% The EMD-SG method will be interpretted again, but instead by applying
% AWGN to several wavelet signals, such as Heavysine, Doppler, and Bumps.

clear all, close all, clc;

samples = 2048;
N = log2(samples);
t = 1:samples;
snr = 5;

x_doppler = wnoise('doppler',N);
x_heavysine = wnoise('heavy sine',N);

w_doppler = awgn(x_doppler,snr,'measured');
w_heavysine = awgn(x_heavysine,snr,'measured');

figure(1)
hold on
subplot(2,1,1),plot(t,x_doppler),grid,ylabel('Doppler Signal');
xlim([0 2048]);
subplot(2,1,2),plot(t,x_heavysine),grid,ylabel('Heavy Sine Signal');
xlim([0 2048]);
hold off

figure(2)
hold on
subplot(2,1,1),plot(t,w_doppler),grid,ylabel('Doppler'), xlim([0 2048]);
title(['AWGN Contaminated Signals, SNR = ' num2str(snr) 'dB']); 
subplot(2,1,2),plot(t,w_heavysine),grid,ylabel('Heavysine'),xlim([0 2048]);
hold off

%% Savitz-Golay Filtering - Doppler
% This section will apply two SG filters with size 41, 3rd order polynomial
% and process each IMF for both signals.

w_ans = emd(w_doppler);
[r,c] = size(w_ans);

sgf_1 = zeros(r,c);

% First SG Filter Block
for n=1:15
   sgf_1 = sgolayfilt(w_ans(n,1:c),3,41);
   sgf_matr1(n,1:c) = sgf_1(1:c);
end

% Second SG Filter Block
for m = 1:15
    sgf_2 = sgolayfilt(sgf_matr1(m,1:c),3,41);
    sgf_matr2(m,1:c) = sgf_2(1:c);
end

rec_dopp = sum(sgf_matr2);  %Reconsruct the signal

figure(3)
hold on
subplot(3,1,1),plot(t,x_doppler),ylabel('Original Signal'), grid;
title('Two-stage EMD-SG Filtering - Doppler'),xlim([0 2048]);

subplot(3,1,2),plot(t,w_doppler),ylabel('Contaminated Signal'),grid;
xlim([0 2048]);

subplot(3,1,3),plot(t,rec_dopp,'b',t,x_doppler,'r--'),grid,xlim([0 2048]);
ylabel('EMD-SG Reconstructed Signal');
hold off

MSE = immse(rec_dopp,x_doppler)
