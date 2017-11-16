% pllpreprocess.m: send received signal through square and BPF
r=rsc;                            % suppressed carrier r
q=r.^2;                           % square nonlinearity
fl=500; ff=[0 .38 .39 .41 .42 1]; % BPF center frequency at .4
fa=[0 0 1 1 0 0];                 % which is twice f_0
h=firpm(fl,ff,fa);                % BPF design via firpm
rp=filter(h,1,q);                 % filter gives preprocessed r

% pllpreprocess.m: recover "unknown" freq and phase using FFT
fftrBPF=fft(rp);                     % spectrum of rBPF
[m,imax]=max(abs(fftrBPF(1:end/2))); % find freq of max peak
ssf=(0:length(rp))/(Ts*length(rp));  % frequency vector
freqS=ssf(imax)                      % freq at the peak
phasep=angle(fftrBPF(imax));         % phase at the peak
[IR,f]=freqz(h,1,length(rp),1/Ts);   % freq response of filter
[mi,im]=min(abs(f-freqS));           % freq where peak occurs
phaseBPF=angle(IR(im));              % < of BPF at peak freq
phaseS=mod(phasep-phaseBPF,pi)       % estimated angle
