%% Plotspectrum.m
%
% Modified plotspec, changing the output to be a power dB squared scale, to
% include any significantly small spectral responses. 3 subplots will be
% displayed, with the initial signal, its spectral response, and the dB
% response.


function plotspectrum(x,Ts)
N=length(x);                               % length of the signal x
t=Ts*(1:N);                                % define a time vector
ssf=(ceil(-N/2):ceil(N/2)-1)/(Ts*N);       % frequency vector
fx=fft(x(1:N));                            % do DFT/FFT
fxs=fftshift(fx);                          % shift it for plotting
fxsp=10*log10((fxs).^2);                   % power dB plotting
subplot(3,1,1), plot(t,x)                  % plot the waveform
xlabel('seconds'); ylabel('amplitude')     % label the axes
subplot(3,1,2), plot(ssf,abs(fxs))         % plot magnitude spectrum
xlabel('frequency'); ylabel('magnitude')   % label the axes
subplot(3,1,3), plot(ssf,fxsp)
xlabel('frequency'); ylabel('power dB magnitude')
ylim([-1e-2 1e2])
end