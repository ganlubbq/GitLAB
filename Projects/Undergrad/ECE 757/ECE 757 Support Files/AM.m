% AM.m suppressed carrier AM with freq and phase offset
time=0.3; Ts=1/10000;               % sampling interval & time
t=Ts:Ts:time; lent=length(t);       % define a time vector
fm=20; fc=1000; c=cos(2*pi*fc*t);   % carrier at freq fc
w=5/lent*(1:lent)+cos(2*pi*fm*t);   % create "message"
v=c.*w;                             % modulate with carrier
gam=0; phi=0;                       % freq & phase offset
c2=cos(2*pi*(fc+gam)*t+phi);        % create cosine for demod
x=v.*c2;                            % demod received signal
fbe=[0 0.1 0.2 1]; damps=[1 1 0 0]; % LPF design
fl=100; b=firpm(fl,fbe,damps);      % impulse response of LPF
m=2*filter(b,1,x);                  % LPF the demodulated signal

% used to plot figure
subplot(4,1,1), plot(t,w)
axis([0,0.1, -1,3])
ylabel('amplitude'); title('(a) message signal');
subplot(4,1,2), plot(t,v)
axis([0,0.1, -2.5,2.5])
ylabel('amplitude'); title('(b) message after modulation');
subplot(4,1,3), plot(t,x)
axis([0,0.1, -1,3])
ylabel('amplitude');
title('(c) demodulated signal');
subplot(4,1,4), plot(t,m)
axis([0,0.1, -1,3])
ylabel('amplitude'); title('(d) recovered message is a LPF applied to (c)');

