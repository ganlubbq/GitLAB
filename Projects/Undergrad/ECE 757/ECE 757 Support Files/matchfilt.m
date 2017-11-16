% matchfilt.m: test of SNR maximization
N=2^15; m=pam(N,2,1);                    % 2-PAM signal of length N
M=10; mup=zeros(1,N*M); mup(1:M:N*M)=m;  % oversample by M
L=10; ps=srrc(L,0,M);                    % define pulse shape
ps=ps/sqrt(sum(ps.^2));                  % and normalize
n=0.5*randn(size(mup));                  % noise
g=filter(ps,1,mup);                      % convolve ps with data
recfilt=srrc(L,0,M);                     % receive filter H sub R
recfilt=recfilt/sqrt(sum(recfilt.^2));   % normalize pulse shape
v=filter(fliplr(recfilt),1,g);           % matched filter with data
w=filter(fliplr(recfilt),1,n);           % matched filter with noise
vdownsamp=v(1:M:N*M);                    % downsample to symbol rate
wdownsamp=w(1:M:N*M);                    % downsample to symbol rate
powv=pow(vdownsamp);                     % power in downsampled v
poww=pow(wdownsamp);                     % power in downsampled w
powv/poww                                % ratio


