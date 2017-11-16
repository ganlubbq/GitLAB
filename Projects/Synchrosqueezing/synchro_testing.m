%% synchrosqueezing_testing.m
%
% Utilizing the Synchrosqueeze Wavelet Toolbox provided through the ASTRE
% resource page. This code is based off the work of Daubechies, developing
% a wavelet decomposition approach with EMD influences.
%
% [1] I. Daubechies, J. Lu, and H.-T. Wu, "Synchrosqueezed wavelet
% transforms: An empirical mode decomposition-like tool", Applied and
% Computational Harmonic Analysis, 2010.

%Several quick examples illustrating how the toolbox functions are used
%Uncomment each set of lines to use them

clear all, close all, clc;

%x is the signal
%xNew is the inverted (reconstructed) signal
t=linspace(0,10,2000);
x=cos(2*pi*(0.1*t.^2.6+3*sin(2*t)+10*t)) + exp(-0.2*t).*cos(2*pi*(40+t.^1.3).*t);
x=x(:);
dt=t(2)-t(1);


%various options and parameters
CWTopt=struct('gamma',eps,'type','morlet','mu',6,'s',2,'om',0,'nv',64,'freqscale','linear');
STFTopt=struct('gamma',eps,'type','gauss','mu',0,'s',0.05,'om',0,'winlen',256,'squeezing','full');


%Short-time Fourier transform (STFT)

[Sx,fs,dSx] = stft_fw(x, dt, STFTopt);
xNew = stft_iw(Sx, fs, STFTopt).';
tplot(Sx, t, fs); colorbar; title('STFT','FontSize',14); xlabel('Time (seconds)','FontSize',14); ylabel('Frequency (hz)', 'FontSize',14);
figure(); plot(t,[x,xNew]); title('Inverse STFT Signal');

% STFT Synchrosqueezing transform

[Tx, fs, Sx, Sfs, Sw, dSx] = synsq_stft_fw(t, x, STFTopt);	
xNew = synsq_stft_iw(Tx, fs, STFTopt).';
figure(); tplot(Tx, t, fs); colorbar; title('STFT Synchrosqueezing','FontSize',14); xlabel('Time (seconds)','FontSize',14); ylabel('Frequency (hz)', 'FontSize',14);
figure(); plot(t,[x,xNew(:,1)]); title('Inverse Synchrosqueezing Signal');

