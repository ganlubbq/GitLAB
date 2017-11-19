% plot_Ray_Ric_channel.m
clear, clf
N=200000; level=30; K_dB=[-40 15];
gss=['k-s'; 'b-o'; 'r-^'];
% Rayleigh model
Rayleigh_ch=Ray_model(N);
[temp,x]=hist(abs(Rayleigh_ch(1,:)),level);
plot(x,temp,gss(1,:)), hold on
% Rician model
for i=1:length(K_dB);
Rician_ch(i,:) = Ric_model(K_dB(i),N);
[temp x] = hist(abs(Rician_ch(i,:)),level);
plot(x,temp,gss(i+1,:))
end
xlabel('x'), ylabel('Occurrence')
legend('Rayleigh','Rician, K=-40dB','Rician, K=15dB')

function H=Ray_model(L)
% Rayleigh channel model
% Input : L = Number of channel realizations
% Output: H = Channel vector
H = (randn(1,L)+j*randn(1,L))/sqrt(2);
end

function H=Ric_model(K_dB,L)
% Rician channel model
% Input : K_dB = K factor[dB]
% Output: H = Channel vector
K = 10^(K_dB/10);
H = sqrt(K/(K+1)) + sqrt(1/(K+1))*Ray_model(L);
end