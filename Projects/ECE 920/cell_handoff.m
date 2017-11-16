%% cell_handoff.m
%
% Jordan R. Smith
% ECE 920 - Wireless Communication Systems
%
% Consider an N = 3 Hexagon cluster and find the received power as a
% function of distance from the starting point in cell A to the end point
% in cell C. Utilize the equation for received power:
%
% Pr(d) = E{ Pr(d0) } - 10*n*log10(d/d0)
% E{Pr(d0)} = -20 dBm, n = 4, R = 1 km.
%

clear all, close all, clc;

%Pr(d) Values
E = -20;                % Expected Value at d = 0.
d0 = 500;               % reference collection for E{Pr(d0)} = -20 dBm.
R = 1000;               % Radial length.
n = 4;                  % Path Loss Expoonent.
d = sqrt(3)*R;          % Total Distance from A to C.
edge = d / 2;           % distance to center of cluster from d=0.


xA = 0:d;               % total length, no increment.
xA_C = 0:5:1730;        % 5 meter increments.


%B-distance values
rB_d = sqrt(R^2 + edge^2);  %outermost distance from center B to d=0.


%% Rx Power from A to C
%
% This assumes that d0 is 500m, the first data point being interpretted
% as 500m, no angle. In 1m increments, the Pw loss is determined. A new
% radial distance from BS is determined for each increment.

%determines distance from center A.
for j = 1:length(xA)
   r(1,j) = sqrt(500^2 + (xA(1,j))^2);   
end

%calculates Pr for each interval of radial distance "r".
for i = 1:length(r) 
   yA(1,i) = E - 40*log10((r(1,i))/(d0)); 
end

% If the value is uniform, the Pr from C ought to mirror the Pr of A. The
% intersection of Pr from A ought to be at distance R.
yC = fliplr(yA);

figure(1)
plot(xA,yA,'b');grid;
set(gca,'XAxisLocation','top','YAxisLocation','left');
title('Received Power as a function of distance'),xlabel('Distance (m)');
ylabel('P_r  (dBm)');xlim([0 d]);
legend('P_r from A to C','Location','southwest');

%% 5 meter Increment Plotting

%determines interval from d = 0 to R. Will need to rotate, and append to
%the original finding to reflect the distances from d = 0 to the end of C.

% The for loop will need to reach 865 m, but not go past R. past R will be
% the flipped array, appended to form the complete B-radial matrix for
% received power calculation.

xB_center = 0:5:865;        % 5 m intervals.

% decrements down the line

for m = 1:length(xB_center)
    interval = (m-1) * 5;
    dn = edge - interval;
    rB_matr(1,m) = sqrt(dn^2 + R^2);
end

xB_center_2 = 870:5:1730;    % second interval of values, approaching C.

for k = 1:length(xB_center_2)
    interval = (k-1) * 5;
    dn = edge - interval;
    rB_matr2(1,k) = sqrt(dn^2 + R^2);
end

% Flips the values to reflect what occurred above the cluster center, and
% horizontally concatenating the values to match the increments.

rB_matr2 = fliplr(rB_matr2);
rB_final =  horzcat(rB_matr, rB_matr2);

% Received Power calculation, radially decreasing, then
% increasing again after reaching the center of the cluster.

for u = 1:length(rB_final)
    yB(1,u) = E - 40*log10((rB_final(1,u))/(d0));
end

% Grab every fifth value from yA and yC.
y2A = yA(1:5:end);
y2C = yC(1:5:end);

figure(2)
hold on
plot(xA_C,y2A,'bo',xA_C,yB,'r*',xA_C,y2C,'^');grid;
set(gca,'XAxisLocation','top');
xlabel('Distance (m)');
ylabel('P_r (dBm)');xlim([0 d]);
legend('P_r from A','P_r from B','P_r from C','Location','southeast');
title('Fig. 3 - Received Power from each BS in 5m increments from d_0')
hold off

%% Shadowing Effects
%
% The shadowing parameter is a zero mean, gaussian random variable.
% Atypical decibel level for Xsigma was indicated to be 8 within lecture.
% This section will apply additive white gaussian noise (WGN - gaussian
% distribution, with zero mean.)
%
% X_sigma = N(0,(sigma)^2)

snr = 8;

ygA = awgn(y2A,snr);
ygB = awgn(yB,snr);
ygC = awgn(y2C,snr);

figure(3)
hold on
plot(xA_C,y2A,'b',xA_C,ygA,'bo',xA_C,yB,'r',xA_C,ygB,'r*',xA_C,y2C,...
xA_C,ygC,'^'); grid;
xlabel('Distance (m)');
ylabel('P_r (dBm)');xlim([0 d]);
title('Fig. 4 - Received Power with shadowing X_\sigma');
hold off
