clear all;
close all;
clf;
clc;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%  Transmitter  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Timing variables
fm = 1*10^3; % message frequency
td = 1/(16*fm); % time step for displaying signal (NOT SAMPLING RATE)
duration = 2;
t = [0:td:duration]; % Duration of transmission

%------------------------------A - Message---------------------------%
m = cos(fm*t) + 0.5*cos(2*fm*t).^2 + 2*cos(fm*t-2).^3 + cos(2*fm*t).^4;
Lsig = length(m); %Length of signal message

%----------------------B - Sampling and Quantization-----------------%
ts = 1/(8*fm); %Sample time: choose(4,8,12,16)
L = 16; % Quantization levels: choose(2...16)
n = log2(L); % number of bits


[s_out,sq_out,sqh_out,qindex,Delta,SQNR] = sampandquant(m,L,td,ts);

%
%
%
%
%
%
%	Plot message and quantized signal
%
%
%
%
%
figure(1)
plot(t,m,'k')
hold on
stairs(t,sqh_out(1:Lsig),'b')
title('Part B - Message & Quantized Signal')
xlabel('time(seconds)')
ylabel('Message m(t)')

%-----------------------C - M-QAM Modulation-------------------------%
M = 64; %M-ary constellation size
k = log2(M); % Number of bits per symbol

% Create bit stream
qindex = qindex-1;
bits = reshape(dec2bin(qindex,n)',1,[]);
L_bits = length(bits)

for i=1:L_bits
	bit_stream(1,i) = str2num(bits(i));
end

% Pad bit stream with extra bits to make a round num of symbols
pad = k - rem(length(bit_stream),k);
bit_stream = [bit_stream zeros(1,pad)]';


% Modulate with M-ary communication
T = modem.qammod(M);
T.InputType = 'bit';
sym_stream = modulate(T,bit_stream);
L_sym = length(sym_stream)

%
%
%
%
%
%
%	PLOT CONSTELLATION (no lines between symbols, just use '*')
%	See axis scaling from constellation plot below
%	Note: Constellations do not need x and y axis labels
%
%
%
%
figure(2)
plot([1:L_sym],sym_stream,'*')
title('Part C - M-QAM Constellation Diagram M = 4, P = 1')

% Dummy variable to plot sym_stream vs. pulse shape
f_ovsamp = 8;
ss_up = conv(upsample(sym_stream,f_ovsamp),[1 1 1 1 1 1 1 1]); 





%---------------------------D - PULSE SHAPE--------------------------%
delay_rc = 4;

%Pulse shaper - raised cosine - index = 0.5
prcos = rcosflt([1], 1, f_ovsamp, 'sqrt', 0.5, delay_rc); % Pulse filter
prcos = prcos(1:end-f_ovsamp+1);
prcos = prcos/norm(prcos);

pcmatch = prcos(end:-1:1); %Matched filter for pulse shaper

% Upsample for convolution and convolute symbol stream with pulse shaper
sym_stream_f = conv(upsample(sym_stream,f_ovsamp),prcos); 
L_sym_shp = length(sym_stream_f);




%
%
%
%
%
%
%	PLOT I and Q of the quantized and pulse shaped symbols
%
%
%
%
%
figure(3)
subplot(211)
plot(1:L_sym_shp-64,3*real(sym_stream_f(32:end-33)),'k')
hold on                                          
stairs(1:L_sym_shp-64,real(ss_up(1:end-7)),'b')
title('Part D - Quantized I Data with and without Pulse Shaping')
xlabel('Message Index');
ylabel('Message Magnitude');
legend('Signal','Pulse Shaping')

subplot(212)
plot(1:L_sym_shp-64,3*imag(sym_stream_f(32:end-33)),'k')
hold on                                          
stairs(1:L_sym_shp-64,imag(ss_up(1:end-7)),'b') 
title('Quantized Q Data with and without Pulse Shaping')
xlabel('Message Index');
ylabel('Message Magnitude');
legend('Signal','Pulse Shaping')
%--------------------------Upconvert-----------------------------%
%
%
%
%
%
%
% 	Extra credit (20 pts)
%		Write code that:
%			properly modulates the pulse shaped I and Q
%			carrier frequency of fc = 2.4*10^9
%			demodulates with a filter
%			plot modulated signal and recovered signal
%
%
%	You do not need this code to go into the next step
%
%
%-------------------------Downconvert----------------------------%





%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Channel  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%--------------------------E - Add noise-----------------------------%
noise = randn(L_sym_shp,1)+j*randn(L_sym_shp,1); % Gaussian noise

Es = 10; % Symbol power

power = 10;
Eb_N = power * 2; % Bit energy to noise ratio in dB 
Eb_N_num = 10^(Eb_N/10); % in numeral
Var_n = Es/(2*Eb_N_num);  % 1/SNR in noise variance
signoise = sqrt(Var_n/2); % std dev
awgnoise = (signoise * noise); % AWGN

received  = sym_stream_f + awgnoise; % Received signal

%
%
%
%
%
%
%	PLOT I and Q of the received signal with noise
%
%
%
%
%
figure(4)
subplot(2,1,1)
plot(1:L_sym_shp,real(sym_stream_f),'k',1:L_sym_shp,real(received),'b')
title('Part E - Received I Signal with Noise')
xlabel('Received Message Index');
ylabel('Rec. Message Magnitude');

subplot(2,1,2)
plot(1:L_sym_shp,imag(sym_stream_f),'k',1:L_sym_shp,imag(received),'r')
title('Received Q Signal with Noise')
xlabel('Received Message Index');
ylabel('Rec. Message Magnitude');


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Receiver  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%--------------------------F - Noise Filter-----------------------------%

%
%
% 
% 	Extra Credit (5 pts)
%		Filter the received signal to reduce noise
%			-code will run even without this step working
%
%
% 	
%
%
%

%--------------------------G - Matched Filter----------------------------%
y_out = conv(received,pcmatch);
delayrc = 2*delay_rc*f_ovsamp; % Filter delay



%-------------------------------H - Re-sample----------------------------%
y_out = y_out(delayrc+1:f_ovsamp:end); 


%
%
%
%
%
%
%	PLOT CONSTELLATION now with noise (no lines between symbols, just use '*')		
%		when
%			power = 10,5,1
%			M = 4,16,64
%		set 	
%			duration = 2
%
%
%
%
%
figure(5)
plot(y_out(1:end-8),'*')
axis([min(real(y_out))-0.5 max(real(y_out))+0.5 min(imag(y_out))-0.5 max(imag(y_out))+0.5 ])
title('Part H - Symbol Constellation with Noise M = 64, power = 10')

%-----------------------------I - Decision-------------------------------%
% Create symbols with a decision system
dec = sign(real(y_out(1:L_sym)))+sign(real(y_out(1:L_sym))-2) + ...
	sign(real(y_out(1:L_sym))+2)+...
	j*(sign(imag(y_out(1:L_sym)))+sign(imag(y_out(1:L_sym))-2) + ...
	sign(imag(y_out(1:L_sym))+2));




%----------------------------J - Demodulate------------------------------%
R = modem.qamdemod(M);
R.OutputType = 'bit';
out = demodulate(R,dec)'; % Demodulate symbols to bits
out = out(1:end-pad); % Same as bits. remove the padding
bits_recvd = num2str(out')';
qindex_recvd = bin2dec(reshape(bits_recvd,n,[])')'; %bits to quantized levels


%
%
%
%
%
%
%	Plot output quantized signal
%
%
%
%
%
figure(6)
plot(qindex_recvd)
axis([1 81 0 16])
title('Part J - Output Quantized Signal')
xlabel('Signal Index')
ylabel('Quantized Magnitude')
%----------------------------K - Analysis------------------------------%

B_err = sum(bits ~= bits_recvd(1:length(bits))) % Number of bit errors
B_R_err = B_err/length(bits) % Error rate 

