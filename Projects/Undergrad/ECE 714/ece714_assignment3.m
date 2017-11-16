%% Part 1
% Jordan R. Smith
% ECE 714 - Assignment #3
% October 7, 2016
%
% Part 1-a.
% Create a matrix of 20 entries, with n=20:39 implementing x(n)=40-n. Plot
% it via stem, and limit the window to 40 x 30. This should have a uniform
% triangular shape.

n = 0:39;
x = n;

for i=1:40
    if x(i) >= 21
        x(i) = 41 - i;
    end
end

figure(1)
stem(n,x);
xlim([0 40])
ylim([0 30])
xlabel('Index n')
ylabel('x(n)')
title('Part 1-a. Stem Plot')

% Part 1-b.
% Plot X(m) = |{DFS(x(n))}| vs m, assuming x(n) is a periodic sequence with
% period 40. Scale the vertical axis from 0 to 400, and horizontal axis
% from 0 to 40.

figure(2)
stem(n,abs(fft(x)))
xlim([0 40])
ylim([0 400])
xlabel('n')
ylabel('|X(F)|')
title('Part 1-b. Frequency Spectrum |X(m)|')

% Part 1-c.
% Plot X(w) = |{DFS(x(n))}| vs w, assuming x(n) is periodic. Scale the
% vertical axis logarithmically, scale the horizontal axis linearly. This
% is done with the semilogy() command.

figure(3)
x1c = 2*pi*n/40;
x_F = abs(fft(x)) + 1e-7;
semilogy(x1c, x_F)
xlim([0 2*pi])
ylim([1e-3 1e3])
xlabel('w')
ylabel('|X(w)|')
title('Part 1-c. Frequency Spectrum |X(w)|')

% Part 1-d.
% Use zero padding to increase the length of x(n) to 1024. Plot using the
% semilogy() command once again, with the same logarithmic and linear
% window limits.

x1(1:40) = x;       % Populate the first 40 terms with the original shape
x1(41:1024) = 0;    % Zero-pad up to 1024.
n1d = 0:1023;       % 1024 element matrix.

figure(4)
w_F = abs(fft(x1)) + 1e-7;
x1d = 2*pi*n1d/1024;
semilogy(x1d, w_F)

xlim([0 2*pi])
ylim([1e-3 1e3])
xlabel('w')
ylabel('|X1(w)|')
title('Part 1-d. Frequency Spectrum |X1(w)|')

% Part 1-e.
% Discuss results, between the zero-padded matrix and the original "x"
% matrix, and what effect zero padding has, if it were to increase the
% number of present zeroes beyond 1024.

%% Part 2
%
% x(t) is a 78.125 Hz wave, and y(t) is a 52.0833 Hz wave. x(n) samples
% x(t), N = 128, ts = .001, or fs = 1000. N = 128 and fs = 1000 is also the
% parameters that y(t) will be sampled at for y(n). T = N*ts, which is 128
% samples and .001 millisecond spacing, or T=.128 signal length.

nt = 0:127;         % 128 samples
ftx = 78.125;       % x(t) frequency
fty = 52.0833;      % y(t) frequency
fst = 1000;         % 1 ms spacing is 1000 samples/sec. fs.
t = (1/fst)*nt;     % time axis


x128d = sin(2*pi*ftx*nt/fst);

y128d = sin(2*pi*fty*nt/fst);

v128d = 0.125.*x128d + y128d;   % 1/8(x(t)) + y(t)

% Part 2-a. 
% Plot X(m), Y(m), and V(m), and limit vertical axis 0 to 80 and
% the x axis 0 to 128.

figure(5)
stem(nt,abs(fft(x128d)))
title('Part 2-a. X(m) Spectra')
xlim([0 128])
ylim([0 80])
ylabel('|X(m)|')

figure(6)
stem(nt,abs(fft(y128d)))
xlim([0 128])
ylim([0 80])
title('Part 2-a. Y(m) Spectra')
ylabel('|Y(m)|')

figure(7)
stem(nt,abs(fft(v128d)))
xlim([0 128])
ylim([0 80])
title('Part 2-a. V(m) Spectra')
ylabel('|V(m)|')

% Part 2-b.
% Plot different window functions, of length 128. 4 plots of hanning,
% bartlett, rectangular, and blackman. Use semilogy(), from 0 to 1000 Hz
% and 1e-3 to 1e3.

x2b = 1000*n1d/1024;    % Use for Part 2-c. Modified omega.
n128 = 0:127;



figure(8)
rectangular_window(1:128) = rectwin(128);   % Rectangular Matrix
rectangular_window(129:1024) = 0;
rect_F = abs(fft(rectangular_window)) + 1e-7;
semilogy(x2b, rect_F)
xlim([0 1000])
ylim([1e-3 1e3])
title('Part 2-b. Rectangular Window Spectra')
ylabel('|Zr(F)|')

figure(9)
bartlett_window(1:128) = bartlett(128);     % Bartlett Matrix
bartlett_window(129:1024) = 0;
bart_F = abs(fft(bartlett_window)) + 1e-7;
semilogy(x2b, bart_F)
xlim([0 1000])
ylim([1e-3 1e3])
title('Part 2-b. Bartlett Window Spectra')
ylabel('|Zb(F)|')

figure(10)
hanning_window(1:128) = hann(128);          % Hanning Matrix
hanning_window(129:1024) = 0;
hann_F = abs(fft(hanning_window)) + 1e-7;
semilogy(x2b, hann_F)
xlim([0 1000])
ylim([1e-3 1e3])
title('Part 2-b. Hanning Window Spectra')
ylabel('|Zh(F)|')

figure(11)
blackman_window(1:128) = blackman(128);     % Blackman Matrix
blackman_window(129:1024) = 0;
black_F = abs(fft(blackman_window)) + 1e-7;
semilogy(x2b, black_F)
xlim([0 1000])
ylim([1e-3 1e3])
title('Part 2-b. Blackman Window Spectra')
ylabel('|Zbl(F)|')

% Part 2-c.
% Plot the different window functions, multiplied by different sampled
% functions.

x128d(129:1024) = 0;
xr = x128d.*rectangular_window; 	% Combining functions with windows.
xb = x128d.*bartlett_window;
xh = x128d.*hanning_window;
xbl = x128d.*blackman_window;


figure(12)
xr_F = abs(fft(xr))+1e-7;
semilogy(x2b,xr_F)
title('Part 2-c. X(n) Rectangular Windowed Spectra')
xlim([0 1000])
ylim([1e-3 1e3])
ylabel('|Xr(F)|')

figure(13)
xb_F = abs(fft(xb))+1e-7;
semilogy(x2b,xb_F)
xlim([0 1000])
ylim([1e-3 1e3])
title('Part 2-c. X(n) Bartlett Windowed Spectra')
ylabel('|Xb(F)|')

figure(14)
xh_F = abs(fft(xh))+1e-7;
semilogy(x2b,xh_F)
xlim([0 1000])
ylim([1e-3 1e3])
title('Part 2-c. X(n) Hanning Windowed Spectra')
ylabel('|Xh(F)|')

figure(15)
xbl_F = abs(fft(xbl))+1e-7;
semilogy(x2b,xbl_F)
xlim([0 1000])
ylim([1e-3 1e3])
title('Part 2-c. X(n) Blackman Windowed Spectra')
ylabel('|Xbl(F)|')

% Part 2-d. Same window, but applied to the y(n) function.

y128d(129:1024) = 0;
yr = y128d.*rectangular_window;
yb = y128d.*bartlett_window;
yh = y128d.*hanning_window;
ybl = y128d.*blackman_window;


figure(16)
yr_F = abs(fft(yr))+1e-7;
semilogy(x2b,yr_F)
title('Part 2-d. Y(n) Rectangular Windowed Spectra')
xlim([0 1000])
ylim([1e-3 1e3])
ylabel('|Yr(F)|')

figure(17)
yb_F = abs(fft(yb))+1e-7;
semilogy(x2b,yb_F)
xlim([0 1000])
ylim([1e-3 1e3])
title('Part 2-d. Y(n) Bartlett Windowed Spectra')
ylabel('|Yb(F)|')

figure(18)
yh_F = abs(fft(yh))+1e-7;
semilogy(x2b,yh_F)
xlim([0 1000])
ylim([1e-3 1e3])
title('Part 2-d. Y(n) Hanning Windowed Spectra')
ylabel('|Yh(F)|')

figure(19)
ybl_F = abs(fft(ybl))+1e-7;
semilogy(x2b,ybl_F)
xlim([0 1000])
ylim([1e-3 1e3])
title('Part 2-d. Y(n) Blackman Windowed Spectra')
ylabel('|Ybl(F)|')

%Part 2-e. Windowing the V(n) function.

v128d(129:1024) = 0;
vr = v128d.*rectangular_window;
vb = v128d.*bartlett_window;
vh = v128d.*hanning_window;
vbl = v128d.*blackman_window;


figure(20)
vr_F = abs(fft(vr))+1e-7;
semilogy(x2b,vr_F)
title('Part 2-e. V(n) Rectangular Windowed Spectra')
xlim([0 1000])
ylim([1e-3 1e3])
ylabel('|Vr(F)|')

figure(21)
vb_F = abs(fft(vb))+1e-7;
semilogy(x2b,vb_F)
xlim([0 1000])
ylim([1e-3 1e3])
title('Part 2-e. V(n) Bartlett Windowed Spectra')
ylabel('|Vb(F)|')

figure(22)
vh_F = abs(fft(vh))+1e-7;
semilogy(x2b,vh_F)
xlim([0 1000])
ylim([1e-3 1e3])
title('Part 2-e. V(n) Hanning Windowed Spectra')
ylabel('|Vh(F)|')

figure(23)
vbl_F = abs(fft(vbl))+1e-7;
semilogy(x2b,vbl_F)
xlim([0 1000])
ylim([1e-3 1e3])
title('Part 2-e. V(n) Blackman Windowed Spectra')
ylabel('|Vbl(F)|')