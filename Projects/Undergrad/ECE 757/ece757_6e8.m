% ece757_6e8.m: simulated sampling of a modulated wave
Ts=1/10000; time=0.05;    % sampling interval and total time
f = 100; fc=5000;         % frequencies
t=Ts:Ts:time;              % create time vector
h=cos(2*pi*fc*t);         % define impulse response
x=sin(2*pi*f*t);          % input = 100 Hz Sine Wave
w=conv(h,x);              % do convolution

figure(1)
subplot(3,1,1), plot(t,x) % and plot
subplot(3,1,2), plot(t,h)
subplot(3,1,3), plot(t,w(1:length(t)))
ylim([-0.5 0.5])
w1 = w(1:length(t));

figure(2)
plotspec(w1,Ts)

% Sampling
ss=5;                                         % take 1 in ss samples
wk=w1(1:ss:end);                              % the "sampled" sequence
ws=zeros(size(w1)); ws(1:ss:end)=wk;          % sampled waveform ws(t)

figure(3)
hold on
subplot(2,1,1)
plot(t,w1)
subplot(2,1,2)                                % plot the waveform
plot(t,ws,'r')                                % plot "sampled" wave
ylim([-0.5 0.5])
xlabel('seconds'), ylabel('amplitude')        % label the axes
hold off

figure(4)
ylim([-0.5 0.5])
plotspec(ws,Ts)

% Filtering
figure(5),plotspec(ws,Ts)         % draw spectrum of input
freqs=[0 0.2 0.21 1];
amps=[1 1 0 0];
b=firpm(100,freqs,amps);         % specify the LP filter
ylp=filter(b,1,ws);               % do the filtering
figure(6),plotspec(ylp,Ts)       % plot the output spectrum