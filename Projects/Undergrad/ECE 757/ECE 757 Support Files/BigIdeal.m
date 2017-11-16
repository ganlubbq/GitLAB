% BigIdeal.m -- Example usage of BigTransmitter under 'ideal' conditions

% Message Generation
m='01234 I wish I were an Oscar Meyer wiener 56789';

% Frame parameters
frameParams.userDataLength=1;
frameParams.preamble='';
frameParams.chanCodingFlag=0;
frameParams.bitEncodingFlag=0;

% Channel parameters, Adjacent Users, Interference
chanParams.c1=[1 0 0];
chanParams.c2=[1 0 0];
chanParams.randomWalkVariance=0;
chanParams.SNR=Inf;
chanParams.adjacentUser1Power=-Inf;
chanParams.adjacentUser1f_if=0;
chanParams.adjacentUser1Chan=[1 0 0];
chanParams.adjacentUser2Power=-Inf;
chanParams.adjacentUser2f_if=0;
chanParams.adjacentUser2Chan=[1 0 0];
chanParams.NBIfreq=0;
chanParams.NBIPower=-Inf;

% RF Parameters
rfParams.f_if_err=0;
rfParams.T_t_err=0;
rfParams.phaseNoiseVariance=0;
rfParams.SRRCLength=4;
rfParams.SRRCrolloff=0.3;
rfParams.f_s=100;
rfParams.T_t=1;
rfParams.f_if=20;

% call transmitter ---------------------------------------------
[r s]=BigTransmitter(m, frameParams, rfParams, chanParams);


% Adjustable receiver parameters
receiver_gain=1;
data_start=5;

% Fixed receiver parameters
M=100;                                      % upsampling ratio              
fc=20;                                      % carrier frequency
srrc_length=4;                              % length of pulse shaping filter

%RECEIVER
% am demodulation of received signal sequence r
c2=cos(2*pi*fc*[1/M:1/M:length(r)/M]');     % synchronized cosine for mixing
x2=r.*c2;                                   % demod received signal

% extract upsampled pulses using correlation implemented as a convolving filter
y=filter(srrc(srrc_length,0.3,100),1,x2);   % filter rec'd sig with pulse

% set delay to first symbol-sample and increment by M
z=y(srrc_length*M:M:end);                   % downsample to symbol rate
z=z(data_start:data_start+length(m)*4-1)'*receiver_gain;   % toss out first few symbols, scale by gain

% plot soft decisions
plot([1:length(z)],z,'.')  

% decision device and symbol matching performance assessment
mprime=quantalph(z,[-3,-1,1,3])';           % quantize to +/-1 and +/-3 alphabet
cvar=(mprime-z)*(mprime-z)'/length(mprime)  % cluster variance
lmp=length(mprime);
pererr=100*sum(abs(sign(mprime-letters2pam(m))))/lmp       % symb err

% decode decision device output to text string
reconstructed_message=pam2letters(mprime)   % reconstruct message
