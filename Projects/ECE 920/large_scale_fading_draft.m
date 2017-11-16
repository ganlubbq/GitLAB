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

%% Free space Model & varying "n" values.
%
% Pr(d) dBm = 10*log10( Pr(d0) / .001 W) + 20log10(d0/d), Pr(d0) in watts.

for i = 1:5     % progresses through distance array, starting with d0.
  fs(1,i) = Prd0 * ( d0 / (x(1,i)) )^2;
  fs_dBm(1,i) = 10*log10( fs(1,i) / .001 );
  
  % From equation 4.6
  fs_PL(1,i) = -10*log10((Gt*Gr*((lambda)^2))/(((4*pi)^2)*((x(1,i))^2)));
  fs_PL_linear(1,i) = 10^((fs_PL(1,i))/10); %convert dB to linear
  fs_PL_dBm(1,i) = 10*log10((fs_PL_linear(1,i))/.001);  %linear to dBm
end


% Reference -30 dBm starting point

Xfs = fs_PL_dBm(1,1) - 30;

for i = 1:5
   Pr_fs_dBm(1,i) = Xfs - fs_PL_dBm(1,i);   % Power - path loss. 
end

% Utilizing Equation 4.9, which had originally utilized n = 2 for the free
% space example.

for j = 1:5     % n = 3. Modifies the multiplier in the second term.
  fs3(1,j) = 10*log10( Prd0 / .001 ) + 30*log10( d0 / (x(1,j)) );
end

for k = 1:5     % n = 4. More rapid decrease per decade.
  fs4(1,k) = 10*log10( Prd0 / .001 ) + 40*log10( d0 / (x(1,k)) );
end

%% Two Ray Ground Reflection Using The Exact Expression
%
% Start with Equation 4.15, and refer to Example 4.6 for further
% reproduction.
% Pr(d) = Pt Gt Gr (ht^2 hr^2)/d^4.
% Pr(d) dBm = 10*log10( Pr(i) / .001 )
%
% |E| = sqrt( (Pr(d) * 120pi)/(Ae) ), Ae = (Gr lambda^2) / 4*pi.
% Pr(d) = |E|^2 / 377
%
% A reference electric field is not known (E0), the
% transmitted power is not given, and if |E| is utilized, ht and hr aren't
% factored into the calculation.

for v = 1:5
   % From equation 4.53 - computes Path Loss.
   gr_PL(1,v) = 40*log10(x(1,v)) - (10*log10(Gt) + 10*log10(Gr) + 20*log10(ht) + 20*log10(hr));
   gr_linear(1,v) = 10^((gr_PL(1,v))/10);
   gr_PL_dBm(1,v) = 10*log10((gr_linear(1,v))/.001);
end

    Xgr = gr_PL_dBm(1,1) - 30;   % Reference at -30 dBm point.

for v = 1:5
   Pr_gr_dBm(1,v) = Xgr - gr_PL_dBm(1,v);  %Gain not included due to 0 dB. 
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
    L50_dB(1,w) = 46.3 + 33.9*log10(fc) - 13.82*log10(ht) - A + (44.9 - 6.55*log10(ht))*log10(x2(1,w)) + CM;
    L50_linear(1,w) = 10^((L50_dB(1,w))/10);    % linear conversion.
    L50_dBm(1,w) = 10*log10((L50_linear(1,w))/.001);    % dBm conversion.
end

X = L50_dBm(1,1) - 30; % Need reference starting point at -30 dBm.

for r = 1:5 % Power received for Hata Model.
   Pr_L50_dBm(1,r) = X - L50_dBm(1,r); 
end

figure(1)
hold on
plot(x,Pr_fs_dBm,'b-d');
plot(x,fs3,'r-^');
plot(x,fs4,'r:o');
plot(x,Pr_L50_dBm,'b--s');
plot(x,Pr_gr_dBm,'r--*');
legend('Free Space P_r','n = 3 P_r','n = 4 P_r','P_r Extended Hata Model','P_r Ground Reflection');
legend('Location','SouthWest');
title('Received Power P_r(d) with Varying Path Loss Models');
xlabel('distance (km)');
ylabel('P_r (dBm)');
grid;