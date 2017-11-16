%% Beamforming.m
%
% Jordan R. Smith
% ECE 920 - Wireless Communication Systems
%
% Using MATLAB, develop a program that illustrates the performance of a
% conventional Bartlett Beamformer for a ULA. Assume the carrier frequency
% is 1.8 GHz, and the signal transmitted is an unmodulated carrier, s(t) =
% 1. No noise, n(t) = 0. Decide how many elements to use, and the direction
% arrival of the signals (at least two). Model the output of the antenna
% array as a superposition of steering vectors with each steering vector
% corresponding to a multipath signal component and assume this information
% is unknown to the beamforming system.

clear all, close all, clc;

%% Constant declarations

F0 = 1.8e9;                     % 1.8 GHz
c = physconst('LightSpeed');    % Speed of light
S = 1;                          % Unmodulated signal s(t) = 1.
n = 0;                          % noise n(t) = 0.
lambda = c / F0;                % Wavelength
omega = 2*pi*F0;                % rotational frequency
K = 2*pi / lambda;              % Wavenumber
degree = [-90:1:90];            % X-axis of Spatial Spectrum.
theta = degree*pi/180;          % DOA radian vector
iTheta = length(theta);         % Indicer for the Bartlett Calculation.
L = 10;                         % 10 antenna elements
dist = lambda/2;          

%% Conventional Beamformer Plotting & Application

% Far Angles
Pbart1 = bartlett_beamform(21,70,degree,dist,F0);
Pbart2 = bartlett_beamform(21,70,degree,lambda/3,F0);
Pbart3 = bartlett_beamform(21,70,degree,lambda/6,F0);

% Close Angles
Pbart4 = bartlett_beamform(45,60,degree,dist,F0);
Pbart5 = bartlett_beamform(45,60,degree,lambda/3,F0);
Pbart6 = bartlett_beamform(45,60,degree,lambda/6,F0);

figure(1)
plot(degree,Pbart1,'b-',degree,Pbart2,'r-',degree,Pbart3,'b-.');
grid;
title('Bartlett Beamformer, L=10, 21\circ and 70\circ Signals');
xlabel('Degrees');
legend('D = \lambda/2','D = \lambda/3','D = \lambda/6');
legend('Location','NorthWest');
ylabel('Spatial Spectrum');
xlim([-90 90]);

figure(2)
plot(degree,Pbart4,'b-',degree,Pbart5,'r-',degree,Pbart6,'b-.');
grid;
title('Bartlett Beamformer, L=10, 45\circ and 60\circ Signals');
xlabel('Degrees');
ylabel('Spatial Spectrum');
legend('D = \lambda/2','D = \lambda/3','D = \lambda/6');
legend('Location','NorthWest');
xlim([-90 90]);

%% MUSIC DOA angle Determination
%
% MUSIC algorithm attempt at implementation. Ought to have sharp peaks.

% MUSIC - Far degree.
music1 = music_search(21,70,lambda/2);
music2 = music_search(21,70,lambda/3);
music3 = music_search(21,70,lambda/6);

% MUSIC - Close degree.
music4 = music_search(45,60,lambda/2);
music5 = music_search(45,60,lambda/3);
music6 = music_search(45,60,lambda/6);


figure(3)
plot(degree,music1,'b-',degree,music2,'r-',degree,music3,'b-.');
grid;ylabel('Spatial Spectrum [dB]');
xlabel('degrees');
title('DOA Estimation from the MUSIC Algorithm, 21 and 70\circ');
legend('\lambda/2','\lambda/3','\lambda/6');
legend('Location','NorthWest');

figure(4)
plot(degree,music4,'b-',degree,music5,'r-',degree,music6,'b-.');
grid;ylabel('Spatial Spectrum [dB]');
xlabel('degrees');
title('DOA Estimation from the MUSIC Algorithm, 45 and 60\circ');
legend('\lambda/2','\lambda/3','\lambda/6');
legend('Location','NorthWest');

%% Array Geometry
%
% Example utilizing MATLAB's Phased Array System Toolbox. Answers Q2 of the
% assignment, requiring a graphical illustration of the ULA.

N = 10;                 % 10 elements
D = lambda/2;           % Example with uniform half-wavelength spacing.
ula = phased.ULA(N,D);

figure(5)
viewArray(ula,'Title','Uniform Linear Array (ULA)')
set(gca,'CameraViewAngle',4.4);


%% Bartlett Beamformer
%
% Conventional Beamformer calculations. Each row of the phi matrix
% designates a different spacing, whereas the columns are the 1 to 180
% degrees of theta.
function Pbart = bartlett_beamform(ang1,ang2,degree,dist,F0)
    
    theta = degree*pi/180;                   % DOA radian vector
    c = physconst('LightSpeed');             % Speed of light
    lambda = c / F0;                         % Wavelength
    K = 2*pi / lambda;                       % Wavenumber
    S = 1;                                   % Unmodulated signal s(t) = 1.
    L = 10;
    
    phi = K .* dist .* cos(theta);           % Electrical angle.
    
    for i = 1:L
        a(i,:) = exp(-j*(i-1)*phi);          % Steering Vector.
    end
    
    X = a(:,91+ang1)*S + a(:,91+ang2)*S;     % DOA. set for -90:90 range.
    R = X*X';                                % Correlation Matrix.
    R = R / 100;                             % Normalization
    
    P = conj(a) .* (R * a);                  % Spatial Spectrum Expression
    D = conj(a) .* a;
    Pbart = abs(sum(P./D, 1));
    
end

%% Matlab Bartlett / MUSIC Determination
% utilizes some of the built-in packages, in an effort to
% simulate what the expected conventional beamformer would act like.
% Unfortunately, the negative angles are not included. Might be an
% indication that the steering vector wasn't taken into consideration?
% Negative angles ought to illicit the same response if cosine is being
% utilized.

function matlab_bartlett(ang1,ang2,num)

Fc = 1.8e9;
c = physconst('LightSpeed');
lambda = c / Fc;
K = 2*pi / lambda;
Nsamp = 1000;
angle1 = [ang1;0];
angle2 = [ang2;0];
angs = [angle1 angle2];


array = phased.ULA('NumElements',10,'ElementSpacing',lambda/2);
pos = getElementPosition(array)/lambda;
signal = sensorsig(pos,Nsamp,angs);

broadsideAngle = az2broadside(angs(1,:),angs(2,:));

spatialspectrum = phased.BeamscanEstimator('SensorArray',array,...
    'OperatingFrequency',Fc,'ScanAngles',-90:90);

spatialspectrum.DOAOutputPort = true;
spatialspectrum.NumSignals = 2;

[~,ang] = spatialspectrum(signal);

figure(num),plotSpectrum(spatialspectrum,'Unit','mag');

musicspatialspect = phased.MUSICEstimator('SensorArray',array,...
    'ScanAngles',-90:90,'DOAOutputPort',true,'NumSignalsSource',...
    'Property','NumSignals',2,'OperatingFrequency',Fc);
[~,ang] = musicspatialspect(signal);
ymusic = musicspatialspect(signal);

degree = [-90:1:90];
figure(num+1),plot(degree,10*log10(ymusic));grid;
title('MUSIC Algorithm');
ylabel('Spatial Spectrum(dB)');xlabel('Sweep Angle');

end

%% MUSIC Algorithm
%
% Resimulating for MUSIC algorithm.

function music = music_search(ang1,ang2,dist)
    F0 = 1.8e9;                     % 1.8 GHz
    c = physconst('LightSpeed');    % Speed of light
    lambda = c / F0;
    doa=[ang1 ang2]*pi / 180;       % Direction of arrival
    M=10;                           % Number of array elements
    P= 2;                           % The number of signals
    d=dist;
    D=zeros(P,M);                   % Matrix predefined (P row, M col.)
    
    for k=1:P                       % steering vector.
        D(k,:)=exp(-j*2*pi*d*cos(doa(k))/lambda*[0:M-1]);
    end
    
    D = D';                  % Column Orientation.
    xx = 1;                  % Simulate S(t) as a modulation for MUSIC.
    X = D*xx;
    R = X*X';                % covarivance matrix
    [N,V] = eig(R);          % Find the eigenvalues and eigenvectors of R
    NN = N(:,1:M-P);         % Estimate noise subspace (no noise present)
    theta = -90:1:90;        % Peak search
    for r=1:length(theta)
        NS = zeros(1,length(M));
        for k=0:M-1 
            NS(1+k) = exp(-j*2*k*pi*d*cos(theta(r)/180*pi)/lambda);
        end
        PP = NS*NN*NN'*NS';
        Pmusic(r) = abs(1/ PP);
    end
    music = 10*log10(Pmusic/max(Pmusic)); % Spatial spectrum function
end