%  Jordan Smith
%  ECE 757 Lab 4 - Intermodulation Products
% 
% Three high powered transmitters exist at a radio communications site. 
% Their frequencies are 421.6, 388.2 and 211.5 MHz. A new receiving system
% is being designed and a frequency must be chosen that will be free of
% interfering signals from the existing transmitters. Calculation of the 
% potential interfering frequencies due to the choice of these three 
% frequencies is essential in order to properly choose the frequency. Find
% the offending frequencies.

%% Part 1

f1 = 421.6e6;           %421.6 MHz
f2 = 388.2e6;           %388.2 MHz
f3 = 211.5e6;           %211.5 MHz

n = 1:9;
y(1:9) = 1;
m = n;
f1n = f1.*n;            %Indicates multiples of each carrier frequency.
f2n = f2.*n;
f3n = f3.*n;

mt1 = zeros(9,9,9);     % Establishes an empty matrix for each variation.
mt2 = zeros(9,9,9);
mt3 = zeros(9,9,9);
mt4 = zeros(9,9,9);
mt5 = zeros(9,9,9,4);

% The nested for loop looks through each harmonic based on the index i, j,
% or k, and calculates based on the operation. Four 9x9x9 matrices will be
% computed. The final fourth dimensional matrix combines the four into a
% single array for plotting as a histogram.

for i=1:9;
    for j=1:9
        for k=1:9
            mt1(i,j,k) = f1n(i)+f2n(j)+f3n(k);
            mt2(i,j,k) = f1n(i)+f2n(j)-f3n(k);
            mt3(i,j,k) = f1n(i)-f2n(j)+f3n(k);
            mt4(i,j,k) = f1n(i)-f2n(j)-f3n(k);

            if mt1(i,j,k) <= 2e9 && mt1(i,j,k) > 0
                mt5(i,j,k,1) = mt1(i,j,k);
            else
                mt5(i,j,k,1) = 0;
            end
            
            if mt2(i,j,k) <= 2e9 && mt2(i,j,k) > 0
                mt5(i,j,k,2) = mt2(i,j,k);
            else
                mt5(i,j,k,2) = 0;
            end

            if mt3(i,j,k) <= 2e9 && mt3(i,j,k) > 0
                mt5(i,j,k,3) = mt3(i,j,k);
            else
                mt5(i,j,k,3) = 0;
            end

            if mt4(i,j,k) <= 2e9 && mt4(i,j,k) > 0
                mt5(i,j,k,4) = mt4(i,j,k);
            else
                mt5(i,j,k,4) = 0;
            end
        end
    end
end

q = 1;
for i2=1:9;
    for j2=1:9
        for k2=1:9
            for l2 =1:4
                if mt5(i2,j2,k2,l2) > 0
                    mt6(q) = mt5(i2,j2,k2,l2);
                    q = q + 1;
                end
            end
        end
    end
end

nbins = (2e9)/(10e6);   %2 GHz window, separated into 10 MHz buckets.
 figure
 final = histogram(mt5,200)

%% Part 2
% Plot discrete magnitude spectrum.
% Utilizes Software Receiver Design Matlab Functions.
% Pol(Z) = A0 + A1z + A2z^2 + A3z^3...+A8z^8.

% Intermodulate to the ninth order, including the fundamental frequency
% nfx + mfy
% where n and m are the fundamental harmonic frequencies of fx and fy which
% are from the set of the three transmit frequencies.

%% Part 4
% Bin or "bucket" size of 10 MHz. Histogram command takes bin as an
% argument. 2 GHz / 10 MHz bins is n=200 bins. Some of the histogram bins
% appear smaller than others - may be because of the second argument in
% histogram() being continually called while the hold is "on".
