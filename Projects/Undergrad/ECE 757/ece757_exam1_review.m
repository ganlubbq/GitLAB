% ece757_exam1_review covers question 5.14.
time=0.3; Ts=1/10000;                        % sampling interval & time
t=Ts:Ts:time; lent=length(t);                % define a time vector
fm=20; fc=1000;
c=cos(2*pi*fc*t);                            % carrier at freq fc
s=sin(2*pi*fc*t);                            % carrier at freq fc
gam=0; phi=0;                                % freq & phase offset
w1=5/lent*(1:lent)+cos(2*pi*(fm+gam)*t+phi); % create "message" cosine
w2=5/lent*(1:lent)+sin(2*pi*(fm+gam)*t+phi); % create "message" sine
v1=c.*w1;                                    % cosine modulate with carrier
v2=s.*w2;                                    % sine modulate with carrier
v3=v1-v2;                                    % quadrature mixed signal
x1=v3.*c;                                    % demod received signal-cosine
x2=v3.*s;                                    % demod received signal-sine
fbe=[0 0.1 0.2 1]; damps=[1 1 0 0];          % LPF design
fl=100; b=firpm(fl,fbe,damps);               % impulse response of LPF
m1=2*filter(b,1,x1);                         % LPF the demodulated signal
m2=2*filter(b,1,x2);                         % LPF the demodulated signal

                           % quadrature mixed signal

% used to plot figure; v1 and v2 are the signals after initial modulation,
% prior to mixing and modulated in two separate channels.

figure(1)
subplot(4,1,1), plot(t,w1)
axis([0,0.1, -3,3])
ylabel('amplitude'); title('(a) message signal(cosine)');
subplot(4,1,2), plot(t,v1)
axis([0,0.1, -2.5,2.5])
ylabel('amplitude'); title('(b) v1(t) message after modulation');
subplot(4,1,3), plot(t,x1)
axis([0,0.1, -3,3])
ylabel('amplitude');
title('(c) demodulated signal');
subplot(4,1,4), plot(t,m1)
axis([0,0.1, -3,3])
ylabel('amplitude'); title('(d) recovered m1(t) message');

figure(2)
subplot(4,1,1), plot(t,w2)
axis([0,0.1, -3,3])
ylabel('amplitude'); title('(a) message signal (sine)');
subplot(4,1,2), plot(t,v2)
axis([0,0.1, -2.5,2.5])
ylabel('amplitude'); title('(b) v2(t) message after modulation');
subplot(4,1,3), plot(t,x2)
axis([0,0.1, -3,3])
ylabel('amplitude');
title('(c) demodulated signal');
subplot(4,1,4), plot(t,m2)
axis([0,0.1, -3,3])
ylabel('amplitude'); title('(d) recovered m2(t) message');

figure(3)
subplot(3,1,1), plot(t,v3)
axis([0,0.1, -2.5,2.5])
ylabel('amplitude'); title('quadrature v3(t) message after modulation');
subplot(3,1,2), plot(t,m2)
axis([0,0.1, -3,3])
ylabel('amplitude'); title('recovered s2(t) message');
subplot(3,1,3), plot(t,m1)
axis([0,0.1, -3,3])
ylabel('amplitude'); title('recovered s1(t) message');
