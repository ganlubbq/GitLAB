function   [Wt,w1,as,dWt]=cwavelet_transform(x,nv,wavelet)


%x input signal
%nv: voice number typically 32 
%wavelet: type of mother wavelet. 0 or 1. Where 0 is morlet, and 1 is the
%bump wavelet. 
 

%implemented from  the following work:
%G. Thakur, E. Brevdo, N.S. Fukar, and H-T. Wu, "The Synchrosqueezing algorithm for time-varying spectral analysis: 
%robustness properties and new paleoclimate applications," Submitted, 2012.
%I. Daubechies, J. Lu, and H.-T. Wu, "Synchrosqueezed wavelet transforms: 
%An empirical mode decomposition-like tool," Applied and Computational Harmonic Analysis, 2010.

%%

[m1,n1]=size(x);
if m1>n1
    x=x';
end
[m,n]=size(x);

%reflecting boundary coefficient 
t1=fliplr(x);
xn=[t1,x,x];


N=length(xn);
L=floor(log2(N))-1;


 na = L*nv;
 as = 2.^((1:1:na)./nv);
    
 Wt1 = zeros(na, N);
  dWt1= zeros(na, N);
 Xw=fft(xn);
 for i=1:length(as)
     
     
     
     
   if wavelet==0  %morlet wavelet 
        w=as(i)*linspace(0,N-1,N)*2*pi/N;
        mu=2*pi;
        cmu = (1+exp(-mu^2)-2*exp(-3/4*mu^2)).^(-1/2);
        kmu = exp(-1/2*mu^2);
        morlet =cmu*pi^(-1/4)*(exp(-1/2*(mu-w).^2)-kmu*exp(-1/2*w.^2));
        morlet=sqrt(as(i))*morlet;
      
           dmorlet = 2*pi*(1i*w) .* morlet;
            dWt1(i,:)=ifft(dmorlet.*Xw);
         temp = (ifft(abs(morlet) .*Xw));
         Wt1(i, :) = temp;
        temp1=diff(unwrap(angle(Wt1(i,:))))/(2*pi);
       w1(i,:)=temp1';
   else   %bump wavelet 
       w=as(i)*linspace(0,N-1,N)*2*pi/N;
        mu=5;
        si=1;
               bump = exp(-1./(1-(((w-mu)/si).^2))) .* (abs(w)>(mu-si) & abs(w)<(mu+si));

       bump(isnan(bump))=0; 
        bump=sqrt(as(i))*bump;
      
           dbump = 2*pi*(1i*w) .* bump;
            dWt1(i,:)=ifft(dbump.*Xw);
         temp = (ifft(abs(bump) .*Xw));
         Wt1(i, :) = temp;
        temp1=diff(unwrap(angle(Wt1(i,:))))/(2*pi);
       w1(i,:)=temp1';
   end
        
 
 end
 
 
 Wt=Wt1(:,n+1:n+n);
  dWt=dWt1(:,n+1:n+n);
  w1=w1(:,n+1:n+n);
 %   w = imag(dWt ./ Wt / (2*pi));