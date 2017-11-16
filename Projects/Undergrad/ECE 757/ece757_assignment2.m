%% Exercise 3.17
% ECE 757 - Matlab Portion of Assignment #2
%

% Looking at the various Ts values, 1/90 and 1/50 both show an incorrect
% spectrum, with 1/50 having a centralized spectral peak at 0, indicating a
% DC component, and 1/90 has peaks at +/- 40 Hz, another incorrect
% frequency value. 1/100 indicates a strong peak at -50, which is evenly
% symmetric about zero, this is a correct spectrum. 1/110 and 1/200 also
% have the correct spectrum, although the shape produced by 1/110 has an
% envelope present.

f=50;                       % specify frequency and phase
time=3;                     % length of time
Ts=1/100;                   % time interval between samples
t=Ts:Ts:time;               % create a time vector
x=cos(2*pi*f*t);            % create cos wave
plotspec(x,Ts)              % draw waveform and spectrum
title('Ts = 1/100')


figure
Ts90=1/90;                  % time interval between samples
t90=Ts90:Ts90:time;         % create a time vector
x90=cos(2*pi*f*t90);        % create cos wave
plotspec(x90,Ts90)          % draw waveform and spectrum
title('Ts = 1/90')

figure
Ts50=1/50;                  % time interval between samples
t50=Ts50:Ts50:time;         % create a time vector
x50=cos(2*pi*f*t50);        % create cos wave
plotspec(x50,Ts50)          % draw waveform and spectrum
title('Ts = 1/50')

figure
Ts110=1/110;                  % time interval between samples
t110=Ts110:Ts110:time;         % create a time vector
x110=cos(2*pi*f*t110);        % create cos wave
plotspec(x110,Ts110)          % draw waveform and spectrum
title('Ts = 1/110')

figure
Ts200=1/200;                  % time interval between samples
t200=Ts200:Ts200:time;         % create a time vector
x200=cos(2*pi*f*t200);        % create cos wave
plotspec(x200,Ts200)          % draw waveform and spectrum
title('Ts = 1/200')

%% Exercise 3.19(b,d)
%
% b. Mimic the code in speccos.m with Ts=1/1000 to find the spectrum of the
% output y(t) of a squaring block when the input is x(t) = cos(2pif1t) +
% cos(2pif2t) for f1 = 100 and f2 = 150.

f1=100; f2=150;                           % specify frequency and phase
time=2;                                   % length of time
Ts=1/1000;                                % time interval between samples
t=Ts:Ts:time;                             % create a time vector
x=cos(2*pi*f1*t) + cos(2*pi*f2*t);        % create cos wave
plotspec(x,Ts)                            % draw waveform and spectrum

%% Exercise 3.26(a)
%
% Emulate the code within modulate.m to find the spectrum of y(t) of a
% modulator block with modulation frequency fc = 1000 Hz, when the input is
% x(t) = cos(2pif1t) + cos(2pif2t) for f1 = 100 and f2 = 150.

f1 = 100; f2 = 150;
time=.5; Ts=1/10000;                 % time and sampling interval
t=Ts:Ts:time;                        % define a 'time' vector
fc=1000; cmod=cos(2*pi*fc*t);        % create cos of freq fc
x=cos(2*pi*f1*t)+cos(2*pi*f2*t);     % input is cos of freq fi
y=cmod.*x;                           % multiply input by cmod
figure(1), plotspec(cmod,Ts)         % find spectra and plot
figure(2), plotspec(x,Ts)
figure(3), plotspec(y,Ts)

%Here's how the figure was actually drawn
N=length(x);                            % length of the signal x
t=Ts*(1:N);                             % define a time vector
ssf=(-N/2:N/2-1)/(Ts*N);                % frequency vector
fx=fftshift(fft(x(1:N)));
figure(4), subplot(3,1,1), plot(ssf,abs(fx))
xlabel('magnitude spectrum at input')
fcmod=fftshift(fft(cmod(1:N)));
subplot(3,1,2), plot(ssf,abs(fcmod))
xlabel('magnitude spectrum of the oscillator')
fy=fftshift(fft(y(1:N)));
subplot(3,1,3), plot(ssf,abs(fy))
xlabel('magnitude spectrum at output')

%% Exercise 4.10
%
% Suppose that a system has an impulse response that is an exponential
% pulse. Mimic the code in convolex.m to find its output when the input is
% a white noise, (recall specnoise.m)

% convolex.m: example of numerical convolution
Ts=1/100; time=10;        % sampling interval and total time
t=0:Ts:time;              % create time vector
h=exp(-t);                % define impulse response
x=randn(1,1001);

y=conv(h,x);              % do convolution
subplot(3,1,1), plot(t,x) % and plot
subplot(3,1,2), plot(t,h)
subplot(3,1,3), plot(t,y(1:length(t)))

% actual commands used to draw figure:
subplot(3,1,1), plot(t,x)
ylabel('input')
subplot(3,1,2), plot(t,h)
ylabel('impulse response')
subplot(3,1,3), plot(t,y(1:length(t)))
ylabel('output')
xlabel('time in seconds')

%% Exercise 5.2
%
% Verify using AMlarge.m.
% a. Change the phase of the transmitted signal.

% AMlarge.m: large carrier AM demodulated with "envelope"
time=0.33; Ts=1/10000;                    % sampling interval & time
t=0:Ts:time; lent=length(t);              % define a time vector
g = 48e15;                                % (MODIFY HERE)
fm=20; fc=1000; c=cos(2*pi*(fc+g)*t);     % define carrier at freq fc
w=10/lent*[1:lent]+cos(2*pi*fm*t);        % create "message" > -1
v=c.*w+c;                                 % modulate w/ large carrier
fbe=[0 0.05 0.1 1];                       % LPF design
damps=[1 1 0 0]; fl=100; 
b=firpm(fl,fbe,damps);                    % impulse response of LPF
envv=(pi/2)*filter(b,1,abs(v));           % find envelope

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
title('Additional Frequency = 24 GHz')
hold off

%% Exercise 5.6
% Try different phase offsets. phi = [-pi, -pi/2, -pi/6, 0, pi/6, pi/3,
% pi/2, pi]. How well does the recovered message m(t) match the actual
% message of w(t)? For each case, what is the spectrum of m(t)?

% AM.m suppressed carrier AM with freq and phase offset
time=0.3; Ts=1/10000;               % sampling interval & time
t=Ts:Ts:time; lent=length(t);       % define a time vector
fm=20; fc=1000; c=cos(2*pi*fc*t);   % carrier at freq fc
w=5/lent*(1:lent)+cos(2*pi*fm*t);   % create "message"
v=c.*w;                             % modulate with carrier
gam=0; phi=0;                       % (MODIFY HERE)
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

figure
plotspec(m,Ts)