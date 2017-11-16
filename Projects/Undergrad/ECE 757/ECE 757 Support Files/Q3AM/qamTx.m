%=============================================
% Modem Transmitter and Channel Simulator
%---------------------------------------------
% John Walsh
%---------------------------------------------
% This software and manual is based upon 
% work done by John MacLaren Walsh, Katie 
% Orlicki, Adam Pierce, Johnson Smith, Andy 
% Klein, and Sean Leventhal under the guidance
% of  Dr. C. Richard Johnson, Jr.
%---------------------------------------------
% Version 1.0
% 1/20/2003

function recSigStruct=qamTx(impairments,specs);


%initialize receiver specifications
v=specs.v; % 2*bits/symbol in constellation
           % for QPSK v=1
	   % for 16-QAM v=2
codingFlag=specs.codingFlag;
scramble_flag=specs.scramble_flag; %plots?
beta=specs.beta; %pShape Rolloff
scrambleFlag=specs.scrambleFlag;
	   
%intialize impairment variables
ph_off=impairments.ph_off;%phase offset
f_off=impairments.f_off;  %frequency offset
t_off=impairments.t_off;  %timing offset
SNR=impairments.SNR;
channel=impairments.channel;
TVChan=impairments.TVChan;
alpha=impairments.alpha;
g=impairments.g; 
c=impairments.c;
bfo=impairments.bfo; % baud frequency off.
tNoiseVar=impairments.tNoiseVar;
pNoiseVar=impairments.pNoiseVar;
debugFlag=impairments.debugFlag;

%debugging flags:
constDrawFlag=1&debugFlag; %draw the constellation
pulseShapeFlag=1&debugFlag; %draw the pulse shaped signal and its PSD
txOutFlag=1&debugFlag; %draw the PSD of the output of the transmitter
ChannelFlag=1&debugFlag; %draw the PSD of the output of the Channel


%General Parameters
mesLen=1000; %message length
trainLen=800; %training Length
OverSamp=4; %number of samples in between each symbol
ApproxPeriods=6; %1/2 number of periods to Approximate the SRRC with
Tb=5*10^-3; %baud interval in seconds
Ts=Tb/OverSamp; %sampling period
fc=200; %carrier frequency  (Hz)



%==============================generate the message:================================
M=2^v; % MxM QAM
delta=2; %distance in between constellation points

%the meshgrid command will generate all possible combinations for us:
vals=[-1*((M/2-1)*delta+delta/2):delta:((M/2-1)*delta+delta/2)];
[iM,qM]=meshgrid(vals,vals);
stuff=iM+j*qM;
constl=stuff(:); %set of all points in the constellation

%normalize the constellation so it is unit power
Es=0;
for k=1:length(constl)
    Es=Es+abs(constl(k))^2/length(constl);
end

constl=constl/sqrt(Es);

if constDrawFlag==1
    figure;
    plot(constl,'b.');
    title('The Signal Constellation');
end

msg=zeros(1,mesLen);

%use the constellation to generate a random message
msg=constl(round(rand(1,mesLen)*M^2-.5)+1).';
training=constl(round(rand(1,trainLen)*M^2-.5)+1).';
startJunk=constl(round(rand(1,100)*M^2-.5)+1).';
endJunk=constl(round(rand(1,100)*M^2-.5)+1).';
%==================================================================================


%====================== Code and Scramble the Message =============================

ginv=[1 1;1 0;0 0;1 0;0 1];
syn=[0 0 0 0 0;
     0 0 0 0 1;
     0 0 0 1 0;
     0 1 0 0 0;
     0 0 1 0 0;
     1 0 0 0 0;
     1 1 0 0 0;
     1 0 0 1 0];
G=[1 0 1 0 1; 0 1 0 1 1];
H=[1 0 1 0 0; 0 1 0 1 0; 1 1 0 0 1];

if codingFlag==1
  msg1c=chancode(con_to_bin(real(msg),constl),G);
  msg2c=chancode(con_to_bin(imag(msg),constl),G);
else
  msg1c=con_to_bin(real(msg),constl);
  msg2c=con_to_bin(imag(msg),constl);
end


%scramble the message:
if scrambleFlag==1
  scramLen=21;
  scrambler=.5*(sign(rand(1,scramLen)-.5)+1);
  msg1sc=zeros(1,length(msg1c));
  msg2sc=zeros(1,length(msg2c));
  for k=1:scramLen:length(msg1c)-scramLen
    msg1sc(k:k+scramLen-1)=bin_to_con(xor(msg1c(k:k+scramLen-1), ...
					scrambler),constl);
    msg2sc(k:k+scramLen-1)=bin_to_con(xor(msg2c(k:k+scramLen-1), ...
					scrambler),constl);
  end
  k=k+20;
  msg1sc(k:length(msg1c))=bin_to_con(xor(msg1c(k:length(msg1c)), ...
				       scrambler(1:length(msg1c)-k+1)),constl);
  msg2sc(k:length(msg1c))=bin_to_con(xor(msg2c(k:length(msg2c)), ...
				       scrambler(1:length(msg2c)-k+1)),constl);
else
  msg1sc=bin_to_con(msg1c,constl);
  msg2sc=bin_to_con(msg2c,constl);
end

if scramble_flag==1
  subplot(2,1,1); plot(abs(fft(bin_to_con(msg1c,constl)+j*bin_to_con(msg2c,constl))));
  title('FFT of Coded Message');
  subplot(2,1,2); plot(abs(fft(msg1sc+j*msg2sc)));
  title('FFT of Signal Whitenend With Scrambling');
end

%combine all of the data into one big transmission
message=[startJunk training msg1sc+msg2sc*j  endJunk];
%==================================================================================

%===============upsample and pulse shape the message===============================
%generate the pulse shape
pshaped=zeros(1,2*OverSamp*ApproxPeriods+(length(message)-1)*OverSamp+1);

%model the timing jitter as a random walk
tauNoise=filter(1,[1 -1],sqrt(tNoiseVar)*randn(1,length(message)));


for k=1:length(message)
  ps=srrc(ApproxPeriods,beta,OverSamp,t_off+tauNoise(k)+bfo/(1-bfo)*k*OverSamp);
  pshaped(((k-1)*OverSamp+1):((k-1)*OverSamp+2*OverSamp*ApproxPeriods+1))=...
      pshaped(((k-1)*OverSamp+1):((k-1)*OverSamp+2*OverSamp*ApproxPeriods+1))...
      +ps*message(k);
end


if pulseShapeFlag==1
    
    figure;
    subplot(2,1,1); 
    plot([length(ps):length(ps)+300]*Ts,real(pshaped(length(ps):length(ps)+300)));
    title('Real Part of some of the Pulse Shaped Signal');
    xlabel('Time (sec)');
    
    
    [Pxx,F] = pwelch(pshaped,[],[],[],1/Ts);
    subplot(2,1,2); 
    plot(F,Pxx); title('Power Spectral Density of Pulse Shaped Signal');
    xlabel('Frequency (Hz)'); ylabel('PSD');
    drawnow;
    
    
    figure;
    [Nxx,F]=pwelch(tauNoise,[],[],[],1/Ts);
    plot(F,Nxx); title('PSD of the timing Jitter');
end;
%===================================================================================


%=====================upconvert it onto a carrier===================================

txOut=zeros(1,length(pshaped));
ph_noise=filter(1,[1 -1],sqrt(pNoiseVar)*randn(1,length(pshaped)));
txOut=real(pshaped.*exp(j*(2*pi*fc*(1-f_off)*[1:length(pshaped)]*Ts+ph_off+ph_noise)));

if txOutFlag==1
    figure;
    [Pxx,F]=pwelch(txOut,[],[],[],1/Ts); 
    plot(F,Pxx);
    title('Power Spectral Density of Upconverted Signal');
    xlabel('Frequency (Hz)'); ylabel('PSD');
    drawnow;
end
%===================================================================================



%====================Put the Signal Through a Noisy ISI Channel=====================

%use energy of the source to get this
Es=0;
for k=(-M+1):2:(M-1)
    for m=(-M+1):2:(M-1)
        Es=Es+(1/(M^2))*(k^2+m^2)*(delta^2)/4;
    end
end
sigma=Es/(10^(SNR/10)); %noise variance
noise=zeros(1,length(channel)+length(txOut)-1);
if TVChan==0
  recSig=zeros(1,length(channel)+length(txOut)-1);
  noise=randn(1,length(channel)+length(txOut)-1)*sqrt(sigma);
  recSig=noise+conv(txOut,channel);
else
  NNrecSig=zeros(1,length(txOut)-OverSamp);
  for k=OverSamp+1:length(txOut)
    curChan=[1 zeros(1,OverSamp-1) cos(2*pi*fc*alpha*k*Ts)];
    NNrecSig(k-OverSamp)=curChan*txOut(k:-1:k-length(curChan)+1).';
  end
  recSig=NNrecSig+randn(1,length(NNrecSig))*sqrt(sigma);
end

if ChannelFlag==1
    figure;
    [Pxx,F]=pwelch(recSig,[],[],[],1/Ts);
    plot(F,Pxx); title('Power Spectral Density of Signal at Output of Channel');
    xlabel('Frequency (Hz)'); ylabel('PSD');
    drawnow;
end
%===================================================================================


recSigStruct.recSig=recSig;
recSigStruct.training=training;
recSigStruct.msg1=real(msg);
recSigStruct.msg2=imag(msg);
recSigStruct.constl=constl;
recSigStruct.msg1sc=msg1sc;
recSigStruct.msg2sc=msg2sc;
if scrambleFlag==1
  recSigStruct.scramLen=scramLen;
  recSigStruct.scrambler=scrambler;
end
