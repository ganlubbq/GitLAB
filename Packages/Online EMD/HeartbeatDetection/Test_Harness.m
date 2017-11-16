% save data;
clear;
tic
clear functions;
clear globals;
clear all;
clc;
% load data;
toc
% x=Buffer(fs,D,len,'No filter',0);
fs = 10000;         % 10khz sampling frequency.
D = 10;             % Runtime seems to be O(n), so decreasing sample rate by 10 seems to help processing speed by 10x.
duration = 10;      % 10 second buffer length.

% Create three buffers:
% 1) x, with no smoothing or decimation.
% 2) xd, with 67.5ms smoothing and 10x downsample.
% 3) xs, with 1250ms smoothing and 10x downsample.
tic
x  = Buffer(fs,1,duration*fs,'No filter',0);
xd = Buffer(fs,D,duration*fs/D,NewMovingAvgFilter(fs,0.0675,D),0.0675/2);
xs = Buffer(fs,D,duration*fs/D,NewMovingAvgFilter(fs,1.25,D),1.25/2);
toc

%% Test group delay
% Generate test data.
% t = (10/fs:1/fs:20) *pi;
% data = square(t,0.4);

dataduration = 10;
data = Heartbeat_Test_Data(dataduration,fs);

load('problem_data.mat');

% Feed the data to the buffers in blocks (simulates streaming data processing.)
% A blocksize of about 1000 is suitably fast.
blocksize = 1000;
tic
t=cputime;
peaktimes = [];
for n = 0:(floor(numel(data)/blocksize)-1);
    xd.Update( data((n*blocksize) + 1 : (n+1)*blocksize) );
    xs.Update( data((n*blocksize) + 1 : (n+1)*blocksize) );
    peaktimes = horzcat( peaktimes, DetectHeartbeats(xd, xs) );

end
fprintf ('Time elapsed to detect heartbeats in %f seconds of data\n', dataduration)
toc
time_elapsed = cputime - t
peaktimes

% The buffers have different time delays - xd trails 'real time' by 67.5ms, and
% xs trails real time by 1250ms. Get the parts of these buffers that correspond
% to the same real times. 
test = Buffer.CommonSection([xd, xs]);

try
    close (10);
catch
end
    
figure (10);
xd.Plot('b');
hold on;
xs.Plot('r--');
xs.Plot('r--',2);
for peaktime = peaktimes
    plot ( [peaktime peaktime], [0,1], 'go--' );
end

% Plot the xs and xd buffers against each other, lined up in time. The two
% waveforms should peak at the same time. If not, then the CommonSection()
% function is buggy.
% close all;
% plot ( test.data{1} ); hold on; plot (test.data{2})