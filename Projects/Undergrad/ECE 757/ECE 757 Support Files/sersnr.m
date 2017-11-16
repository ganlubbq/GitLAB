% sersnr: ser as a function of snr and M

snr=[1:5:500];
M=[4 16 64 256];
for Mind=1:length(M)
  for snrind=1:length(snr)
    yo=1-(1/sqrt(M(Mind)));
    efa=sqrt(3*snr(snrind)/(2*(M(Mind)-1)));
    ser(Mind,snrind)=1-(1-yo*erfc(efa))^2;
  end
end
semilogy(10*log10(snr),ser')
ylabel('SER')
xlabel('SNR in dB')
