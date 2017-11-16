% corrvsconv.m: "correlation" vs "convolution"
h=[1 -1 2 -2 3 -3];                  % define sequence h[k]
x=[1 2 3 4 5 6 -5 -4 -3 -2 -1];      % define sequence x[k]
yconv=conv(x,h)                      % convolve x[k]*h[k]
ycorr=xcorr(h,fliplr(x))             % correlation of flipped x and h
check=max(abs([yconv, zeros(1,length(ycorr)-length(yconv))]-ycorr))

