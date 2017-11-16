% openclosed.m draw eye diagrams
b=[0.4 1 -0.2];             % define channel
m=1000; s=sign(randn(1,m)); % binary input of length m
r=filter(b,1,s);            % output of channel
y=sign(r);                  % quantization
for sh=0:5                  % error at different delays
  err(sh+1)=0.5*sum(abs(y(sh+1:m)-s(1:m-sh)));
end
err
subplot(2,1,1), plot(r,'b.')
title('eye is open for the channel [0.4 1 -0.2]')
ylabel('amplitude')

b=[0.5 1 -0.6];
r=filter(b,1,s);
y=sign(r);
subplot(2,1,2), plot(r,'b.')
title('eye is closed for the channel [0.5 1 -0.6]')
ylabel('amplitude')
xlabel('symbol number')
for sh=0:5  % error at different delays
  err2(sh+1)=0.5*sum(abs(y(sh+1:m)-s(1:m-sh)));
end
err2
