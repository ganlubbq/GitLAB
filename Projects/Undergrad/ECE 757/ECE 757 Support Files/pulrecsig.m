% pulrecsig.m: create pulse shaped received signal

N=10000; M=20; Ts=.0001;   % # symbols, oversampling factor
time=Ts*N*M; t=Ts:Ts:time; % sampling interval & time vector
m=pam(N,4,5);              % 4-level signal of length N
mup=zeros(1,N*M); 
mup(1:M:N*M)=m;            % oversample by integer length M
ps=hamming(M);             % blip pulse of width M
s=filter(ps,1,mup);        % convolve pulse shape with data
fc=1000; phoff=-1.0;       % carrier freq. and phase
c=cos(2*pi*fc*t+phoff);    % construct carrier
rsc=s.*c;                  % modulated signal (small carrier)
rlc=(s+1).*c;              % modulated signal (large carrier)

fftrlc=fft(rlc);                     % spectrum of rlc
[m,imax]=max(abs(fftrlc(1:end/2)));  % index of max peak
ssf=(0:length(t)-1)/(Ts*length(t));  % frequency vector
freqL=ssf(imax)                      % freq at the peak
phaseL=angle(fftrlc(imax))           % phase at the peak

fftrsc=fft(rsc);                     % spectrum of rsc
[m,imax]=max(abs(fftrsc(1:end/2)));  % find frequency of max peak
freqS=ssf(imax)                      % freq at the peak
phaseS=angle(fftrsc(imax))           % find phase at the peak

