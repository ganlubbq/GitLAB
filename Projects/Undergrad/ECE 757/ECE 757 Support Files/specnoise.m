% specnoise.m plot the spectrum of a noise signal
time=1;                     % length of time
Ts=1/10000;                 % time interval between samples
x=randn(1,time/Ts);         % Ts points of noise for time seconds
plotspec(x,Ts)              % call plotspec to draw spectrum
