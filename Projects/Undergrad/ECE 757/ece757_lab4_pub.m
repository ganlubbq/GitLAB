mt1 = zeros(9,9,9);     % Establishes an empty matrix for each variation.
mt2 = zeros(9,9,9);
mt3 = zeros(9,9,9);
mt4 = zeros(9,9,9);
mt5 = zeros(9,9,9,4);

% The nested for loop looks through each harmonic based on the index i, j,
% or k, and calculates based on the operation. Four 9x9x9 matrices will be
% computed. The final fourth dimensional matrix combines the four into a
% single array for plotting as a histogram.
% 
           
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

        
% In the 2 GHz window, bins are separated into 10 MHz buckets, creating 200
% "nbins", the second argument of the histogram command.

nbins = (2e9)/(10e6);

figure
final = histogram(mt6,200);
xlabel('Frequency(Hz)');
xlim([0 2e9]);                % truncates to 2 GHz limit.
title('Intermodulated Products & Transmitter Harmonics within 2 GHz');