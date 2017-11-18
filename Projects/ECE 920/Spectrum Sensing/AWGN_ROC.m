% This code is to plot receiver operating characteristic curve for simple energy
% detection, when the primary signal is real Gaussian signal and noise is
% addive white real Gaussian. Here, the threshold is available
% analytically.
% Code written by: Sanket Kalamkar, Indian Institute of Technology Kanpur,
% India.


clc
close all
clear all
L = 1000;
snr_dB = -10; % SNR in decibels
snr = 10.^(snr_dB./10); % Linear Value of SNR
Pf = 0.01:0.01:1; % Pf = Probability of False Alarm
%% Simulation to plot Probability of Detection (Pd) vs. Probability of False Alarm (Pf) 
for m = 1:length(Pf)
    m
    i = 0;
for kk=1:10000 % Number of Monte Carlo Simulations
 n = randn(1,L); %AWGN noise with mean 0 and variance 1
 s = sqrt(snr).*randn(1,L); % Real valued Gaussina Primary User Signal 
 y = s + n; % Received signal at SU
 energy = abs(y).^2; % Energy of received signal over N samples
 energy_fin =(1/L).*sum(energy); % Test Statistic for the energy detection
 thresh(m) = (qfuncinv(Pf(m))./sqrt(L))+ 1; % Theoretical value of Threshold, refer, Sensing Throughput Tradeoff in Cognitive Radio, Y. C. Liang
 if(energy_fin >= thresh(m))  % Check whether the received energy is greater than threshold, if so, increment Pd (Probability of detection) counter by 1
     i = i+1;
 end
end
Pd(m) = i/kk; 
end
plot(Pf, Pd)
hold on
%% Theroretical ecpression of Probability of Detection; refer above reference.
thresh = (qfuncinv(Pf)./sqrt(L))+ 1;
Pd_the = qfunc(((thresh - (snr + 1)).*sqrt(L))./(sqrt(2).*(snr + 1)));
plot(Pf, Pd_the, 'r')
hold on