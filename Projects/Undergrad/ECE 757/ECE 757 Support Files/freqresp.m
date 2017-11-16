% freqresp.m: numerical example of impulse and frequency respose
Ts=1/100; time=10;             % sampling interval and total time
t=0:Ts:time;                   % create time vector
h=exp(-t);                     % define impulse response
plotspec(h,Ts)                 % find and plot frequency response


% to see that sinc -> lpf use
%h=sinc(10*(t-time/2));
% sin -> LPF use
%h=sin(25*t);
