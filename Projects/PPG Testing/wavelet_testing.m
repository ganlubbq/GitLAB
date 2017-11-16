%% Wavelet_testing.m
%
% Utilizes [1], and applies wavelet transformations. Script will be used to
% learn more about wavelet decomposition in biosignal processing.
%
% 8 minute data, 300 Hz sampling.

clear all, close all, clc;

%% Load Values

S = load('0103_8min.mat');          % load signal.
ppg = S.signal.pleth.y';            % PPG
ecg = S.signal.ecg.y';              % ECG
co2 = S.signal.co2.y';              % Oxygen percentage

Tsize = 4500;                       % Bin size (15 seconds)
dt = 300;                           % sample offset betw. bins
n = 1;                              % Bin multiple

t1 = n*Tsize - (Tsize - 1);         % lower limit (1).
t2 = n*Tsize;                       % upper limit

Fs = 300;                           % sampling frequency
T = 1/Fs;                           % sample spacing
L = Tsize;                          % vector size
t = (0:L-1)*T;                      % time axis

ppg_frac = ppg(1,t1:t2);            % PPG window
ecg_frac = ecg(1,t1:t2);            % ECG Window
co2_frac = co2(1,t1:t2);            % C02 window

figure(1)
subplot(3,1,1)
plot(t,ecg_frac);grid;title('Biosignals From 0103_ 8min.mat')
ylabel('ECG');
subplot(3,1,2)
plot(t,ppg_frac);grid;ylabel('PPG');
subplot(3,1,3)
plot(t,co2_frac);grid;ylabel('CO_2');

%% Wavelet Generation
%
% wavelet decomposition at level 5, with a Daubechies-4 Mother wavlet.


[phi,psi,xval] = wavefun('db4',10);         % 10-sample mother wavelet

[c_w,l_w] = wavedec(ecg_frac,5,'db4');      % level 5 decomposition

[cd1,cd2,cd3,cd4,cd5] = detcoef(c_w,l_w,[1 2 3 4 5]);   % coefficients

figure(2)
subplot(3,2,1)
plot(cd1);grid;title('Level 1 Detail Coefficients (cd1)');
subplot(3,2,2)
plot(cd2);grid;title('Level 2 Detail Coefficients (cd2)');
subplot(3,2,3)
plot(cd3);grid;title('Level 3 Detail Coefficients (cd3)');
subplot(3,2,4)
plot(cd4);grid;title('Level 4 Detail Coefficients (cd4)');
subplot(3,2,5)
plot(cd5);grid;title('Level 5 Detail Coefficients (cd5)');
subplot(3,2,6)
plot(xval,psi);grid;title('Daubechies-4 Mother Wavelet');

%% Wavelet-FFT
%
% produces the FFT for each wavelet decomposition level.

function wavelet_fft(coeff,fig_num)

L = size(coeff,2);                              % Size of columns
n = 2^nextpow2(L);                              % power of 2
Fs = 300;                                       % 300 Hz
T = 1/Fs;                                       % sample spacing
t = (0:L-1)*T;                                  % time axis
dim = 2;                                        % column orientation FFT
Y = fft(coeff,n,dim);                           % FFT
P2 = abs(Y/n);                                  % normalized FFT
P1 = P2(:,1:n/2+1);                             % single-sided power
P1(:,2:end-1) = 2*P1(:,2:end-1);                % limit matrices content

figure(fig_num)
plot(0:(Fs/n):(Fs/2-Fs/n),P1(1,1:n/2));grid;    % plot the single-sided FFT
title('Wavelet FFT');

end