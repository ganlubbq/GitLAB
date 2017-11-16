%% mag_denoising.m
%
% Using the data from the solar eclipse in New Boston and Durham, NH, EMD
% can be utilized to provide a cleaner trend signal. This script requires
% 
% Necessary Files: eclipse_Durham.csv, eclipse_NewBoston.csv, EMD.m

clear all, close all, clc;

durham = csvread('eclipse_Durham.csv',1,2);
boston = csvread('eclipse_NewBoston.csv',19,1);

%% Durham Data operations
%
% Separating the rows into explicit Axes, and finding the average per row.
% This will then correspond to each row now being a time slice of averages.
% A new matrix will be formed that has the average of each axis per time
% division.
%
% The beginning and end have significant outliers due to being activated
% and placed in the ground, then being removed from the measurement sight.
% These values can be limited.

% The start and endpoints need to match the time interval of interest,
% specified by Kris Maynard.

% Row 377  corresponds to 08-21-2017 16:01:00.0 (eclipse_durham.csv)
% Row 3812 corresponds to 08-22-2017 11:00:00.0 (eclipse_durham.csv)

cstart = 376;    % Indicate time interval start to reading. Row #.
cend = 3812;    % Indicate time interval end. Row #. Corrected.

Bx_durham = durham(:,[2 5 8 11 14 20 23]);  %Magnetometer readings
By_durham = durham(:,[3 6 9 12 15 21 24]);
Bz_durham = durham(:,[4 7 10 13 16 22 25]);

[r,c] = size(durham);

Bx_durham_avg = mean(Bx_durham,2);  % calculates avg. per row
By_durham_avg = mean(By_durham,2);
Bz_durham_avg = mean(Bz_durham,2);

% Final Avg. Matrix, Bx By Bz per column.
B_avg = [Bx_durham_avg By_durham_avg Bz_durham_avg];

figure(1)
hold on
subplot(3,1,1),plot(B_avg(cstart:cend,1)),grid;xlabel('Samples(n)');
ylabel('\Delta B_x');
title('Durham Averaged Magnetometer Measurements')
subplot(3,1,2),plot(B_avg(cstart:cend,2)),grid;xlabel('Samples(n)');
ylabel('\Delta B_y');
subplot(3,1,3),plot(B_avg(cstart:cend,3)),grid;xlabel('Samples(n)');
ylabel('\Delta B_z');
hold off


%% New Boston Data
%
% Because of the python formatting, the fields are offset differently. The
% same code for windowing and averaging is used in this section.
% Temperature and pressure data are in columns 1 and 2, with the Time data 
% in the first column, or column 0 of the CSV.

bstart = 6057;     % 08-21-2017 16:01.0 - add 20 for csv row loc. in NewB.
bend = 72206;      % 08-22-2017 11:00.0 - add 20 for csv row loc. in NewB.

Bx_boston = boston(:,[3 6 9 12 18 21 24]);
By_boston = boston(:,[4 7 10 13 19 22 25]);
Bz_boston = boston(:,[5 8 11 14 20 23 26]);

[rBoston, cBoston] = size(boston);

Bx_boston_avg = mean(Bx_boston,2);
By_boston_avg = mean(By_boston,2);
Bz_boston_avg = mean(Bz_boston,2);

B_boston_avg = [Bx_boston_avg By_boston_avg Bz_boston_avg];

figure(2)
subplot(3,1,1),plot(B_boston_avg(bstart:bend,1)),grid;xlabel('Samples(n)');
ylabel('\Delta B_x');
title('New Boston Averaged Magnetometer Measurements');
subplot(3,1,2),plot(B_boston_avg(bstart:bend,2)),grid;xlabel('Samples(n)');
ylabel('\Delta B_y');
subplot(3,1,3),plot(B_boston_avg(bstart:bend,3)),grid;xlabel('Samples(n)');
ylabel('\Delta B_z');

%% EMD Application - Durham & New Boston
%
% Utilize Bx, By, and Bz from B_avg, transpose the column, and apply EMD.

Bx_Durham_PreEMD = (B_avg(cstart:cend,1)).';
By_Durham_PreEMD = (B_avg(cstart:cend,2)).';
Bz_Durham_PreEMD = (B_avg(cstart:cend,3)).';

Bx_Durham_imf = emd(Bx_Durham_PreEMD);
By_Durham_imf = emd(By_Durham_PreEMD);
Bz_Durham_imf = emd(Bz_Durham_PreEMD);

Bx_NewBoston_PreEMD = (B_boston_avg(bstart:bend,1)).';
By_NewBoston_PreEMD = (B_boston_avg(bstart:bend,2)).';
Bz_NewBoston_PreEMD = (B_boston_avg(bstart:bend,3)).';

Bx_NewBoston_imf = emd(Bx_NewBoston_PreEMD);
By_NewBoston_imf = emd(By_NewBoston_PreEMD);
Bz_NewBoston_imf = emd(Bz_NewBoston_PreEMD);

%% EMD Plotting - Durham
%
% With the IMF's generated, check the size and plot the a suitable count of
% IMF's. Indicate a plot of the pre-EMD filtering first, before presenting
% the IMF figures for Bx, By, and Bz of Durham.

imf_plot(Bx_Durham_imf,8,'B_x Field - Durham')
imf_fft_plot(Bx_Durham_imf,8,'B_x Field - Durham')

imf_plot(By_Durham_imf,7,'B_y Field - Durham')
imf_fft_plot(By_Durham_imf,7,'B_y Field - Durham')

imf_plot(Bz_Durham_imf,7,'B_z Field - Durham')
imf_fft_plot(Bz_Durham_imf,7,'B_z Field - Durham')

%% EMD Plotting - New Boston
%
% Apply the imf and imf_fft plotting functions. New Boston has a higher
% sample size than Durham, and may generate a higher IMF count as a result.

imf_plot(Bx_NewBoston_imf,19,'B_x Field - New Boston')
imf_fft_plot(Bx_NewBoston_imf,19,'B_x Field - New Boston')

imf_plot(By_NewBoston_imf,20,'B_y Field - New Boston')
imf_fft_plot(By_NewBoston_imf,20,'B_y Field - New Boston')

imf_plot(Bz_NewBoston_imf,14,'B_z Field - New Boston');
imf_fft_plot(Bz_NewBoston_imf,14,'B_z Field - New Boston');