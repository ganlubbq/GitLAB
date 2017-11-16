%% Load Files
%   presentation_09082017.m
%   Jordan Smith
%   September 08, 2017
%   ECE 900A - R&D Concept to Communication I
%
% This code will analyze the ECG Signal loaded from the Matlab root folder.
% The detrend command removes the linear trend, providing a linear ECG
% signal. Differing SNR values will be applied and recorded.
% This code utilizes Patrick Flandrin's EMD.m script.

clear all, close all, clc

% Matlab's Example ECG Signals
load(fullfile(matlabroot,'examples','signal','ecgSignals.mat'));
clear ecgnl;
SNR = -2               % SNR value for AWGN

%% ECG Signal

y = detrend(ecgl)';     % Linearize ECG Signal
t = 1:length(y);        % Time Axis declaration

noise_y = awgn(y,SNR,'measured');

figure(1)
subplot(2,1,1)
plot(t,y),grid,xlabel('Sample (n)'),ylabel('Amplitude');
title('ECG Signal'),ylim([-1.5 1.5]);

subplot(2,1,2)
plot(t,noise_y),grid,xlabel('Sample (n)'),ylabel('Amplitude');
title(['ECG With Noise SNR = ', num2str(SNR),' dB']);
ylim([-1.5 1.5])

%% EMD/EMD-SG Application

IMF = emd(noise_y);     % Flandarin's function
[r,c] = size(IMF);      % size values for figure plotting

for k = 1:r             % SG-Filter applied to each IMF
    sgf_1 = sgolayfilt(IMF(k,1:c),3,41);
    sgf_matr1(k,1:c) = sgf_1(1:c);
end

rec_y = sum(sgf_matr1); % Reconstruction with filtered IMF's



%% EMD-SG Plots & Comparison
figure(2)
plot(t,noise_y),grid,xlabel('Sample (n)'),ylabel('Amplitude');
title('Noise Contaminated ECG Signal'),ylim([-1.5 1.5]);
ylabel(['AWGN SNR = ', num2str(SNR), ' dB']);

figure(3)               % Plots the first 5 IMF's.
for n = 1:5
    subplot(5,1,n);
    plot(IMF(n,(1:c))');grid;
    ylabel(['IMF (',num2str(n),')']);
end

%figure(4)
%for m = 1:5             % Plots final 5 IMF's - mindful of plot space.
%    j = m + 5;
%    subplot(5,1,m);
%    plot(IMF(j,(1:c))');grid;
%    ylabel(['IMF (',num2str(j),')'])
%end

figure(5)
subplot(2,1,1);plot(t,noise_y),grid,ylim([-1.5 1.5]);
title('Input Signal With Noise');
ylabel(['AWGN SNR = ', num2str(SNR), ' dB']); xlabel('Samples (n)');
subplot(2,1,2);plot(t,rec_y),grid,ylim([-1.5 1.5]);
title('Reconstructed EMD-SG Signal');
xlabel('Samples (n)');ylabel('Amplitude');

% Mean Squared Error / Root Mean Squared Error

MSE = immse(y, rec_y);
emd_RMSE = sqrt(MSE)

%% Wavelet Denoising
%
% The level of decomposition in [4] is 2, and the threshold value is 0.2.
% The process then, for denoising, is DWT, applying the thresholding, and
% then performing an inverse DWT. the output can then be compared to
% RMSE/MSE of the EMD-SG method.
% 'db4' threshold = 0.2, two scales of decomposition.

thr = 0.2;
ythard = wthresh(noise_y,'h',thr);

% Parameters for wavelet filter provided in [4].
dwt_y = wden(noise_y,'sqtwolog','h','sln',3,'db4');

dwt_MSE = immse(y,dwt_y);
dwt_RMSE = sqrt(dwt_MSE)

%% MSE Analysis, EMD-SG VS. DWT
%
% Data points collected from MSE reading in previous section. Need to find
% Monte Carlo Analysis tool, and determine best DWT to apply to
% contaminated ECG signal. Values presnt are from running several times.

snr_axis = [-5 -4 -3 -2 -1 0 1 2 3 4 5];
emd_rmse_val = [0.1104, 0.104, 0.0971, 0.0928, 0.0844, 0.0807, 0.0760, ...
   0.0754, 0.0715, 0.0718, 0.0708];

dwt_rmse_val = [0.1389, 0.123, 0.1192, 0.1056, 0.1002, 0.0859, 0.0806,...
  0.0807, 0.0739, 0.0714, 0.0642];    
figure(6)
hold on
plot(snr_axis, emd_rmse_val,'-bs');plot(snr_axis,dwt_rmse_val,'-rd');grid;
title('Root Mean Square Error VS. Additive Signal Noise SNR')
xlabel('Additve White Gaussian Noise SNR (dB)')
ylabel('RMSE')
legend('EMD-SG Filtering RMSE','Wavelet Thresholding RMSE')
hold off

%% EMD Introduction Slide Set with Test Data
%
% The previous values ought to be cleared - with this section, the first 5
% IMF's are presented by utilizing the EMD algorithm on the test data
% loaded in Matlab's rootfiles.


load leleccum;          % test data on energy consumption
imf = emd(leleccum);    % EMD application.

[r,c] = size(imf);      % plotting variables.

figure(7)
plot(leleccum);grid;xlabel('Sample (n)');ylabel('Amplitude');
title('MATLAB Test Data of Energy Consumption');

figure(8)
hold on
for n = 1:5
    subplot(5,1,n)
    plot(imf(n,1:c)'),grid;
    ylabel(['IMF',num2str(n),''])
    if n == 1
        title('Intrinsic Mode Functions of Test Data');
    end
end
hold off

figure(9)
hold on
for m = 1:5
    j = m+5;
    subplot(5,1,m)
    plot(imf(j,1:c)'),grid;
    ylabel(['IMF',num2str(j),''])
end
hold off

% RMSE can be applied for identical signal confirmation.
rec_signal = sum(imf);

figure(10)
subplot(2,1,1),plot(leleccum),title('Original Signal'),grid;
subplot(2,1,2),plot(rec_signal),title('Reconstructed Signal'),grid;