% pulsespec.m: spectrum of a pulse shape
N=1000; m=pam(N,4,5);        % 4-level signal of length N
M=10; mup=zeros(1,N*M);      % oversampling factor
mup(1:M:N*M)=m;              % oversample by M
ps=hamming(M);               % blip pulse of width M
x=filter(ps,1,mup);          % convolve pulse shape with data

t=1/M:1/M:length(x)/M;
subplot(3,1,1), plot(0:0.1:0.9,ps)
ylabel('(a) the pulse shape')
xlabel('one sample period')
[h,w]=freqz(ps);
subplot(3,1,2),	semilogy(w/pi,abs(h))
ylabel('(b) spectrum of the pulse shape')
xlabel('normalized frequency')
fftx=abs(fft(x));
subplot(3,1,3), semilogy(2*(1:length(fftx)/2)/length(fftx),fftx(1:length(fftx)/2))
ylabel('(c) spectrum of the waveform')
xlabel('normalized frequency')



t=1/M:1/M:length(x)/M;
subplot(2,1,1), plot(0:0.1:0.9,ps)
ylabel('(a) the pulse shape')
xlabel('one sample period')
[h,w]=freqz(ps);
fftx=abs(fft(x));
subplot(2,1,2), semilogy(2*(1:length(fftx)/2)/length(fftx),fftx(1:length(fftx)/2))
ylabel('(c) spectrum of the waveform')
xlabel('normalized frequency')
