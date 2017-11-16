f = 1;
time = 2;
Ts = 1/1000;
t = Ts:Ts:time;

plot(2*sawtooth(pi*f*t, 0.5))