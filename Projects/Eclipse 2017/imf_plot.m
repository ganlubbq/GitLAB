function imf_plot( imf, size_of, name )
%imf_plot.m - Plots corresponding IMF's.
%   Utilizing the Rollins-validated EMD script, use this function to plot
%   five subfigure IMF's. size_of provides how many IMF's to plot, and name
%   indicates what will be in the initial title.

[r,c] = size(imf);   % dimensions of IMF matrix
x = 1:c;             % Time axis graph


if size_of <= 6      % small IMF count.
    figure;
    hold on
    for i=1:size_of
       if i == 1
            subplot(size_of,1,i),plot(imf(i,1:c)'); grid;
            title(['EMD Application to ',name]);
            ylabel(['IMF(',num2str(i),')']);
       else
            subplot(size_of,1,i),plot(imf(i,1:c)'); grid;
            ylabel(['IMF(',num2str(i),')']);
       end
    end
    hold off
elseif size_of > 6 && size_of <= 14
    figure;
    hold on
    for j = 1:6
        if j == 1
            subplot(6,1,j),plot(imf(j,1:c)'); grid;
            title(['EMD Application to ',name])
            ylabel(['IMF(',num2str(j),')']);
        else
            subplot(6,1,j),plot(imf(j,1:c)'); grid;
            ylabel(['IMF(',num2str(j),')']);
        end
    end
    hold off
    figure;
    hold on
    for m = 1:size_of - 6  % actual iteration number count
        k = m + 6;         % IMF index adjustment
        if m == 1
            subplot(size_of-6,1,m),plot(imf(k,1:c)'); grid;
            title(['EMD Application to ',name]);
            ylabel(['IMF(',num2str(k),')']);
        else
            subplot(size_of-6,1,m),plot(imf(k,1:c)'); grid;
            ylabel(['IMF(',num2str(k),')']);
        end
    end
    hold off
elseif size_of > 14
    figure;
    hold on
    for q = 1:size_of - 14;
        t = q + 14;
        if q == 1
            subplot(size_of-14,1,q),plot(imf(t,1:c)'); grid;
            title(['EMD Application to ',name]);
            ylabel(['IMF(',num2str(t),')']);
        else
            subplot(size_of-14,1,q),plot(imf(t,1:c)'); grid;
            title(['EMD Application to ',name]);
            ylabel(['IMF(',num2str(t),')']);
        end
    end
    hold off
end

end

