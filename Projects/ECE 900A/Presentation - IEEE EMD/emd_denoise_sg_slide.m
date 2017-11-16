%% Savitzky-Golay Slide Presentation
% Displays a signal contaminated with noise, and applies the SG-filter to
% demonstrate signal denoising.

n = 0:1999;         % samples
t = 0.0005 * n;     % Time Axis
f1 = 31;            % First Frequency Component
f2 = 7;             % Second Frequency Component
snr = 5;            % AWGN SNR dB strength

x_sine = sin(2*pi*f1*t) + sin(2*pi*f2*t);   % Original Sinusoid
w_sine = awgn(x_sine,snr,'measured');       % Sinusoid with Additive Noise.

sgf_1 = sgolayfilt(w_sine,3,41);    %3rd order, Window Size = 41.

figure(1)
hold on
subplot(2,1,1),plot(t,w_sine),grid;
title(['Sine Wave with AWGN SNR = ', num2str(snr), ' dB']);

subplot(2,1,2),plot(t,sgf_1,'b',t,x_sine,'r--'),grid;
legend('SG-Filter','Original Signal');
title('Sine Wave, Post SG-filtering');
xlabel('3rd Order Polynomial, Window Size = 41');
hold off