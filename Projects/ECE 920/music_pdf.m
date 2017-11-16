clc
clear all
format long %The data show that as long shaping scientific
doa=[45 50]/180*pi; %Direction of arrival
N=200;%Snapshots
w=[pi/2 -pi/2]';%Frequency
M=10;%Number of array elements
P=length(w); %The number of signal
lambda=150;%Wavelength
d=lambda/2;%Element spacing
snr=20;%SNA
D=zeros(P,M); %To creat a matrix with P row and M column
for k=1:P
D(k,:)=exp(-j*2*pi*d*sin(doa(k))/lambda*[0:M-1]); %Assignment matrix
end
D=D';
xx=2*exp(j*(w*[1:N])); %Simulate signal
x=D*xx;
x=x+awgn(x,snr);%Insert Gaussian white noise
R=x*x'; %Data covarivance matrix
[N,V]=eig(R); %Find the eigenvalues and eigenvectors of R
NN=N(:,1:M-P); %Estimate noise subspace
theta=-90:0.5:90; %Peak search
for ii=1:length(theta)
SS=zeros(1,length(M));
for jj=0:M-1
 SS(1+jj)=exp(-j*2*jj*pi*d*sin(theta(ii)/180*pi)/lambda);
end
PP=SS*NN*NN'*SS';
Pmusic(ii)=abs(1/ PP);
end
Pmusic=10*log10(Pmusic/max(Pmusic)); %Spatial spectrum function
plot(theta,Pmusic,'-k')
xlabel('angle \theta/degree')
ylabel('spectrum function P(\theta) /dB')
title('DOA estimation based on MUSIC algorithm ')
grid on