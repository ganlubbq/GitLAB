% qamconstants.m:  Calculate constants for avg{x1 x2 x3 x4}
N=2000; M=50;                    % # of symbols, oversample M
s1=pam(N,2,1); s2=pam(N,2,1);    % real 2-level signals
mup1=zeros(1,N*M); mup2=zeros(1,N*M); 
mup1(1:M:end)=s1;                % zero pad T-spaced sequence
mup2(1:M:end)=s2;                % oversample by M
unp=hamming(M);                  % unnormalized pulse shape
p=sqrt(M)*unp/sqrt(sum(unp.^2)); % normalized pulse shape
m1=filter(p,1,mup1);             % convolve pulse shape & data
m2=filter(p,1,mup2);             % convolve pulse shape & data
sterm=sum((m1.^4)-6*(m1.^2).*(m2.^2)+(m2.^4))/(N*M)
cterm=sum(4*m1.*m2.^3-4*m1.^3.*m2)/(N*M)
