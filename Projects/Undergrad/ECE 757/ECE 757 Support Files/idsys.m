%idsys.m:  idealized transmission system

%TRANSMITTER
% encode text string as T-spaced 4-PAM sequence
str='01234 I wish I were an Oscar Meyer wiener 56789';
m=letters2pam(str); N=length(m); % 4-level signal of length N
% zero pad T-spaced symbol sequence to create upsampled
% T/M-spaced sequence of scaled T-spaced pulses (T=1)
M=100;                        % oversampling factor
mup=zeros(1,N*M);             % Hamming pulse filter with 
mup(1:M:N*M)=m;               % T/M-spaced impulse response
p=hamming(M);                 % blip pulse of width M
x=filter(p,1,mup);            % convolve pulse shape with data
figure(1), plotspec(x,1/M)    % baseband AM modulation
t=1/M:1/M:length(x)/M;        % T/M-spaced time vector
fc=20;                        % carrier frequency
c=cos(2*pi*fc*t);             % carrier
r=c.*x;                       % modulate message with carrier

%RECEIVER
% am demodulation of received signal sequence r
c2=cos(2*pi*fc*t);             % synchronized cosine for mixing
x2=r.*c2;                      % demod received signal
fl=50; fbe=[0 0.1 0.2 1];      % LPF parameters 
damps=[1 1 0 0 ]; 
b=firpm(fl,fbe,damps);         % create LPF impulse response
x3=2*filter(b,1,x2);           % LPF and scale signal
% extract upsampled pulses using correlation implemented 
% as a convolving filter; filter with pulse and normalize
y=filter(fliplr(p)/(pow(p)*M),1,x3);
% set delay to first symbol-sample and increment by M
z=y(0.5*fl+M:M:N*M);           % downsample to symbol rate
figure(2), plot([1:length(z)],z,'.') % plot soft decisions
% decision device and symbol matching performance assessment
mprime=quantalph(z,[-3,-1,1,3])'; % quantize alphabet
cvar=(mprime-z)*(mprime-z)'/length(mprime), % cluster variance
lmp=length(mprime);
pererr=100*sum(abs(sign(mprime-m(1:lmp))))/lmp, % symbol error
% decode decision device output to text string
reconstructed_message=pam2letters(mprime)
