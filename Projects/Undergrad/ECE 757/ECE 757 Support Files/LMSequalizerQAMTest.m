% LMSequalizerQAMTest.m test routine
% First run  LMSequalizerQAM.m to set channel b
% and equalizer f
finaleq=f;                   % test final filter f
m=1000;                      % new data points
s=pam(m,2,1)+j*pam(m,2,1);   % new 4-QAM source of length m
r=filter(b,1,s);             % output of channel
yt=filter(f,1,r);            % use final filter f to test
dec=sign(real(yt))+j*sign(imag(yt));  % quantization
for sh=0:n                   % if equalizer working, one
  err(sh+1)=0.5*sum(abs(dec(sh+1:end)-s(1:end-sh)));
end                          % of these delays = zero error
err

[hb,w]=freqz(b,1,1024,'whole');
[hf,w]=freqz(f,1,1024,'whole');
[hc,w]=freqz(conv(b,f),1,1024,'whole');
semilogy(w,abs(hb))
hold on
semilogy(w,abs(hf),'r')
semilogy(w,abs(hc),'g')
semilogy(w,abs(hb).*abs(hf),'k')
hold off
