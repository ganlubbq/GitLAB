%% Energy Detection in Different Fading Channels
%
% Jordan R. Smith
% ECE 920 - Wireless Communication Systems
% University of New Hampshire

% NOTES: igamma returns the upper incomplete gamma function.

clc, close all, clear all;
N = 10e5;

snr_dB = 10;                    % decibels for SNR.
snr = 10.^(snr_dB./10);         % linear units.

thresh_dB = 0:1:25;                % dB threshold (X-Axis)
thresh = 10.^(thresh_dB./10);      % linear.


for i = 1:length(thresh)          % Pfa AWGN.
    A(1,i) = igamma(sqrt(pi),thresh(i)/2) / gamma(sqrt(pi));
end


