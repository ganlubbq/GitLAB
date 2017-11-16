N = 4;
io = 1;
n = 3;

X = (sqrt(3*N))^n;

SIR = 10*log10(X/io);

fprintf('SIR = %f dB\n',SIR)