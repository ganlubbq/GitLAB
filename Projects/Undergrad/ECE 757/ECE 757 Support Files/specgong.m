% specgong.m find spectrum of the "gong" sound
filename='gong.wav';                 % name of wave file goes here
[x,sr]=wavread(filename);            % read in wavefile
Ts=1/sr;                             % sample interval
N=2^15; x=x(1:N)';                   % length for analysis
sound(x,1/Ts)                        % play sound, if sound card installed
time=Ts*(0:length(x)-1);             % establish time base for plotting
subplot(3,1,1), plot(time,x)         % and plot top figure
magx=abs(fft(x));                    % take FFT magnitude
ylabel('amplitude'); xlabel('time in seconds')
subplot(3,1,2)
ssf=(0:N/2-1)/(Ts*N);                % establish frequency base for plotting
plot(ssf,magx(1:N/2))            % plot mag spectrum
ylabel('magnitude'); xlabel('frequency in Hertz')

subplot(3,1,3)                       % zoom in on spectrum
disp=300:600;
plot(ssf(disp),magx(disp));  % zoom to see the action
ylabel('magnitude'); xlabel('frequency in Hertz')
