% specsquare.m plot the spectrum of a square wave
f=20;                       % "frequency" of square wave
time=10;                     % length of time
Ts=1/10000;                  % time interval between samples
t=Ts:Ts:time;               % create a time vector
x=sign(cos(2*pi*f*t));      % square wave = sign of cos wave
plotspec(x,Ts)              % call plotspec to draw spectrum

