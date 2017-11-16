% switchsin.m spectrum of a switched sine
Td=1;                          % pulse width [-Td/2,Td/2]
N=1024;                        % number of data points
f=10;                          % frequency of sine
T=8;                           % total time window
trez=T/N; frez=1/T;            % time and freq. resolution
w=zeros(1,N);                  % vector for full data record
w(N/2-Td/(trez*2)+1:N/2+Td/(2*trez))=sin(trez*(1:Td/trez)*2*pi*f);
dftmag=abs(fft(w));            % magnitude of spectrum of w
spec=trez*[dftmag((N/2)+1:N),dftmag(1:N/2)];
ssf=frez*[-(N/2)+1:1:(N/2)];   % frequency vector
speczoom=trez*[dftmag((3*N/4)+1:N),dftmag(1:N/4)];
ssfzoom=frez*[-(N/4)+1:1:(N/4)];
subplot(2,2,1)                 % plot (a): time waveform
plot(trez*[-length(w)/2+1:length(w)/2],w,'-');
xlabel('time/seconds'), title('(a) Switched Sinusoid')
subplot(2,2,2)                 % plot (b): raw DFT data
plot(dftmag,'-');
xlabel('bin number'), title('(b) raw DFT magnitude')
subplot(2,2,3)                 % plot (c): spectrum
plot(ssf,spec,'-');
xlabel('frequency/Hz')
title('(c) Magnitude spectrum')
subplot(2,2,4)                 % plot (d): zoom on spectrum
plot(ssfzoom,speczoom,'-');
xlabel('frequency/Hz')
title('(d) Zoom into magnitude spectrum')
