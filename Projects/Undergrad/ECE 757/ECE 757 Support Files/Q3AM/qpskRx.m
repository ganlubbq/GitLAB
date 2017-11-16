%=============================================
% Modem Receiver Simulator/ SER Determination
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

function [theoSER,uncSER,codBER,retMSE]=qpskRx(muStruct,recSigStruct)

OverSamp=4; %number of samples in between each symbol
ApproxPeriods=6; %1/2 number of periods to Approximate the SRRC with
Tb=5*10^-3; %baud interval in seconds
Ts=Tb/OverSamp; %sampling period
fc=200; %carrier frequency  (Hz)

recSig=recSigStruct.recSig;
training=recSigStruct.training;
msg1=recSigStruct.msg1;
msg2=recSigStruct.msg2;
constl=recSigStruct.constl;
msg1sc=recSigStruct.msg1sc;
msg2sc=recSigStruct.msg2sc;


Costas_Mu1=muStruct.Costas_Mu1;
Costas_Mu2=muStruct.Costas_Mu2;
Time_mu1=muStruct.Time_mu1;
Time_mu2=muStruct.Time_mu2;
EqMu=muStruct.EqMu;
ddEqMu=muStruct.ddEqMu;
debugFlag=muStruct.debugFlag;
codingFlag=muStruct.codingFlag;
scrambleFlag=muStruct.scrambleFlag;
beta=muStruct.beta;

timeRecFlag=1&debugFlag; %draw the timing parameter and constellation
eqFlag=1&debugFlag;
scramble_flag=1&debugFlag;
mseFlag=1&debugFlag;
costasFlag=1&debugFlag;

if scrambleFlag==1
  scrambler=recSigStruct.scrambler;
  scramLen=recSigStruct.scramLen;
end


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



%begin reciever

%first we attempt downconversion

%need a lpf for the costas loop
fl=200;
fbe=2*[0 fc*Ts-1/(16*OverSamp) fc*Ts+1/(16*OverSamp) .5];
amps=[1 1 0 0];
b=firls(fl,fbe,amps);


%cmu1=Costas_Mu1/((3/16)*mean(real(pshaped).^2)^2-(1/16)* ...
%		mean(real(pshaped).^4));
%cmu2=Costas_Mu2/((3/16)*mean(real(pshaped).^2)^2-(1/16)* ...
%		mean(real(pshaped).^4));

cmu1=Costas_Mu1/.0017;
cmu2=Costas_Mu2/.0017;


t=[1:length(recSig)]*Ts;
theta=zeros(1,length(recSig));
theta2=zeros(1,length(recSig));

v1=zeros(1,length(recSig));
v2=zeros(1,length(recSig));
v3=zeros(1,length(recSig));
v4=zeros(1,length(recSig));

v1=filter(b,1,recSig.*sin(2*pi*fc*t));
v2=filter(b,1,recSig.*sin(2*pi*fc*t+pi/4));
v3=filter(b,1,recSig.*cos(2*pi*fc*t));
v4=filter(b,1,recSig.*cos(2*pi*fc*t+pi/4));

Bdelay=(length(b)-1)/2;
z1=zeros(1);
z2=zeros(1);
z3=zeros(1);
z4=zeros(1);
for k=1:length(recSig)-1-length(b)/2
  cosThetaK=cos(theta(k));
  sinThetaK=sin(theta(k));
    z1=v1(k+Bdelay)*cosThetaK+v3(k+Bdelay)*sinThetaK;
    z2=v2(k+Bdelay)*cosThetaK+v4(k+Bdelay)*sinThetaK;
    z3=v3(k+Bdelay)*cosThetaK-v1(k+Bdelay)*sinThetaK;
    z4=v4(k+Bdelay)*cosThetaK-v2(k+Bdelay)*sinThetaK;
    theta(k+1)=theta(k)+cmu1*(z2*z4*z3*z1);

    cosTheta12=cos(theta(k)+theta2(k));
    sinTheta12=sin(theta(k)+theta2(k));
    z1=v1(k+Bdelay)*cosTheta12+v3(k+Bdelay)*sinTheta12;
    z2=v2(k+Bdelay)*cosTheta12+v4(k+Bdelay)*sinTheta12;
    z3=v3(k+Bdelay)*cosTheta12-v1(k+Bdelay)*sinTheta12;
    z4=v4(k+Bdelay)*cosTheta12-v2(k+Bdelay)*sinTheta12;
    theta2(k+1)=theta2(k)+cmu2*(z4*z2*z3*z1);
end

downCSig=zeros(1,length(recSig));
downCSig=2*recSig.*exp(-j*(2*pi*fc*t+theta+theta2));

if costasFlag==1
    figure;
    [Pxx,F]=pwelch(downCSig,[],[],[],1/Ts);
    plot(F,Pxx); title('Power Spectral Density of Signal at Output of Costas Loop');
    xlabel('Frequency (Hx)'); ylabel('PSD');
    figure;
    subplot(2,1,2); plot(theta2); title('Costas Loop \theta_2'); xlabel('Time');
    subplot(2,1,1); plot(theta); title('Costas Loop \theta'); ylabel('Time');
    drawnow;
end

%now we must low pass filter the down-converted signal
downSig=filter(b,1,downCSig);



%timing recovery
stuff=(ApproxPeriods*OverSamp+1):OverSamp: ...
      (length(downSig)-ApproxPeriods*OverSamp);

tau=zeros(1,length(stuff));
tau2=zeros(1,length(stuff));
timRecSig=zeros(1,length(stuff));
clear stuff;

i=1;
delta=.1;

timRecPDelta=2*ApproxPeriods*OverSamp+1;
timRecMDelta=2*ApproxPeriods*OverSamp+1;
timRecPDelta2=2*ApproxPeriods*OverSamp+1;
timRecMDelta2=2*ApproxPeriods*OverSamp+1;

for k=(ApproxPeriods*OverSamp+1):OverSamp:(length(downSig)-ApproxPeriods*OverSamp)
  data=downSig((k-ApproxPeriods*OverSamp):(k+ApproxPeriods* ...
					   OverSamp));
  
  timRecSig(i)=srrc(ApproxPeriods,beta,OverSamp,tau(i)+tau2(i))*data.';
  
  tempSig=srrc(ApproxPeriods,beta,OverSamp,tau(i))*data.';
  
  timRecPDelta=srrc(ApproxPeriods,beta,OverSamp,tau(i)+delta)* ...
      data.';
  
  timRecMDelta=srrc(ApproxPeriods,beta,OverSamp,tau(i)-delta)* ...
      data.';
  
  timRecPDelta2=srrc(ApproxPeriods,beta,OverSamp,tau(i)+tau2(i)+delta)* ...
      data.';
  
  timRecMDelta2=srrc(ApproxPeriods,beta,OverSamp,tau(i)+tau2(i)-delta)* ...
      data.';

  dXdTau2=(abs(timRecPDelta2)-abs(timRecMDelta2))/delta;
  tau2(i+1)=tau2(i)-Time_mu2*abs(timRecSig(i))^3*dXdTau2;
  
  dXdTau=(abs(timRecPDelta)-abs(timRecMDelta))/delta;
  tau(i+1)=tau(i)-Time_mu1*abs(tempSig)^3*dXdTau;  
  
  i=i+1;
end

if timeRecFlag==1
  figure;
  subplot(2,1,1); plot(tau+tau2); title('Timing Offset'); 
  subplot(2,1,2); plot(timRecSig((length(timRecSig)-200):end),'b.'); ...
      title('Convergent Eye Diagram'); axis square;
  drawnow;
end


%equalizer

%first we have to find the training
rrCorr=zeros(1,length(timRecSig)-length(training)+1);
irCorr=zeros(1,length(timRecSig)-length(training)+1);
for k=1:length(timRecSig)-length(training)+1
  rrCorr(k)=sum(real(training).*real(timRecSig(k:(k+length(training)-1))));
  irCorr(k)=sum(imag(training).*real(timRecSig(k:(k+length(training)-1))));
end

eqLen=6;
f=zeros(eqLen,1);

f(eqLen/2)=1;
delta=eqLen/2-1; %default delay


if max(abs(irCorr))>max(abs(rrCorr))
    [y,i]=max(abs(irCorr));
    sigToEq=zeros(1,length(timRecSig(i:end)));
    if abs(min(irCorr))>abs(max(irCorr))
      if length(timRecSig) > (i+length(training)+length(msg1sc))
        sigToEq=-j*timRecSig(i:end);
      else
       sigToEq=-j*timRecSig((length(timRecSig)-length(training)- ...
 			     length(msg1sc)-delta-eqLen):end);
      end
    else
        if length(timRecSig) > (i+length(training)+length(msg1sc))
 	 sigToEq=j*timRecSig(i:end);
        else
 	 sigToEq=j*timRecSig((length(timRecSig)-length(training)- ...
 			     length(msg1sc)-delta-eqLen):end);
        end
    end
  else
    [y,i]=max(abs(rrCorr));
    sigToEq=zeros(1,length(timRecSig(i:end)));
    if abs(min(rrCorr))>abs(max(rrCorr))
      if length(timRecSig) > (i+length(training)+length(msg1sc))
        sigToEq=-1*timRecSig(i:end);
      else
 	 sigToEq=-1*timRecSig((length(timRecSig)-length(training)- ...
 			     length(msg1sc)-delta-eqLen):end);
      end
    else
      if length(timRecSig) > (i+length(training)+length(msg1sc))     
        sigToEq=timRecSig(i:end);
      else
        sigToEq=timRecSig((length(timRecSig)-length(training)- ...
 			     length(msg1sc)-delta-eqLen):end);
      end
    end
  end


%now that we have found the training (and done some derotation)
%let's equalize


error=zeros(1,length(sigToEq));

eqOut=zeros(1,length(sigToEq));

if eqFlag==1
  figure;
  subplot(2,1,1); h1=plot(f);
  subplot(2,1,2); h2=plot([1+j -1-j],'b.'); 
  axis square; axis([-1.5 1.5 -1.5 1.5]);
  set(h1,'EraseMode','xor');
  set(h2,'EraseMode','xor');
end

for k=(eqLen+1):length(training)
  rr=sigToEq(k:-1:(k-eqLen+1));
  error(k)=training(k-delta)-rr*f;
  f=f+EqMu*error(k)*rr';
  eqOut(k)=rr*f;
  if (k>20) & eqFlag
      set(h2,'YData',imag(eqOut(k:-1:k-20)),'XData',real(eqOut(k:-1:k-20)));
      set(h1,'YData',f);
  end
  drawnow;
end

for k=length(training):length(sigToEq)
    rr=sigToEq(k:-1:(k-eqLen+1));
    error(k)=(sqrt(2)/2*sign(real(rr*f))+j*sign(imag(rr*f))*sqrt(2)/2)-rr*f;
    f=f+ddEqMu*error(k)*rr';
    eqOut(k)=rr*f;
end

if eqFlag==1
  figure;
  subplot(2,1,1); plot(abs(error).^2);
  title('Error over time');
  subplot(2,1,2); plot(eqOut(end-ceil(.5*length(eqOut)):end),'b.'); ...
      title('Output of Equalizer');
  axis square;
end

%quantize and keep only message
decOut=sign(real(eqOut))+j*sign(imag(eqOut));
decOut=decOut(length(training)+1+delta:length(training)+length(msg1sc)+delta);

%descramble the message:
decAndDes1=zeros(1,length(decOut));
decAndDes2=zeros(1,length(decOut));


if scrambleFlag==1
  for k=1:scramLen:length(decOut)-scramLen
    decAndDes1(k:k+scramLen-1)=xor(con_to_bin(real(decOut(k:k+scramLen-1)),constl), ...
					scrambler);
    decAndDes2(k:k+scramLen-1)=xor(con_to_bin(imag(decOut(k:k+scramLen-1)),constl), ...
					scrambler);
  end
  k=k+20;
  decAndDes1(k:length(decOut))=xor(con_to_bin(real(decOut(k:length(decOut))),constl), ...
				       scrambler(1:length(decOut)-k+1));
  decAndDes2(k:length(decOut))=xor(con_to_bin(imag(decOut(k:length(decOut))),constl), ...
				       scrambler(1:length(decOut)-k+1));
else
  decAndDes1=con_to_bin(real(decOut),constl);
  decAndDes2=con_to_bin(imag(decOut),constl);
end


%decoding

if codingFlag==1
  decode1=zeros(1,length(decAndDes1)*2/5);
  decode2=zeros(1,length(decAndDes2)*2/5);
  decode1=chandecode(decAndDes1,H,syn,ginv);
  decode2=chandecode(decAndDes2,H,syn,ginv);
else
  decode1=decAndDes1;
  decode2=decAndDes2;
end
decode=decode1+j*decode2;
codBER=sum(sum((decode1~=con_to_bin(msg1,constl))+(decode2~=con_to_bin(msg2,constl))))/(2*length(decode));


%measure and estimate SER performance

errSig=eqOut(delta+1:length(training)+length(msg1sc)+delta);
compMe=[training msg1sc+j*msg2sc];

%theoretical uncoded SER
M=1;
sir=1/mean(abs(errSig(length(training):end)-compMe(length(training):end)).^2);
theoSER=1-(1-(1-1/(sqrt(2^M*2^M)))*erfc(sqrt(3*sir/(2*(2^M*2^M- ...
						  1))))).^2

% theoSER2=2*myOwnQ(sqrt(sir))-myOwnQ(sqrt(sir))^2

retMSE=mean(abs(errSig(length(training):end)-compMe(length(training):end)).^2);

%empirical uncoded SER
uncDec=sign(real(errSig(length(training):end)))*sqrt(2)/2+j* ...
       sign(imag(errSig(length(training):end)))*sqrt(2)/2;

uncSER=sum(sum(abs(compMe(length(training):end)-uncDec)>10^-13))/length(uncDec);

BER=sum((decode1~=con_to_bin(msg1,constl))+(decode2~=con_to_bin(msg2,constl)))/(2*length(decode1));
