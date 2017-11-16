% specdelta.m plot the spectrum of a delta function
time=2;                     % length of time
Ts=1/100;                   % time interval between samples
t=Ts:Ts:time;               % create time vector
x=zeros(size(t));           % create signal of all zeros
x(1)=1;                     % delta function
plotspec(x,Ts)              % draw waveform and spectrum

% other interesting spectra involving delta functions
x(1)=1; x(end)=1;           % put deltas at start and end
x(90)=1; x(end-90)=1;       % abs(sine wave)
x(1:20:end)=1;              % spike train
