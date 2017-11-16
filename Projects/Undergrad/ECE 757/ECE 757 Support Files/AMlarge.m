% AMlarge.m: large carrier AM demodulated with "envelope"
time=0.33; Ts=1/10000;              % sampling interval & time
t=0:Ts:time; lent=length(t);        % define a time vector
fm=20; fc=1000; c=cos(2*pi*fc*t);   % define carrier at freq fc
w=10/lent*[1:lent]+cos(2*pi*fm*t);  % create "message" > -1
v=c.*w+c;                           % modulate w/ large carrier
fbe=[0 0.05 0.1 1];                 % LPF design
damps=[1 1 0 0]; fl=100; 
b=firpm(fl,fbe,damps);              % impulse response of LPF
envv=(pi/2)*filter(b,1,abs(v));     % find envelope

% generate the figure
figure(1)
subplot(4,1,1), plot(t,w)
ylabel('amplitude'); title('(a) message signal');
axis([0,0.08, -1,4])
subplot(4,1,2), plot(t,c)
ylabel('amplitude'); title('(b) carrier');
axis([0,0.08, -1.5,1.5])
subplot(4,1,3), plot(t,v)
ylabel('amplitude'); title('(c) modulated signal');
axis([0,0.08, -3,4])
subplot(4,1,4), plot(t,envv)
ylabel('amplitude'); title('(d) output of envelope detector');
axis([0,0.08, -1,4])
xlabel('seconds');

% this shows things a bit more clearly (but won't print well)
figure(2)
plot(t,v,'y')
hold on
plot(t,w)
plot(t,envv,'k')
ylabel('amplitude')
xlabel('yellow=modulated signal, blue=message, black=envelope')
hold off
