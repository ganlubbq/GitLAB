%%
% Jordan R. Smith; ECE 714 Assignment 1, Fall 2016.
%
% Part 1 - Generate a 2 Hz Wave with 1000 samples. Reconstruct a continuous
% time function, (plot function), versus t. Calibrate to view samples from
% 0 to 1.0 seconds.

n = 0:999;      % sample points
t = 0.001*n;    % time domain
f = 2;          % 2 Hz frequency

x2 = sin(2*pi*f*t);
figure
plot(t,x2)
xlim([0 1]);
xlabel('t(seconds)');
ylabel('x2(t)');
title('Part 1 - 2 Hz Continuous Sine Wave');


%%
% Part 2 - x6(t) = sin(2*pi*f*t), where f = 6 Hz. 1000 samples are present
% per second, and the continuous time function x6(t) will be plotted. The
% time scale will be from 0 to 1.0 seconds.


f6 = 6;         % 6 Hz frequency

x6 = sin(2*pi*f6*t);
figure
plot(t,x6)
xlim([0 1]);
xlabel('t(seconds)');
ylabel('x6(t)');
title('Part 2 - 6 Hz Continuous Sine Wave');


%%
% Part 3 - Let x(t) = x2(t)+ x6(t). Plot a continuous time function, versus
% t. Calibrate to window a single second.

x = x2 + x6;

figure
plot(t,x)
xlim([0 1]);
xlabel('t(seconds)');
ylabel('x(t) = x2(t) + x6(t)');
title('Part 3 - Summation of Multiple Frequency Sine Waves');


%%
% Part 4 - x2s(n) represents 25 samples of x2(t), taken at 0.04 second
% increments (n = 0:24, t = 0.04 * n). Plot the discrete sequence,(stem
% command), versus physical time. Calibrate to window a single second. x2
% is the 2 Hz wave.

n2 = 0:24;       
t2 = 0.04*n2;

x2s = sin(2*pi*f*t2);

figure
stem(t2,x2s)
xlim([0 1]);
xlabel('t(seconds)');
ylabel('x2s(n)');
title('Part 4 - 25 discrete samples of x2(t)');


%%
% Part 5 - x6s(n) utilizes the newly assigned 25 samples, plotting discrete
% values of x6(t). Window a single second of the sampled 6 Hz Sine Wave.

x6s = sin(2*pi*f6*t2);

figure
stem(t2,x6s)
xlim([0 1]);
xlabel('t(seconds)');
ylabel('x6s(n)');
title('Part 5 - 25 discrete samples of x6(t)');


%%
% Part 6 - Plot the discrete sequence of xs(n) = x2s(n) + x6s(n). Window a
% single second, as done in previous sections of the matlab script.

xs = x2s + x6s;

figure
stem(t2, xs)
xlim([0 1]);
xlabel('t(seconds)');
ylabel('xs(n)=x2s(n) + x6s(n)');
title('Part 6 - 25 samples of a Multifrequency Summation Sine Wave');


%%
% Part 7 - Comment on the similarities and differences between plots 1, 2,
% and 3, as compared to the data in 4, 5, and 6. Take note of the first 500
% ms, and the symmetry of the final 500 ms of the window.
%
% Part 8 - x27(t) = sin(2*pi*f*t), with f = 27Hz, with 1000 samples, (n =
% 0:999, t = 0.001*n). Use the samples to create a continuous time plot.
% Calibrate to a single window.

f27 = 27;
x27 = sin(2*pi*f27*t);   %"t" contains 1000 samples.

figure
plot(t,x27)
xlim([0 1]);
xlabel('t(seconds)');
ylabel('x27(t)');
title('Part 8 - Continuous Time Plot of a 27 Hz Sine Wave');


%%
% Part 9 - Let x27s(n) represents the discrete sequence of 25 samples of
% the original continuous x27(t), taken at .04s increments, (n=0:24, t
% =0.04*n). Plot the discrete sequence using the stem command, against
% time, within a single second window.

x27s = sin(2*pi*f27*t2);    %"t2" contains the 25 samples.

figure
xlim([0 1]);
stem(t2,x27s);
xlabel('t(seconds)');
ylabel('x27s(n)');
title('Part 9 - 25 samples of a 27 Hz Sine Wave');

% Part 10 - Comment on the similarities and differences present between
% data sets in parts 8 and 9.