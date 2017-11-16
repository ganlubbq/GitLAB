%% LMS Peformance.
% Utilizes the LMS filter in the DSP toolbox; the step size is 0.01, with a
% low coefficient size FIR filter.

lms1 = dsp.LMSFilter(11,'StepSize',0.01);
filt = dsp.FIRFilter; % System to be identified
filt.Numerator = fir1(10,.25);
x = randn(1000,1); % input signal

d = filt(x) + 0.01*randn(1000,1); % desired signal - white noise.
[y,e,w] = lms1(x,d);

figure(1)
subplot(2,1,1);
plot(1:1000, [d,y,e]);
title('LMS Performance');
legend('Desired', 'Output', 'Error');
xlabel('time index');
ylabel('signal value');
subplot(2,1,2);
stem([filt.Numerator.',w]);
legend('Actual','Estimated');
xlabel('coefficient #');
ylabel('coefficient value');
grid on;

%% RLS Performance
% Utilizes the built in RLS algorithm and the FIR filter command, with a
% forgetting factor of 0.98. This was found to be a suitable value, similar
% to the Leaky term from the Fx-NLMS algorithm in several IEEE
% transactions.

rls1 = dsp.RLSFilter(11,'ForgettingFactor', 0.98);
filt2 = dsp.FIRFilter('Numerator',fir1(10,0.25));
x2 = randn(1000,1);
d2 = filt2(x2) + 0.01*randn(1000,1);

[y2,e2] = rls1(x2,d2);

w2 = rls1.Coefficients;

figure(2)
subplot(2,1,1), plot(1:1000, [d2,y2,e2]);
title('RLS Performance');
legend('Desired', 'Output', 'Error');
xlabel('time index'); ylabel('signal value');
subplot(2,1,2); stem([filt.Numerator; w2].');
legend('Actual','Estimated');
xlabel('coefficient #'); ylabel('coefficient value');
grid on;

figure(3)
subplot(3,1,1), plot(1:1000, [d,y,e]);
title('LMS Performance');
legend('Desired', 'Output', 'Error');
xlabel('time index'); ylabel('Signal Value');
xlim([0 600]); grid on;

subplot(3,1,3), plot(1:1000, [d2,y2,e2]);
title('RLS Performance');
legend('Desired','Output','Error');
xlabel('time index'); ylabel('Signal Value');
xlim([0 600]); grid on;

%% Filtered-X LMS Performance.
% The system indicates the original signal, and after FxLMS filtering,
% the signal after being attenuated by the output of the filter is
% displayed. FuRLS would provide the same operation, while utilizing the
% RLS architecture instead of LMS.

x3  = randn(1000,1);
g3  = fir1(47,0.4);
n3  = 0.1*randn(1000,1);
d3  = filter(g3,1,x3) + n3;
b3  = fir1(31,0.5);

mu = 0.008;
fxlms = dsp.FilteredXLMSFilter(32, 'StepSize', mu, 'LeakageFactor', ...
     1, 'SecondaryPathCoefficients', b3);
[y3,e3] = fxlms(x3,d3);

subplot(3,1,2);
plot(1:1000,d3,1:1000,e3);
title('Filtered-X LMS Performance');
legend('Original Signal','Attenuated Result');
xlabel('Time Index'); ylabel('Signal Value'); grid on;
xlim([0 600]);
ylim([-2 2]);
print('LMS_performance','-depsc');