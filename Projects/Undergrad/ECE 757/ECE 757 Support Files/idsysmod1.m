%idsysmod1.m:  idealized transmission system

%TRANSMITTER
% encode text string as T-spaced PAM (+/-1, +/-3) sequence
str='01234 I wish I were an Oscar Meyer wiener 56789';
m=letters2pam(str); N=length(m);    % 4-level signal of length N
% zero pad T-spaced symbol sequence to create upsampled T/M-spaced
% sequence of scaled T-spaced pulses (with T = 1 time unit)
M=100; mup=zeros(1,N*M); mup(1:M:N*M)=m;  % oversampling factor
% Hamming pulse filter with T/M-spaced impulse response
p=hamming(M);                       % blip pulse of width M
x=filter(p,1,mup);                  % convolve pulse shape with data
figure(1), plotspec(x,1/M)          % baseband signal spectrum
% am modulation
t=1/M:1/M:length(x)/M;              % T/M-spaced time vector
fc=20;                              % carrier frequency
c=cos(2*pi*fc*t);                   % carrier
r=c.*x;                             % modulate message with carrier

% TIME-VARYING FADING CHANNEL
lr=length(r);                % length of transmitted signal vector
fp=[ones(1,floor(0.2*lr)), 0.5*ones(1,lr-floor(0.2*lr))];  % flat fading profile
r=r.*fp;                     % apply profile to transmitted signal vector

%RECEIVER
% am demodulation of received signal sequence r
c2=cos(2*pi*fc*t);                   % synchronized cosine for mixing
x2=r.*c2;                            % demod received signal
fl=50; fbe=[0 0.1 0.2 1]; damps=[1 1 0 0 ];  % design of LPF parameters
b=firpm(fl,fbe,damps);               % create LPF impulse response
x3=2*filter(b,1,x2);                 % LPF and scale downconverted signal
% extract upsampled pulses using correlation implemented as a convolving filter
y=filter(fliplr(p)/(pow(p)*M),1,x3);  % filter rec'd sig with pulse; normalize
% set delay to first symbol-sample and increment by M
z=y(0.5*fl+M:M:N*M);                 % downsample to symbol rate
figure(2), plot([1:length(z)],z,'.')  % soft decisions
% decision device and symbol matching performance assessment
mprime=quantalph(z,[-3,-1,1,3])';    % quantize to +/-1 and +/-3 alphabet
cvar=(mprime-z)*(mprime-z)'/length(mprime),  % cluster variance
lmp=length(mprime);
pererr=100*sum(abs(sign(mprime-m(1:lmp))))/lmp,  % symb err
% decode decision device output to text string
reconstructed_message=pam2letters(mprime)  % reconstruct message

