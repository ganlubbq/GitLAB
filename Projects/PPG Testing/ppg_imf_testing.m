%% ppg_imf_testing.m
%
% This script utilizes the test data provided by [1]. Several .mat files
% are available within the .zip file, all being 8 minute durations. EMD
% application will be applied to see how different "flavors" may perform,
% including Ensemble or Bivariate EMD.
%
% NOTES: If an IMF needs to be removed, imf(row#,:) = []; 480 seconds of
% samples, 144001 / 480 ~= 300 samples per second. For a 15 second window,
% approximately 4500 samples will work. 144,000 samples is a significant
% computational overhead, having a system that can run EMD in parallel
% would be beneficial.
%
% [1]BENCHMARK data for RR estimation from the Photoplethysmogram used in 
%  W. Karlen, S. Raman, J. M. Ansermino, and G. A. Dumont, “Multiparameter 
% respiratory rate estimation from the photoplethysmogram,” 
% IEEE transactions on bio-medical engineering,vol. 60, no. 7, pp. 1946–53, 
% 2013. DOI: 10.1109/TBME.2013.2246160 
% PMED: http://www.ncbi.nlm.nih.gov/pubmed/23399950
%
% [2]http://www.capnobase.org/database/pulse-oximeter-ieee-tbme-benchmark/

clear all, close all, clc;

S = load('0009_8min.mat');      % Other files avaiable, Add folder to path.
ppg = S.signal.pleth.y.';       % Signal is the reference collected data.
co2 = S.signal.co2.y.';         % Breathing Rate
ecg = S.signal.ecg.y.';         % Electrocardiogram

t1 = 1;                         % 0 second mark
t2 = 4500-1;                    % 1 min = 18000 (~4500 is 15 seconds)

ppg_frac = ppg(1,t1:t2);        % Windowed Data
co2_frac = co2(1,t1:t2);
ecg_frac = ecg(1,t1:t2);


SFx = S.SFresults.x;            % Results from IEEE paper.
RIFV = S.SFresults.RIFV.y;
RIAV = S.SFresults.RIAV.y;
RIIV = S.SFresults.RIIV.y;

dev = std(ppg_frac);            % Standard Deviation of PPG.



%%
% randn - multiply by the specified std. dev. (sigma), and then add a
% specified value that will be evaluated as the mean.

noise = dev*randn(size(ppg_frac,2),1)';

nppg_frac = ppg_frac + noise;   % Fraction of PPG with noise contamination.

tic                             % start EMD timing
imf_ppg = emd(ppg_frac);        % Rollins EMD script, validated 2013.
toc                             % end EMD timing.

[r_ppg,c_ppg] = size(imf_ppg);  % Size variables for IMF plotting.

Fs = 300;                       % Fs - indicated in S.param.
L = c_ppg;                      % length of signal
T = 1/Fs;                       % sampling period
t = (0:L-1)*T;                  % Time vector
dim = 2;                        % row by column matrix dimensions.
n = 2^nextpow2(L);              % zero-padding FFT.
Y = fft(imf_ppg,n,dim);         % FFT application.
P2 = abs(Y/n);                  % Double/single sided Spectrums.
P1 = P2(:,1:n/2+1);
P1(:,2:end-1) = 2*P1(:,2:end-1);


%% Pricipal Component Analysis
%
% IMF's with artifacts are to be removed - first PC indicates cardiac
% activity, whereas the 2nd PC represents the breathing frequency, both
% requiring an FFT to visualize the power spectral density. Based on the
% EEMD-PCA methodology intended to extract respiratory activity as well.

pca_coeffs = pca(imf_ppg);


[r_pca c_pca] = size(pca_coeffs);

index = 2;
L_pca = r_pca;
t_pca = (0:L_pca-1)*T;
n_pca = 2^nextpow2(L_pca);
Y_pca = fft(pca_coeffs(:,index),n_pca);       % FFT
f_pca = Fs*(0:(n_pca/2))/n_pca;
P_pca = abs(Y_pca/n_pca);

figure(17)
plot(f_pca,P_pca(1:n_pca/2+1))
title(['PCA(',num2str(index),') FFT of EMD IMF']);grid;
xlabel('Frequency(Hz)');xlim([0 10]);
ylabel(['FFT\{PCA_{',num2str(index),'}\}']);


%% FFT & Power Spectral Density
%
% This section will plot the FFT and apply the periodogram function for PSD
% estimation. May need to use the exact AR model present within the
% IEEE conference paper. Utilizes Function at end of script.
% Welch plot arguments are IMF number, IMF vector, and figure number.
% IMF's 7 through 12 (discarding 1 through 6 and the residual), are kept
% and reformed, with an FFT applied to see the spectral energy of the
% reconstructed signal. This ought to indicate the breathing rate spectral
% density as well as the heart rate spectral density. Multiply Hz component
% by 60 for breathes/min and beats/min.

welch_plot(6,imf_ppg,10);
welch_plot(7,imf_ppg,11);
welch_plot(3,imf_ppg,12);


imf_reconstruction = imf_ppg(6:9,:);
new_signal = sum(imf_ppg);

figure(13)
Yf = fft(new_signal,n,dim);
Pf2 = abs(Yf/n);
Pf1 = Pf2(:,1:n/2+1);
Pf1(:,2:end-1) = 2*Pf1(:,2:end-1);
plot(0:(Fs/n):(Fs/2-Fs/n),Pf1(1,1:n/2)),grid;
title('Reconstructed Signal FFT');xlim([0 10]);
xlabel('Frequency (Hz)');

%% Plotting Imported Signals
%
% Prevents recalculation of previous section's EMD algorithm. Plot the PPG
% signal with limited window to observe PPG, and view varying IMF's.


% Original Signals - Fractional period of 15 seconds.

figure(2)   % Plot PPG and Actual Breathing Rate.
subplot(3,1,1)
plot(t,ppg_frac);
title('Photoplethysmography (PPG) Signal');xlabel('Time(s)');
ylim([-11 11]);
grid;
subplot(3,1,2)
plot(t,co2_frac);
title('Breathing Rate (CO_2) Signal');xlabel('Time(s)');
ylim([0 10]);
grid;
subplot(3,1,3)
plot(t,ecg_frac);
title('Electrocardiogram (ECG) Signal');xlabel('Time(s)');
ylim([-14 14]);
grid;

% Overlay Respiratory Rate on PPG.
co2_comp = co2_frac - 4.44;             % shift in Y-direction for overlay.
figure(3)
hold on
plot(t,ppg_frac,'b',t,co2_comp,'r');
grid;
title('PPG and C0_2 Signals Overlay');

% SF Results. SFx, RIFV, RIAV, RIIV.
figure(4)
subplot(3,1,1)
plot(RIFV);grid;title('RIFV');
subplot(3,1,2)
plot(RIAV);grid;title('RIAV');
subplot(3,1,3)
plot(RIIV);grid;title('RIIV');

%% Plotting IMF & Periodogram Function
%
% num indicates the set of three IMF's to plot. X is the original set of 
% IMFs, Y is the Periodogram, and vrc is the noise variance.

function period_plot(num,X,vrc,fig_num)

    for i=1:9   % Zero mean gaussian noise
       zgn_imf(i,:) = X(i,:) + sqrt(vrc).*randn(size(X,2),1)'; 
    end
    
    for j=1:9   % Periodogram generation, row oriented.
        [Pxg(j,:),Fxg(j,:)] = periodogram(zgn_imf(j,:),[],...
            length(zgn_imf(j,:)),300);
    end

    figure(fig_num)
    subplot(3,2,1)
    plot(zgn_imf(num,:));grid;title(['GN-IMF ',num2str(num), '']);
    subplot(3,2,2)
    plot(Fxg(num,:),Pxg(num,:));grid;
    title(['Periodogram IMF ',num2str(num), '']);
    xlim([0 3]);   % low frequency signals.
    subplot(3,2,3)
    plot(zgn_imf(num+1,:));grid;title(['GN-IMF ',num2str(num+1),'']);
    subplot(3,2,4)
    plot(Fxg(num+1,:),Pxg(num+1,:));grid;
    title(['Periodogram IMF ',num2str(num+1),'']);
    xlim([0 3]);
    subplot(3,2,5)
    plot(zgn_imf(num+2,:));grid;title(['GN-IMF ',num2str(num+2),'']);
    subplot(3,2,6)
    plot(Fxg(num+2,:),Pxg(num+2,:));grid;
    title(['Periodogram IMF ',num2str(num+2),'']);
    xlim([0 3]);
end

%% Welch Method Plotting
%
% Row orientation.
function welch_plot(num,X,fig_num)
    
    [r c] = size(X);
    
    for j=1:r   % PWelsh Method generation, row oriented.
        [Pxg(j,:),Fxg(j,:)] = pwelch(X(j,:),[],[],[],300);
    end

    figure(fig_num)
    subplot(3,2,1)
    plot(X(num,:),'k');grid;title(['IMF ',num2str(num), '']);
    
    
    subplot(3,2,2)
    plot(Fxg(num,:),Pxg(num,:),'k');grid;
    title(['Welch Method IMF ',num2str(num), '']);
    xlim([0 5]);
    
    subplot(3,2,3)
    plot(X(num+1,:),'k');grid;title(['IMF ',num2str(num+1),'']);
    
    
    subplot(3,2,4)
    plot(Fxg(num+1,:),Pxg(num+1,:),'k');grid;
    title(['Welch Method IMF ',num2str(num+1),'']);
    xlim([0 5]);
    
    subplot(3,2,5)
    plot(X(num+2,:),'k');grid;title(['IMF ',num2str(num+2),'']);
    
    
    subplot(3,2,6)
    plot(Fxg(num+2,:),Pxg(num+2,:),'k');grid;
    title(['Welch Method IMF ',num2str(num+2),'']);
    xlim([0 5]);
    
end