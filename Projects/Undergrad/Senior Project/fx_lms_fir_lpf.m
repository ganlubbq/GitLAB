%% FIR Lowpass Filter Design for Input Data Streams

Fs = 48e3;          %Sampling rate.
N = 255;            %Filter order, number of taps.
Fp = 2200;          %2.2 kHz Passband Edge.
Rp = 0.00057565;    %0.01 dB peak-to-peak ripple.
Rst = 1e-4;         %-80 dB stopband attenuation.

eqnum = firceqrip(N,Fp/(Fs/2),[Rp Rst],'passedge'); %vector of coeffs.
fvtool(eqnum,'Fs',Fs,'Color','White')   %Visualize Filter
xlim([0 15])

coeffs = fliplr(eqnum); %saves the coefficients in reverse order.
coeffs = coeffs.';      %transposes for matrix format in header file.