%% Energy Detection in Different Fading Channels
%
% Jordan R. Smith
% ECE 920 - Wireless Communication Systems
% University of New Hampshire

% NOTES: igamma returns the upper incomplete gamma function.
%        check out the channel modeling and RF impairments.
%        Need to determine P(H0) and P(H1) first(?) Pe isn't Pd or Pfa.

clc, close all, clear all;
N = 10e5;

K_linear = 10^(5/10);           % 5 dB linear for K-factor.
snr_dB = 10;                    % decibels for SNR.
snr = 10.^(snr_dB./10);         % linear units.

thresh_dB = 0:1:25;                % dB threshold (X-Axis)
thresh = 10.^(thresh_dB./10);      % linear.


for i = 1:length(thresh)          % Pfa AWGN.
    A(1,i) = igamma(sqrt(pi),thresh(i)/2) / gamma(sqrt(pi));
end

awgnchan = comm.AWGNChannel;      % default is 10 dB.
ricianChan = comm.RicianChannel('KFactor',K_linear);
rayleighChan = comm.RayleighChannel;

