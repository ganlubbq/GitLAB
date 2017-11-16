% waystofilt.m "conv" vs "filter" vs "freq domain" vs "time domain"
h=[1 -1 2 -2 3 -3];                       % impulse response h[k]
x=[1 2 3 4 5 6 -5 -4 -3 -2 -1];           % input data x[k]
yconv=conv(h,x)                           % convolve x[k]*h[k]
yfilt=filter(h,1,x)                       % filter x[k] with h[k]
n=length(h)+length(x)-1;                  % pad length for FFT
ffth=fft([h zeros(1,n-length(h))]);       % FFT of impulse response = H[n]
fftx=fft([x, zeros(1,n-length(x))]);      % FFT of input = X[n]
ffty=ffth.*fftx;                          % product of H[n] and X[n]
yfreq=real(ifft(ffty))                    % IFFT of product gives y[k]
                                          %   which is complex due to roundoff
z=[zeros(1,length(h)-1),x];               % initial state in filter = 0
for k=1:length(x)                         % time domain method
  ytim(k)=fliplr(h)*z(k:k+length(h)-1)';  % iterates once for each x[k]
end                                       % to directly calculate y[k]
ytim
