%% Rayleigh_PDF.m
%
% Simulates a Rayleigh Fading channel, from GaussianWaves.

clear all, close all, clc

%% Input Section

N=1e6;              % Number of samples to generate
variance = 0.2;     % Variance of underlying Gaussian random variables

%% Rayleigh Construction

% Independent Gaussian random variables with zero mean and unit variance

x = randn(1,N);
y = randn(1,N);

% Rayleigh fading  envelope with desired variance

r = sqrt(variance*(x.^2 + y.^2));

% Define bin steps and range for histogram plotting

step = 0.1; range = 0:step:3;

% Get histogram values and approximate to get PDF curve.

h = hist(r, range);
approxPDF = h/(step*sum(h));    % Simulate PDF from the X and Y samples.

% Theoretical PDF from the Rayleigh Fading Equation
theoretical = (range/variance).*exp(-range.^2/(2*variance));

figure(1)
plot(range,approxPDF,'b--o',range,theoretical,'r-.');
title('Simulated and Theoretical Rayleigh PDF for \sigma = 0.2')
legend('Simulated PDF','Theoretical PDF');
xlabel('r--->');
ylabel('P(r)--->');
grid;

%% PDF of Rayleigh Envelope Phase

theta = atan(y./x);

figure(2)
hist(theta);    % Plot histogram of the phase part

% Approximate the histogram of the phase part to a PDF curve.

[counts,range] = hist(theta,100);

step=range(2)-range(1);

% Simulate PDF from the X and Y Samples.
approxPDF = counts/(step*sum(counts));

bar(range,approxPDF,'b');
hold on
plotHandle=plot(range,approxPDF,'r');
set(plotHandle,'LineWidth',3.5);
axis([-2 2 0 max(approxPDF)+0.2])
hold off
title('Simulated PDF of Phase of Rayleigh Distribution');
xlabel('\theta --->');
ylabel('P(\theta)--->');
grid;