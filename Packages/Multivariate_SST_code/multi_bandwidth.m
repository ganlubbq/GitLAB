function  [band,power]=multi_bandwidth(x);

%estimation of the multivariate bandwidth 


 [m,n]=size(x);
 
 for i=1:n  %channel index n 
     temp=fft(x(:,i));
     X(:,i)=temp(1:floor(m/2));  %the analtic multichannl fourier transform
 end
 
 %total energy of the multivairate signal
 ep_x=sum(sum(X.*conj(X),2))/(2*pi);
 
 %the normalized average spectra of the multichannl fourier coefficients.
 S_x=(sum(X.*conj(X),2))/ep_x;
 
 %average frequency for the multichannel fourier coefficeint.
 x_m=sum(sum(2*pi*linspace(0,0.5,floor(m/2)).*S_x'))/(2*pi);
 
 
 %the bandwidth 
band= sum((((linspace(0,0.5,floor(m/2))*2*pi)-x_m).^2).*S_x')/(2*pi);
band_norm=sum(sum(abs(x).*abs(x),2))*band;
power=sum(sum(abs(x).*abs(x),2));
 
 