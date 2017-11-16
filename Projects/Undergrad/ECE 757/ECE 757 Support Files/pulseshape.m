% pulseshape.m: applying a pulse shape to a text string
str='Transmit this text string';         % message to be transmitted
m=letters2pam(str); N=length(m);         % 4-level signal of length N
M=10; mup=zeros(1,N*M); mup(1:M:N*M)=m;  % oversample by M
ps=hamming(M);                           % blip pulse of width M
x=filter(ps,1,mup);                      % convolve pulse shape with data

t=1/M:1/M:length(x)/M;
subplot(2,1,1), plot(0:0.1:0.9,ps)
xlabel('The pulse shape')
subplot(2,1,2), plot(t,x)
xlabel('The waveform representing "Transmit this text"')

