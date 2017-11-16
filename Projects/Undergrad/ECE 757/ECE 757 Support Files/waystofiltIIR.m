% waystofiltIIR.m implementing IIR filters

a=[1 -0.8]; lena=length(a)-1;       % autoregressive coefficients
b=[1]; lenb=length(b);              % moving average coefficients
d=randn(1,20);                      % data to filter
if lena>=lenb                       % dimpulse requires lena>=lenb
  h=impz(b,a);                      % impulse response of filter
  yfilt=filter(h,1,d)               % filter x[k] with h[k]
end
yfilt2=filter(b,a,d)                % filter directly using a and b
y=zeros(lena,1); x=zeros(lenb,1);   % initial states in filter
for k=1:length(d)-lenb              % time domain method
  x=[d(k);x(1:lenb-1)];             % past values of inputs
  ytim(k)=-a(2:lena+1)*y+b*x;       % directly calculate y[k]
  y=[ytim(k);y(1:lena-1)];          % past values of outputs
end
ytim
