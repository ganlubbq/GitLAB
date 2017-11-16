% randspec.m spectrum of random numbers
N=2^16;                        % how many random #'s
Ts=0.001; t=Ts*(1:N);          % define a time vector
x=randn(1,N);                  % N random numbers
plotspec(x,Ts);                % plot noise and its spectrum
