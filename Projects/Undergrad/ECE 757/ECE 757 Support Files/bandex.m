% bandex.m design a bandpass filter and plot frequency response

fbe=[0 0.24 0.26 0.74 0.76 1];  % frequency band edges as a fraction of 
                                %   the Nyquist frequency
damps=[0 0 1 1 0 0];            % desired amplitudes at band edges
fl=30;                          % filter size
b=firpm(fl,fbe,damps);          % b is the designed impulse response
figure(1)
freqz(b)                        % plot frequency response to check design

[b,a]=cheby1(10,5,0.25);
figure(2)
freqz(b,a)
