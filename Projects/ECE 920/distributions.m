%% Distributions.m
%
% Jordan R. Smith
% ECE 920 - Wireless Communication Systems
%
% Do Rappaport problems 5.25 and 5.26 in the text. The program has a later
% due date, on October 18th.

clear all, close all, clc;

%% Rappaport 5.25
%
% Plot the probability density function and the CDF for a Ricean
% distribution having a
%   (a) K = 10 dB
%   (b) K =  3 dB
% The abscissa of the CDF plot should be labeled in dB relative to the
% median signal level for both plots. Note the median value for a Ricean
% distribution changes as the K-value changes.


t = 0:0.01:10;                  % linspace for plotting.

K10_dB = 10;                    % 10 dB case.
K3_dB = 3;                      % 3 dB case.

K10_linear = 10^(10/10);        % linear units.
K3_linear = 10^(3/10);

% maintaining sigma level at unity. specific to PDF reference x-axis of
% sigma multiples.

sigma3 = 1;
sigma10 = sigma3;

A3 = sqrt(2*K3_linear*((sigma3)^2));
A10 = sqrt(2*K10_linear*((sigma10)^2));

% now, maintaining the peak amplitude parameter (CDF calculations).

A3_constant = 1;
A10_constant = A3_constant;
A6_constant = A10_constant;

sigma3_A = sqrt( ( (A3_constant)^2) / (2 * K3_linear) );
sigma10_A = sqrt( ( (A10_constant)^2) / (2 * K10_linear) );

% Utilizing the Matlab toolbox, generate a Rician Distribution Object with
% parameters s and sigma, where s is the "A' parameter denoting the peak
% amplitude of the dominant signal. With a unity sigma, the PDF will
% provide a consistent probability distribution matching Fig. 5.18 in the
% text.

pd3 = makedist('Rician','s',A3,'sigma',sigma3);
pd10 = makedist('Rician','s',A10,'sigma',sigma10);

cd3 = makedist('Rician','s',A3_constant,'sigma',sigma3_A);
cd10 = makedist('Rician','s',A10_constant,'sigma',sigma10_A);

pdf3 = pdf(pd3,t);              % PDF generation.
pdf10 = pdf(pd10,t);


% Calculate the CDF. Notably, the second argument must be a function of the
% median of the distribution calculated according to each K value. The
% formula being 20*log10(r / rmedian). 20 is used for the case of signal
% voltage, with A being the signal amplitude.

m3 = median(cd3);               % median calculation for each K-value.
m10 = median(cd10);

t2 = linspace(-30,10,1000);     % decibel axis for CDF.
t3 = m3 .* 10.^(t2/20);         % linear units from K=3 median.
t10 = m10 .* 10.^(t2/20);       % linear units from K=10 median.


cdf3 = cdf(cd3,t3);             % CDF generation.
cdf10 = cdf(cd10,t10);

figure(1)
plot(t,pdf3,'r-.',t,pdf10,'b-');grid;
legend('K = 3 dB','K = 10 dB');
legend('Location','NorthEast');
title('Probability Density Function');
xlabel('Received Signal Envelope Voltage (\sigma volts)');
ylabel('p(r)');

figure(2)
plot(t2,100*cdf3,'r-.',t2,100*cdf10,'b-'); grid;
xlim([-30 10]);
legend('K = 3 dB','K = 10 dB');
legend('Location','SouthEast');
title('Cumulative Distribution Function');
xlabel('Signal Level (dB from median level)');
ylabel('% Probability Signal Level < Abscissa');


%% Rappaport 5.26
%
% Based on your answer in problem 5.25, if the median RSSI is -70 dBm, what
% is the likelihood that asignal greater than -80 dBm will be receieved in
% a Ricean fading channel having (a) K = 10 dB and (b) K = 3 dB?

figure(3)
semilogy(t2,100.*cdf3,'r-.',t2,100.*cdf10,'b-'); grid;
xlim([-30 10]);ylim([0.001 100])
legend('K = 3 dB','K = 10 dB');
legend('Location','SouthEast');
title('Logarithmic Cumulative Distribution Function');
xlabel('Signal Level (dB from median level)');
ylabel('% Probability Signal Level < Abscissa');