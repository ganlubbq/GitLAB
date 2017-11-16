% impsys.m:  transmission system with uncompensated impairments

% specification of impairments
cng=input('channel noise gain: try 0, 0.6 or 2 :: ');
cdi=input('channel multipath: 0 for none, 1 for mild or 2 for harsh ::  ');
fo=input('tranmsitter mixer freq offset in percent: try 0 or 0.01 ::  ');
po=input('tranmsitter mixer phase offset in rad: try 0, 0.7 or 0.9 ::  ');
toper=input('baud timing offset as percent of symb period: try 0, 20 or 30 ::  ');
so=input('symbol period offset: try 0 or 1 ::  ');

%TRANSMITTER

% encode text string as T-spaced PAM (+/-1, +/-3) sequence
str='01234 I wish I were an Oscar Mayer wiener 56789';
m=letters2pam(str); N=length(m);  % 4-level signal of length N

% zero pad T-spaced symbol sequence to create upsampled T/M-spaced
%      sequence of scaled T-spaced pulses (with T = 1 time unit)
M=100-so; mup=zeros(1,N*M); mup(1:M:N*M)=m;  % oversample by M >=8

% Hamming pulse filter with T/M-spaced impulse response
p=hamming(M);                 % blip pulse of width M

% pulse filter output
x=filter(p,1,mup);            % convolve pulse shape with data
figure(1), plotspec(x,1/M)    % baseband signal spectrum

% am modulation
t=1/M:1/M:length(x)/M;        % T/M-spaced time vector
fc=20;                        % carrier frequency
c=cos(2*pi*(fc*(1+0.01*fo))*t+po);  % carrier with offsets relative to rec osc
r=c.*x;                       % modulate message with carrier

%CHANNEL

if cdi < 0.5,                 % channel ISI
  mc=[1 0 0];                 % distortion-free channel
elseif cdi<1.5,               % mild multipath channel
  mc=[1 zeros(1,M) 0.28 zeros(1,2.3*M) 0.11]; 
else                          % harsh multipath channel
  mc=[1 zeros(1,M) 0.28 zeros(1,1.8*M) 0.44];
end
mc=mc/(sqrt(mc*mc'));         % normalize channel power
dv=filter(mc,1,r);            % filter signal through channel
nv=dv+cng*(randn(size(dv)));  % add Gaussian channel noise
to=floor(0.01*toper*M);       % fractional period delay
rnv=nv(1+to:N*M);             % delay in on-symbol designation
rt=(1+to)/M:1/M:length(nv)/M; % time vector with delayed start
rM=M+so;                      % receiver sampler timing offset

%RECEIVER

% am demodulation of received signal sequence
c2=cos(2*pi*fc*rt);                   % create synchronized cosine for mixing
x2=rnv.*c2;                           % demod received signal
fl=floor(50);                         % LPF length
fbe=[0 0.1 0.2 1]; damps=[1 1 0 0 ];  % design of LPF parameters
b=firpm(fl,fbe,damps);                % calculation of LPF impulse response
x3=2*filter(b,1,x2);                  % LPF and scale downconverted signal

% extract upsampled pulses using correlation implemented as a convolving filter
rp=hamming(rM);                            % receiver defined pulse shape
y=filter(fliplr(rp)/(pow(rp)*rM),1,x3);    % filter rec'd sig with normalized pulse
figure(2), ul=floor((length(y)-124)/(4*rM));
plot(reshape(y(125:ul*4*rM+124),4*rM,ul))  % plot the eye diagram

% downsample to symbol rate
z=y(0.5*fl+rM:rM+so:N*M-to);  % set delay to first symbol-sample and increment by M
figure(3), plot([1:length(z)],z,'.')      % soft decisions

% decision device and symbol matching performance assessment
mprime=quantalph(z,[-3,-1,1,3])';         % quantize to +/-1 and +/-3 alphabet
cluster_variance=(mprime-z)*(mprime-z)'/length(mprime),     % cluster variance
lmp=length(mprime);   % number of recovered symbol estimates
percentage_symbol_errors=100*sum(abs(sign(mprime-m(1:lmp))))/lmp  % symb err

% decode decision device output to text string
reconstructed_message=pam2letters(mprime)  % reconstruct message

