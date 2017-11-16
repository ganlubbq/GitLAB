%% Rapapport 9.5
%
% Testing Intermodulation products for AMPS standard from
% Question 9.5 in the textbook. f = 0.03*C + 870 MHz, with C = 360 and 352,
% which are transmitted simultaneously. The n values can be observed at -48
% and 56 for the frequency band limits.

for i=1:201                 % "n" intermodulation coefficients.
    m(1,i) = i-101;         % Indexing correction.
end

x = 870 + 0.03*(352 + 8*n); % Simplified frequency equation.

figure(1)
plot(n,x);grid;title('AMPS Intermodulation Interferers');
xlabel('n value');
ylabel('frequency (MHz)');