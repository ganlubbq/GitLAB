function    [Tf,freq,Tw]=sst_wavelet_linear(W,dw,a,nv,x)

%implemented from  the following work:
%G. Thakur, E. Brevdo, N.S. Fukar, and H-T. Wu, "The Synchrosqueezing algorithm for time-varying spectral analysis: 
%robustness properties and new paleoclimate applications," Submitted, 2012.
%I. Daubechies, J. Lu, and H.-T. Wu, "Synchrosqueezed wavelet transforms: 
%An empirical mode decomposition-like tool," Applied and Computational Harmonic Analysis, 2010.


%%
%initilisation
[na,N]=size(W);
l1=linspace(0,na-1,na);


freq = 2*pi*linspace(0,0.5,floor(N/2)+1);

nfreq = length(freq);

freq=freq/(2*pi);
df = freq(2) - freq(1);
Tf = zeros(nfreq,N);

%Tf=zeros(na,N);
deltaw=(1/(na-1))*log2(N/2);
w=1/(N);
j=1:na;      %the total number of scales.
aj=(2.^(j/nv));
wl=2.^(l1*deltaw)*w;
for j=1:na
    for m=1:N
if dw(j,m)<0

else
 l = ceil(dw(j,m)/df+0.5);
 if l>0 && l<=nfreq  && isfinite(l) 
      Tf(l,m)=Tf(l,m)+W(j,m)/sqrt(a(j));
      Tw(l,m)=dw(j,m);
 end
end
    end
end


 norm=var(real(sum(Tf,1)))/var(x);
 Tf=Tf/sqrt(norm);
%Tf=(Tf/(2*1.52)/  0.9325)/0.2903;

