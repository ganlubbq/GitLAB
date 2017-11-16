% sine100hz.m generate 100 Hz sine wave with sampling rate fs=1/Ts
f=100;                       % frequency of wave
time=0.1;                    % total time in seconds
Ts=1/10000;                  % sampling interval
t=Ts:Ts:time;                % define a "time" vector
w=sin(2*pi*f*t);             % define the sine wave
plot(t,w)                    % plot the sine vs. time
xlabel('seconds')
ylabel('amplitude')          % label the axes
