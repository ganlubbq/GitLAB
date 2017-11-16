%% Signal generation
%
% Show orthogonality for two sinusoids in an OFDM system using the equation
% provided in the lecture notes.

clear all, close all, clc

Fc = 100;       % 100 Hz carrier frequency.
del = 40;       % 40 Hz offset frequency.
Ts = 0.0001;    % 10 kHz Fs.

t = 0:Ts:20-Ts;  % time axis.
n = size(t,2);  % indicate total number of samples.

N = 1:1:2;

S1 = sin(2*pi*Fc*t);              % base carrier.
S2 = sin(2*pi*(Fc + del)*t);      % offset sinusoid.
S3 = sin(2*pi*(Fc + 2*del)*t);    % second interval offset.


f1 = exp(-j*(2*pi)*(1/2)*t);      % First subcarrier
f2 = exp(-j*(2*pi)*(2/2)*t);      % Second subcarrier


figure(1)
subplot(3,1,1)
plot(t,S1);grid;
title('Sinusoidal Inputs of Analog OFDM');
ylabel('S1');
subplot(3,1,2)
plot(t,S2);grid;
ylabel('S2');
subplot(3,1,3)
plot(t,S3);grid;
ylabel('S3');

figure(2)
subplot(2,1,1)
plot(t,real(f1),t,imag(f1));grid;
title('f_1(t) = \ite^{j2\pi 1(W/2)t}');
legend('\Re\{ f_1(t) \}','\Im\{ f_1(t) \}','Location','SouthEast');
subplot(2,1,2)
plot(t,real(f2),t,imag(f2));grid;
title('f_2(t) = \ite^{j2\pi 2(W/2)t}');
legend('\Re\{ f_2(t) \}','\Im\{ f_2(t) \}','Location','SouthEast');


st = linspace(-10,10,1000);     % sinc, -10 to 10.
y1 = sinc(st);
y2 = sinc(st);
y3 = sinc(st + ((pi/2)/4000));
figure(3)
hold on
plot(st+1,y2,'r',st+2,y2,'b',st,y3,'r--');grid;xlim([-8 11]);
xlabel('nT_s intervals');
title('Two Subcarrier Signals with T_s Rectangular Pulse Shapes');
legend('sinc(x) of T_s','sinc(x) of 2T_s','sinc(x + \pi/2)','Location','Best');
ylabel('X(f)');
hold off
