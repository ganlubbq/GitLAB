%% Symbol & Parameter Values

clear all;
close all;

Fs     = 8e3;  % 8 kHz
N      = 800;  % 800 samples@8 kHz = 0.1 seconds
Flow   = 160;  % Lower band-edge: 160 Hz
Fhigh  = 2000; % Upper band-edge: 2000 Hz
delayS = 7;
Ast    = 20;   % 20 dB stopband attenuation
Nfilt  = 8;    % Filter order

%% Initialization of Offline Secondary Path Modeling.
%
% Design bandpass filter to generate bandlimited impulse response

Fd = fdesign.bandpass('N,Fst1,Fst2,Ast',Nfilt,Flow,Fhigh,Ast,Fs);
Hd = design(Fd,'cheby2','FilterStructure','df2tsos',...
    'SystemObject',true);

% Filter noise to generate impulse response. The impulse response generated
% below models the secondary propogation path, from the anti-noise signal
% to the error microphone placed within the earcup of the headset.

H = step(Hd,[zeros(delayS,1); log(0.99*rand(N-delayS,1)+0.01).* ...
    sign(randn(N-delayS,1)).*exp(-0.01*(1:N-delayS)')]);
H = H/norm(H);

t = (1:N)/Fs; % timestamp

figure;
plot(t,H,'b');
xlabel('Time [sec]');
ylabel('Coefficient value');
title('True Secondary Path Impulse Response');


%% Secondary Propogation Path Estimate. The Offline Secondary Path Modeling
% program will determine the tap length prior to ANC application. The NLMS
% provides a better response than the basic LMS framework.

% 3.75 seconds of a synthetic noise generated through secondary path,
% presented as the variable Hfir.

ntrS = 30000;
s = randn(ntrS,1); % Synthetic random signal to be played
Hfir = dsp.FIRFilter('Numerator',H.');
dS = step(Hfir,s) + ... % random signal propagated through secondary path
    0.01*randn(ntrS,1); % measurement noise at the microphone

%% S(z) plant design, utilizing the NLMS algorithm for offline modeling.

M = 256; % 256 taps for secondary path filter length
muS = 0.12; % step size value for secondary path plant S(z)
hNLMS = dsp.LMSFilter('Method','Normalized LMS','StepSize',muS,...
    'Length',M);
[yS,eS,Hhat] = step(hNLMS,s,dS);

n = 1:ntrS;
figure;
plot(n,dS,n,yS,n,eS);
xlabel('Number of iterations');
ylabel('Signal value');
title('Signal Identification Using the NLMS Adaptive Filter');
legend('Desired Signal','Output Signal','Error Signal');


%% True vs. Estimated Secondary Propogation Path. The code segment below
% displays the estimation that the NLMS algorithm utilized to model the
% secondary path plant S(z). At 30 ms, the estimated and true signals have
% the same values, indicating a correct estimation.


figure;
plot(t,H,t(1:M),Hhat,t,[H(1:M)-Hhat(1:M); H(M+1:N)]);
xlabel('Time [sec]');
ylabel('Coefficient value');
title('Secondary Path Impulse Response Estimation');
legend('True','Estimated','Error');


%% Primary Propogation Path. The code segment below generates the primary
% propogation path, which will be used to model the primary transversal FIR
% plant W(z).

delayW = 15;
Flow = 100; % Lower band-edge: 200Hz
Fhigh = 1800; % Upper band-edge: 800Hz
Ast = 20; % 20dB stopband attenuation
Nfilt = 10; % Filter Order

% Design bandpass filter to generate bandlimited impulse response
Fd2 = fdesign.bandpass('N,Fst1,Fst2,Ast',Nfilt,Flow,Fhigh,Ast,Fs);
Hd2 = design(Fd2,'cheby2','FilterStructure','df2tsos',...
    'SystemObject',true);

% Filter noise to generate primary impulse response
G = step(Hd2,[zeros(delayW,1); log(0.99*rand(N-delayW,1)+0.01).*...
    sign(randn(N-delayW,1)).*exp(-0.01*(1:N-delayW)')]);
G = G/norm(G); % Normalizes primary noise signal.

figure;
plot(t,G,'b'); % Plots the simulated primary path's impulse response.
xlabel('Time [sec]');
ylabel('Coefficient value');
title('Primary Path Impulse Response');


%% Initialization of the Active Noise Control.
%
% Utilizing the filters generated within the secondary path modeling, the
% FxLMS algorithm can be utilized to perform noise control of the recently
% analyzed system.

% FIR Filter to be used to model primary propagation path
Hfir = dsp.FIRFilter('Numerator',G.');

% Filtered-X LMS adaptive filter to control the noise
L = 350; % Filter Length
muW = 0.0001; % W(z) step size
Hfx = dsp.FilteredXLMSFilter('Length',L,'StepSize',muW,...
    'SecondaryPathCoefficients',Hhat);

% Sine wave generator to synthetically create the noise
A = [.01 .01 .02 .2 .3 .4 .3 .2 .1 .07 .02 .01]; La = length(A);
F0 = 60; k = 1:La; F = F0*k;
phase = rand(1,La); % Random initial phase
Hsin = dsp.SineWave('Amplitude',A,'Frequency',F,'PhaseOffset',phase,...
    'SamplesPerFrame',512,'SampleRate',Fs);

% Audio player to play noise before and after cancellation
% Hpa = audioDeviceWriter('SampleRate',Fs);

% Spectrum analyzer to show original and attenuated noise
Hsa = dsp.SpectrumAnalyzer('SampleRate',Fs,'OverlapPercent',80,...
    'SpectralAverages',20,'PlotAsTwoSidedSpectrum',false,...
    'ShowLegend',true, ...
    'ChannelNames', {'Original noisy signal', 'Attenuated noise'});
%%
% Demonstration of Active Noise Control. The first 200 iterations have no
% noise control, demonstrating "before vs. after" application of the
% Filtered-X Least Mean Square Algorithm.
% 
% for m = 1:400
%     s = step(Hsin); % Generate sine waves with random phase
%     x = sum(s,2);   % Generate synthetic noise by adding all sine waves
%     d = step(Hfir,x) + ...  % Propagate noise through primary path
%         0.1*randn(size(x)); % Add measurement noise
%     if m <= 200
%         % No noise control for first 200 iterations
%         e = d;
%     else
%         % Enable active noise control after 200 iterations
%         xhat = x + 0.1*randn(size(x));
%         [y,e] = step(Hfx,xhat,d);
%     end
%     step(Hpa,e);     % Play noise signal
%     step(Hsa,[d,e]); % Show spectrum of original (Channel 1)
%                      % and attenuated noise (Channel 2)
% end
%   release(Hpa); % Release audio device
%   release(Hsa); % Release spectrum analyzer
