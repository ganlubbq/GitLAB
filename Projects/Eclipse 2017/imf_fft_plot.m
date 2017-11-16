function imf_fft_plot( imf, size_of, name )
%IMF_FFT_PLOT.m - instead of time series, plot the FFT of each IMF.
%   imf - imf matrix produced by the Rollins-validated imf function.
%   size_of - conditional necessary for proper subplot dimensions.
%   name - string for title of each figure.

[r,c] = size(imf);  % row x column dimensions.
x = 1:c;            % reference x-axis dimensions.
n = 2^nextpow2(c);  % zero padding if needed for FFT.
dim = 2;            % indicates IMF ought to be performed on each row.
Fs = c;
Y = fft(imf,n,dim);

P2 = abs(Y/n);      % Single Sided and Double Sided Spectral Calculation.
P1 = P2(:,1:n/2+1);
P1(:,2:end-1) = 2*P1(:,2:end-1);


if size_of <= 6        % small IMF count.
    figure;
    hold on
    for i=1:size_of
       if i == 1
            subplot(size_of,1,i);
            plot(0:(Fs/n):(Fs/2-Fs/n),P1(i,1:n/2)); grid;
            title(['EMD-FFT Application (',name,')']);
            ylabel(['|IMF(',num2str(i),')|']);
       else
            subplot(size_of,1,i);
            plot(0:(Fs/n):(Fs/2-Fs/n),P1(i,1:n/2)); grid;
            ylabel(['|IMF(',num2str(i),')|']);
       end
    end
    hold off
elseif size_of > 6 && size_of <= 14
    figure;
    hold on
    
    for j = 1:6
        if j == 1
            subplot(6,1,j);
            plot(0:(Fs/n):(Fs/2-Fs/n),P1(j,1:n/2)); grid;
            title(['EMD-FFT Application (',name,')'])
            ylabel(['|IMF(',num2str(j),')|']);
        else
            subplot(6,1,j);
            plot(0:(Fs/n):(Fs/2-Fs/n),P1(j,1:n/2)); grid;
            ylabel(['|IMF(',num2str(j),')|']);
        end
    end
    hold off
    figure;
    hold on
    for m = 1:size_of - 6  % actual iteration number count
        k = m + 6;      % IMF index adjustment
        if m == 1
            subplot(size_of-6,1,m);
            plot(0:(Fs/n):(Fs/2-Fs/n),P1(k,1:n/2)); grid;
            title(['EMD-FFT Application (',name,')']);
            ylabel(['|IMF(',num2str(k),')|']);
        else
            subplot(size_of-6,1,m);
            plot(0:(Fs/n):(Fs/2-Fs/n),P1(k,1:n/2)); grid;
            ylabel(['|IMF(',num2str(k),')|']);
        end
    end
    hold off
elseif size_of > 14
    figure;
    hold on
    for q = 1:size_of - 14;
        t = q + 14;
        if q == 1
            subplot(size_of-14,1,q);
            plot(0:(Fs/n):(Fs/2-Fs/n),P1(t,1:n/2)); grid;
            title(['EMD Application to ',name]);
            ylabel(['IMF(',num2str(t),')']);
        else
            subplot(size_of-14,1,q);
            plot(0:(Fs/n):(Fs/2-Fs/n),P1(t,1:n/2)); grid;
            title(['EMD Application to ',name]);
            ylabel(['IMF(',num2str(t),')']);
        end
    end
    hold off
    
  end
end

