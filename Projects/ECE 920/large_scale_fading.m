%% Large_scale_fading.m
%
% Jordan R. Smith
% ECE 920 - Wireless Communication Systems
%
% If the Pr(d) at a reference d0 of 1 km is equal to 1 microWatt, find the
% received powers at distances of 2 km, 5 km, 10 km, and 20 km from the
% same transmitter for the following path loss models:
%
% (a) free space.
% (b) n = 3.
% (c) n = 4.
% (d) two ray ground reflection using the exact expression.
% (e) extended Hata model for a large city environment.
%
% Assume f = 1800 MHz, ht = 40m, hr = 3m, Gt = Gr = 0 dB. Plot each of
% these models on the same graph over the range of 1 km to 20 km. Comment
% on the differences between these five models.
%
% NOTES:
% 0 dB = 1 linear. Free Space Propogation Model in (4.1). Fraunhofer
% distance not specified. 1 microwatt is equivalent to -30 dBm.
% Pr(d) dBm = 10*log10( Pr(d0) / .001 W) + 20log10(d0/d), Pr(d0) in watts.

clear all, close all, clc;

%Known Values
c = 2.99e8;                     % speed of light
f = 1800e6;                     % frequency (1800 MHz)
ht = 40;                        % 40 meter ground reflect Tx height
hr = 3;                         % 3 meter ground reflection Rx height
Gt = 1;                         % transmitter gain (0 dB) or 1 linear.
Gr = Gt;                        % receiver gain (0 dB)
lambda = c/f;                   % wavelength
x = [1e3 2e3 5e3 10e3 20e3];    % distance array for plotting.
Prd0 = 1e-6;                    % 1 * 10^-6 W, or 1 microwatt.
d0 = 1e3;                       % reference distance.

%% Free Space & Varying Path Loss Exponent
%
% Utilizing Equation 4.8
% Pr = Pr(d0)(d0/d)^n, where Pr(d0) = 10^-6 W = -30 dBm, d0 = 1000.
%
% For n=3 and n=4, modify the exponential in 4.8.
for i=1:5
   fs_linear(1,i) = Prd0 * (( 1e3 / (x(1,i)) )^2);
   fs_dBm(1,i) = 10*log10((fs_linear(1,i))/.001);
end

for i=1:5   % n = 3
   fs3_linear(1,i) = Prd0 * (( 1e3 / (x(1,i)) )^3);
   fs3_dBm(1,i) = 10*log10((fs3_linear(1,i))/.001);
end 

for i=1:5   % n = 4
   fs4_linear(1,i) = Prd0 * (( 1e3 / (x(1,i)) )^4);
   fs4_dBm(1,i) = 10*log10((fs4_linear(1,i))/.001);
end

%% Extended Hata Model
%
% In 4.10.5, the model is extended to include frequencies upwards of 2 GHz.
% large city environment indicates 3 dB for CM. Need to refer to d in terms
% of km, and not m. fc is in terms of MHz.
%
% L50 = 46.3 + 33.9*log10(fc) - 13.82*log10(ht) - A + (44.9 -
% 6.55*log10(ht))*log10(d) + CM. (dB)
%
% A = 3.2*(log10(11.75*hr))^2 - 4.97 (dB) from Eq. 4.84b.
%
% Eq. 4.69b indicates
% Pr(d) [dBm] = Pt[dBm] - PL(d)[dB]
%
% Eq. 4.68 dictates that
% PL [dB] = PL(d0) + 10nlog10(d/d0)
%
% Are we to determine the transmitted power from the free-space model, or
% determine Pt for each model?

fc = 1800;          %change to MHz reference units.
x2 = [1 2 5 10 20]; %change to km reference units.
CM = 3;

A = 3.2*((log10(11.75*hr))^2) - 4.97;   % fc >= 300 MHz

for w = 1:5 % determines the path loss with the Extended Hata Model.
    L50(1,w) = 46.3 + 33.9*log10(fc) - 13.82*log10(ht) - A + (44.9 - 6.55*log10(ht))*log10(x2(1,w)) + CM;
end


for h = 1:5
   Pr_L50(1,h) = -30 - (L50(1,h) - L50(1,1)); 
end

%% Two Ray Ground Reflection Model Using Exact Expression
%
% Pr(d0) = Pt Gt Gr (lambda)^2 / (4pi)^2 d0^2.
%
% For Two Ray Ground reflection, theta sub delta needs to be calculated for
% each distance, utilizing the heights of the transmitter and receiver.
% Combining Equations 4.41 and 4.42,
%
% (2*ht*hr)/d * (2*pi)/(lambda) = theta_delta.
%
% Utilizing the theta calculated, and Equation from Problem 4.12
%
%          Pt*Gt*Gr*(lambda^2)
% Pr =  ------------------------- * 4 * sin^2(theta/2)
%           (4pi)^2 * d^2
%

Pt = (Prd0 * ((4*pi)^2) * d0^2) / (lambda^2);
Pt_dBm = 10*log10(Pt/.001);

for i=1:5   % theta_delta values (radians)
   theta(1,i) = ((2*ht*hr)/(x(1,i))) * ((2*pi)/(lambda)); 
end

for j=1:5   % received power
    gr(1,j)=((Pt*Gt*Gr*(lambda^2))/(((4*pi)^2)*((x(1,j))^2)))* 4 * (sin(theta(1,j)/2)^2);
    Pr_gr(1,j) = 10*log10((gr(1,j))/.001);
    
    % Equation 4.52
    gr2(1,j) = Pt * (((ht^2)*(hr^2))/((x(1,j))^4));
    Pr_gr2(1,j) = 10*log10((gr2(1,j))/.001);
end

%% Plot the different Path Loss Models
%
% Plotting each, with a legend to indicate each Pr(d).

figure(1)
hold on
plot(x,fs_dBm,'b-d');
plot(x,fs3_dBm,'r-^');
plot(x,fs4_dBm,'b:o');
plot(x,Pr_gr,'r--s');
plot(x,Pr_L50,'b-.*');
legend('P_r Free Space','P_r n = 3','P_r n = 4',...
    'P_r Two Ray Ground Reflection','P_r Extended Hata Model');
legend('Location','SouthWest');
grid;
title('Received Power P_r with Varying Path Loss Models');
xlabel('Distance (m)');
ylabel('P_r(d) (dBm)');
hold off