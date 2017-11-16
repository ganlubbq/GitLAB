% BigEx3.m 

% Message Generation
m1='01234 I wish I were an Oscar Meyer wiener 56789ABC';
m2='That ss what I truly wish to be cause if I were...';
m=[m1; m2];

% Frame parameters
frameParams.userDataLength=5;
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

