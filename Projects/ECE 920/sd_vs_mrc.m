%% Selection Diversity vs. Maximal Ratio Combining
%
% Function call and plotting.
close all, clear all, clc;

spatial_diversity = [sdc_a(1), sdc_a(2), sdc_a(3), sdc_a(4), sdc_a(5), sdc_a(6)];
spatial_diversity_dB = [sdc_b(1), sdc_b(2), sdc_b(3), sdc_b(4), sdc_b(5), sdc_b(6)];
maximal_diversity = [1, 2, 3, 4, 5, 6];
maximal_diversity_dB = [10*log10(1), 10*log10(2), 10*log10(3), 10*log10(4), 10*log10(5), 10*log10(6)];

t = 1:1:6;
figure(1)
subplot(2,1,1)
plot(t,spatial_diversity,'b--o',t,maximal_diversity,'r-.d');
grid;title('Average SNR \gamma / \Gamma as a function of M branches');
legend('Spatial Diversity','Maximal Ratio Combining','Location','NorthWest');
ylabel('SNR [linear]');
ylim([0 6]);

subplot(2,1,2)
plot(t,spatial_diversity_dB,'b--o',t,maximal_diversity_dB,'r-.d');
grid;xlabel('Branches (M)');ylabel('SNR [dB]');
ylim([0 8]);

syms k x

S1 = symsum( ( (0.01^(k-1))/(factorial(k-1)) ),1,6)


function snr = sdc_a(M)
for i = 1:M
    a(i) = 1/i;
end
snr = sum(a,2);
end

function snr = mrc_b(M)
snr = M;
end

function snr = sdc_b(M)
for i = 1:M
    a(i) = 1/i;
end
snr = sum(a,2);
snr = 10*log10(snr);
end

