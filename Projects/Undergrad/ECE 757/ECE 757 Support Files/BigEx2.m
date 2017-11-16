% BigEx2.m 

% Message Generation
m=char(floor(rand(1,20*56-62)*91)+32);  % random message

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
chanParams.adjacentUser1Power=0;
chanParams.adjacentUser1f_if=?;
chanParams.adjacentUser1Chan=[1 0 0];
chanParams.adjacentUser2Power=-Inf;
chanParams.adjacentUser2f_if=0;
chanParams.adjacentUser2Chan=[1 0 0];
chanParams.NBIfreq=1.9e6;
chanParams.NBIPower=-Inf;

% RF Parameters
rfParams.f_if_err=0;
rfParams.T_t_err=0;
rfParams.phaseNoiseVariance=0;
rfParams.SRRCLength=4;
rfParams.SRRCrolloff=0.3;
rfParams.f_s=?;
rfParams.T_t=1e-6;
rfParams.f_if=?;

% call transmitter
[r s]=BigTransmitter(m, frameParams, rfParams, chanParams);

