t = [-1 + 1/1000:1/1000:1];
x1 = 0.6*tripuls(t,2);
x2 = 0.1*sin(10*2*pi*t);
x = x1+x2 + 0.2;

tt = 1:2000;
figure;

%% Plot
subplot(3,2,1);
plot (x)
title '1) Original signal'

%% Plot extrema
[indmin, indmax, ~] = extr(x);

subplot(3,2,2);
plot (tt,x,...
    indmin, x(indmin), 'ro',...
    indmax, x(indmax), 'ro' );

title '2) Extrema detection'




%% Plot envelopes

envmin = spline(indmin, x(indmin), 1:numel(x));
envmax = spline(indmax, x(indmax), 1:numel(x));
envmean = (envmin + envmax) / 2;

subplot(3,2,3);
plot (tt,x,...
    ...%indmin, x(indmin), 'ro',...
    ...%indmax, x(indmax), 'ro',...
    tt, envmax, 'm',...
    tt, envmin, 'm');

title '3) Envelope interpolation'

subplot(3,2,4);
plot (tt,x,...
    ...%indmin, x(indmin), 'ro',...
    ...%indmax, x(indmax), 'ro',...
    tt,envmean, 'm' );

title '4) Trend estimation'

subplot(3,1,3);
plot(tt,x-envmean,tt,envmean)
legend('High frequency wave','Carrier wave');
title '5) Extract oscillating mode'
