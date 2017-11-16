% pulseshape2.m: pulse shape a (random) sequence
N=2000; m=pam(N,2,1);      % 2-PAM signal of length N
M=10; mup=zeros(1,N*M);    % oversampling factor
mup(1:M:N*M)=m;            % oversample by M
L=10; ps=srrc(L,0,M);      % sinc pulse shape 2*L symbols wide
sc=sum(ps)/M;              % normalizing constant 
x=filter(ps/sc,1,mup);     % convolve pulse shape with data

%look at the first 20 symbols
y=x(L*M+1:20*M+L*M+1);
t=0:1/M:(length(y)-1)/M;
tps=[-L:1/M:L];

subplot(2,1,1), plot(tps,ps)
title('Using a sinc pulse shape')
subplot(2,1,2),
plot(t,ones(size(y)),'r'); hold on
plot(t,-ones(size(y)),'r');
plot(t,y)
title('pulse shaped data sequence')
xlabel('symbol number')
hold off

