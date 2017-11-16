%% MUSIC Algorithm Attempt.

clear all, close all, clc;

F0 = 1.8e9;                     % 1.8 GHz
c = physconst('LightSpeed');    % Speed of light
S = 1;                          % Unmodulated signal s(t) = 1.
n = 0;                          % noise n(t) = 0.
lambda = c / F0;                % Wavelength
omega = 2*pi*F0;                % rotational frequency
K = 2*pi / lambda;              % Wavenumber
degree = [-90:1:90];             % X-axis of Spatial Spectrum.
theta = degree*pi/180;          % DOA radian vector
iTheta = length(theta);         % Indicer for the Bartlett Calculation.
ang1 = 21;
ang2 = 70;

dist = lambda/2;          
L = 10;                         % 10 antenna elements
theta = degree*pi/180;          % DOA radian vector
c = physconst('LightSpeed');    % Speed of light
lambda = c / F0;                % Wavelength
K = 2*pi / lambda;              % Wavenumber
S = 1;                          % Unmodulated signal s(t) = 1.
L = 10;
M = 2;
    
phi = K .* dist .* cos(theta);           % Electrical angle.
    
for i = 1:L
    a(i,:) = exp(-j*(i-1)*phi);          % Steering Vector.
end
    
X = a(:,91+ang1)*S + a(:,91+ang2)*S;     % DOA. set for -90:90 range.
R = X*X';

R = R / 100;                             % Matrix normalization.
  
P = conj(a) .* (R * a);                  % Spatial Spectrum Expression
D = conj(a) .* a;
Pbart = abs(sum(P./D, 1));


%% MUSIC portion.

[U, eir] = eig(R);
erDiag = diag(eir);
   
[ver, ier] = sort(erDiag);
Us = U(:,(L-M+1):L);
phiS = Us*Us';
phiN = eye(10) + phiS;    
P = conj(a) .* (phiN * a);
[mp, np] = max(P);

music_spectrum = abs(sum(P,1));

figure(1)
plot(degree,music_spectrum);grid;xlabel('Degrees');
ylabel('MUSIC Algorithm');