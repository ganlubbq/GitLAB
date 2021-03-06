%% Energy Detection in Different Fading Channels
%
% Jordan R. Smith
% ECE 920 - Wireless Communication Systems
% University of New Hampshire

% NOTES: igamma returns the upper incomplete gamma function.
%        check out the channel modeling and RF impairments.
%        Need to determine P(H0) and P(H1) first(?) Pe isn't Pd or Pfa.

clc, close all, clear all;
N = 1000;

K = 10;                         % K-factor.
snr_dB = 10;                    % decibels for SNR.
snr = 10.^(snr_dB./10);         % linear units.

thresh_dB = 0:1:25;                % dB threshold (X-Axis)
thresh = 10.^(thresh_dB./10);      % linear.

%% Generating the TWDP PDF.

R = 0:0.01:2;
M = size(R,2);
s2 = snr;
s = sqrt(snr);

for i = 1:M                     % a sub i components.
    a(i) = cos(pi*(i-1) / (2*M - 1) );
end

for r = 1:size(R,2)             % do M and r need the same dimensions? does r have to be X + jY?
    pdf(r) = (r/s2).*exp(-K-(r/s2)).*sum(a(r).*(0.5.*exp(a(r).*K).*besseli(0,...
        (r/s).*sqrt(2.*K.*(1-a(r)))) + 0.5.*exp(a(r).*-K).*besseli(0,...
        (r/s).*(2.*K.*(1-a(r))))));
end

figure()
plot(pdf);grid;title('TWDP PDF for K = 10 dB, \Delta = 1');