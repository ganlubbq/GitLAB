specs.v=1;
specs.codingFlag=1;
specs.scrambleFlag=0;
specs.beta=.25;
specs.scramble_flag=0;
specs.OverSamp=4;

b.Costas_Mu1=.001;
b.Costas_Mu2=.0004;
b.Time_mu1=.01; %.05
b.Time_mu2=.002; %.01
b.EqMu=.005;
b.ddEqMu=.001;
b.debugFlag=1;
b.scrambleFlag=0;
b.codingFlag=1;
b.beta=.25;

m.debugFlag=1;
m.ph_off=pi/6; %phase offset
m.f_off=0; %ratio of carrier frequency that offset is
m.t_off=.7;
m.SNR=800; %SNR in DB
m.channel=[1];
m.tNoiseVar=0;
m.bfo=0; %baud frequency offset ratio
m.pNoiseVar=0;
m.TVChan=0;
m.alpha=0;
m.g=.25;
m.c=1;
m.scrambleFlag=0;
m.codingFlag=1;
m.OverSamp=4;

recSigSt=qamTx(m,specs);
[t,z,c,r]=qpskRx(b,recSigSt)

%t=gaussian approximation SER
%z=measured SER before decoding
%c=measured SER after decoding
%r=measured mse (used in gaussian approximation)
