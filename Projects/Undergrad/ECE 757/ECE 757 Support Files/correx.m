% correx.m: correlation can locate the header within the data
header=[1 -1 1 -1 -1 1 1 1 -1 -1];     % header is a predefined string
loc=30; r=25;                          % place header in position loc
data=[sign(randn(1,loc-1)) header sign(randn(1,r))];  % generate signal
sd=0.25; data=data+sd*randn(size(data));              % add noise
y=xcorr(header, data);                 % do cross correlation
[m,ind]=max(y);                        % location of largest correlation
headstart=length(data)-ind+1;          % place where header starts
subplot(3,1,1), stem(header)           % plot header
title('Header')
subplot(3,1,2), stem(data)             % plot data sequence
title('Data with embedded header')
subplot(3,1,3), stem(y)                % plot correlation
title('Correlation of header with data')

