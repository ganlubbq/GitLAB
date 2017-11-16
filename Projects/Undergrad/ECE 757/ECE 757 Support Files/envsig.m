% envsig.m: "envelope" of a bandpass signal
time=.33; Ts=1/10000;                          % sampling interval and time
t=0:Ts:time; lent=length(t);                   % define a "time" vector
fc=1000; c=cos(2*pi*fc*t);                     % define signal as fast wave
fm=10; w=cos(2*pi*fm*t).*exp(-5*t)+0.5;        % times slow decaying wave
x=c.*w;                                        % with offset
fbe=[0 0.05 0.1 1]; damps=[1 1 0 0]; fl=100;   % low pass filter design
b=firpm(fl,fbe,damps);                         % impulse response of LPF
envx=(pi/2)*filter(b,1,abs(x));                % find envelope full rectify

% draw wave and envelope
subplot(2,1,1)
plot(t(20:end-20),x(20:end-20),'y')
hold on
plot(t(20:end-20),envx(20:end-20),'k')
ylabel('(a) amplitude')
xlabel('time')
hold off
subplot(2,1,2)
plot(t(20:end-20),x(20:end-20),'y')
hold on
plot(t(20:end-20-fl/2),envx(20+fl/2:end-20),'k')
ylabel('(b) amplitude')
xlabel('time')
hold off
% using complex envelope
envx=abs(filtfilt(b,1,2*x.*exp(2*j*pi*fc*t)));  % find complex envelope

% can also find envelope using
xc=filtfilt(b,1,2*x.*cos(2*pi*fc*t));       % in-phase component
xs=filtfilt(b,1,2*x.*sin(2*pi*fc*t));       % quadrature component
envx=abs(xc+xs);                            % envelope of signal

% can use simpler method of taking absolute value (rectification)
envv=(pi/2)*filtfilt(b,1,abs(x));           % find envelope

% or use half wave rectification
y=x; ind=find(x<0);                         % do half wave rectification
y(ind)=zeros(size(ind));
envx=pi*filtfilt(b,1,y);                    % and find envelope

% can also use hilbert transform
y=hilbert(x);                       % take hilbert transform
envx=abs(y);                        % magnitude gives envelope
