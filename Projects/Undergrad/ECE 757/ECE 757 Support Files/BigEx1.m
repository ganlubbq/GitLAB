% BigEx1.m

% Message Generation
m=['Put any message here of your choice, preferably something with ' ...
  'at least a couple hundred characters. This message might suffice.'];


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
chanParams.adjacentUser1f_if=2e6-204e3;
chanParams.adjacentUser1Chan=[1 0 0];
chanParams.adjacentUser2Power=-Inf;
chanParams.adjacentUser2f_if=2e6+204e3;
chanParams.adjacentUser2Chan=[1 0 0];
chanParams.NBIfreq=1.9e6;
chanParams.NBIPower=-Inf;

% RF Parameters
rfParams.f_if_err=0;
rfParams.T_t_err=0;
rfParams.phaseNoiseVariance=0;
rfParams.SRRCLength=4;
rfParams.SRRCrolloff=0.3;
rfParams.f_s=1e6;
rfParams.T_t=6e-6;
rfParams.f_if=2.2e6;

% call transmitter
[r s]=BigTransmitter(m, frameParams, rfParams, chanParams);

