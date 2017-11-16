%% Rappaport Example 5.3

theta1 = 120;
theta2 = 240;

rad_th1 = deg2rad(theta1);      % convert from degrees to radians.
rad_th2 = deg2rad(theta2);      % exp() accepts radian inputs.

p1 = sqrt(100e-12);             % square root of linear dBm at t1.
p2 = sqrt(50e-12);              % square root of linear dBm at t2.

a11 = exp(i*rad_th1);           % split into pieces.
a12 = exp(-i*rad_th1);          % negative due to moving away.

a21 = exp(i*rad_th2);           % calculate for t2.
a22 = exp(-i*rad_th2);          % also for 240 degrees.

pwr1 = abs(p1.*a11 + p2.*a12);  % absolute value.
pwr1 = pwr1.^2;                 % squaring operation.

pwr2 = abs(p1.*a21 + p2.*a22);
pwr2 = pwr2.^2;

String1 = ['Power at t1: ', num2str(pwr1), 'W'];
String2 = ['Power at t2: ', num2str(pwr2), 'W'];
disp(String1)
disp(String2)