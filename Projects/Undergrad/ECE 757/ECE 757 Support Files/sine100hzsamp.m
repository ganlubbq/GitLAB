% sine100hzsamp.m: simulated sampling of the 100 Hz sine wave
f=100; time=0.05; Ts=1/10000; t=Ts:Ts:time;   % freq and time vectors
w=sin(2*pi*f*t);                              % create sine wave w(t)
ss=10;                                        % take 1 in ss samples
wk=w(1:ss:end);                               % the "sampled" sequence
ws=zeros(size(w)); ws(1:ss:end)=wk;           % sampled waveform ws(t)
plot(t,w)                                     % plot the waveform
hold on, plot(t,ws,'r'), hold off             % plot "sampled" wave
xlabel('seconds'), ylabel('amplitude')        % label the axes
