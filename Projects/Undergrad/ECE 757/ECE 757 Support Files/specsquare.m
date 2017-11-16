% specsquare.m plot the spectrum of a square wave
f=10;                       % "frequency" of square wave
time=2;                     % length of time
Ts=1/1000;                  % time interval between samples
t=Ts:Ts:time;               % create a time vector
x=sign(cos(2*pi*f*t));      % square wave = sign of cos wave
plotspec(x,Ts)              % call plotspec to draw spectrum
