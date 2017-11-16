%% cdma.m
%
% Jordan R. Smith
% ECE 920 - Wireless Communication Systems
%
% Create a MATLAB simulation of a CDMA down link scenario to experiment
% with how a system works in the presence of noise and code and power
% mismatch. Setup the system as follows:
%
% Length-16 Walsh codes: ci = {1, -1}
% Random sequence of K bits for two users: si = {-1, 1}
% Receiver as presented in class, i.e. the kth bit is
% sgn(sum(1->L)r[k]c[k]/L)
%
% With the system create the following scenarios to test the performance of
% your system and report the input the receiver and the output of the
% receiver.
%
% 1. Perfect Channel
% 2. Channel with AWGN for each transmitted bit. Use n*randn and show the
% decision output for different levels of noise.
% 3. Receiver code offset of tau = {1,2,5} bits due to the channel.
% 4. Increase the amplitude of one of the signals and then add them
% together to simulate the "near-far" problem.

clear all, close all, clc;

%% Length-16 Walsh codes

J = 16;                                          % Length of Walsh function
hadamardMatrix = hadamard(J);                    % Hadamard Generation
HIndex = 0:J-1;                                  % Hadamard Indexing
M = log2(J)+1;                                   % Number of bits for index
binHIndex = fliplr(dec2bin(HIndex,M))-'0';       % Index bits reversal
binSeqIndex = zeros(J,M-1);                      % Matrix generation
for k = M:-1:2                                   % Binary Sequencing index
    binSeqIndex(:,k) = xor(binHIndex(:,k),binHIndex(:,k-1));
end
SequenceIndex = binSeqIndex*pow2((M-1:-1:0)');   % Binary to integer
walshMatrix = hadamardMatrix(SequenceIndex+1,:); % 1-based indexing

u1 = walshMatrix(1,:);                           % First User Signal
u2 = walshMatrix(2,:);                           % Second User Signal

figure(1)
subplot(2,1,1)
bar(u1,1,'b');grid;title('First & Second Walsh Codes');ylabel('User_1');
xlabel('Bit Number (n)');
ylim([-1 1]);
subplot(2,1,2)
bar(u2,1,'b');grid;ylabel('User_2');
xlabel('Bit Number (n)');
ylim([-1 1]);

%% Random sequence of K-bits for two users

K = 8;                  % K-bits.
rng shuffle;            % shuffle the random seeder.
c1 = randi([0 1],K,1);  % generate random valued message.
c1 = c1.';              % transpose.

rng shuffle;            % shuffle the seeder again.
c2 = randi([0 1],K,1);  % generate random valued message.
c2 = c2.';              % transpose.

for i = 1:K             % modify matrices to instead have 0 = -1.
    if c1(1,i) == 0
        c1(1,i) = -1;
    end
    if c2(1,i) == 0     % can't be else-if, due to separate casing.
        c2(1,i) = -1;
    end
end

c1 = [c1 c1];           % double to show periodicity for walsh-16 input.
c2 = [c2 c2];           % double for W16 again.

figure(2)
subplot(2,1,1)
bar(c1,1,'b');
grid;title(['Random Sequence of K = ',num2str(K),' bits for 2 Users'])
ylabel('User 1');ylim([-2 2]); xlabel('Bit Number (n)')
xlim([1 2*K]);
subplot(2,1,2)
bar(c2,1,'b');grid;ylabel('User 2');ylim([-2 2]);xlabel('Bit Number (n)');
xlim([1 2*K]);

%% Transmitter
%
% With a data signal and a pseudo-random code, multiply the two to form
% the transmitted signal. The "chip" code is the walsh code, intentionally
% meant to be orthogonal.

tx1 = c1.*u1;   % Combines first row of Walsh Matrix with PN code.
tx2 = c2.*u2;   % Combines second row of Walsh Matrix with PN code.

figure(3)
subplot(3,1,1);bar(c1,1,'b');grid;title('PN Code');ylabel('U_1');
subplot(3,1,2);bar(u1,1,'b');grid;title('User Code');ylabel('U_1');
subplot(3,1,3);bar(tx1,1,'b');grid;title('T_X Code');ylabel('U_1');

figure(4)
subplot(3,1,1);bar(c2,1,'b');grid;title('PN Code');ylabel('U_2');
subplot(3,1,2);bar(u2,1,'b');grid;title('User Code');ylabel('U_2');
subplot(3,1,3);bar(tx2,1,'b');grid;title('T_X Code');ylabel('U_2');

%% Channel
%
% This is where Tau offset, AWGN, Amplitude increase, or perfect channel
% will interface with the transmitted code.
%
% The AWGN scenario has white gaussian noise applied to each combined
% transmitted bit.
%
% Amplitude increase should be applied to only "Tx1" or "Tx2" to simulate
% the near-far problem of power control.

% tx1 = channel('amplitude',tx1,level); % User 1 is closer.

Tx = tx1 + tx2;                       % both transmitters on the channel.

Rx = channel('amplitude',Tx,1);       % perfect case.

figure(5)
subplot(2,1,1);bar(Tx,1,'b');grid;title('Transmitted Code');
subplot(2,1,2);bar(Rx,1,'b');grid;title('Received Code');

%% Receiver
%
% multiply each component of the received signal with the PN code that was
% present at the transmitter, and take the summer output divided by length
% L, or J in this script. 
% 
% NOTE: Specific to K=8 time slices per frame. only
% first and second walsh codes will operate correctly with this receiver
% design.

for i = 1:K                             % First Time Frame.
    rx1_1(1,i) = Rx(1,i)*c1(1,i);
    rx2_1(1,i) = Rx(1,i)*c2(1,i);
end

Rx1_frame1 = sum(rx1_1) / K;            % First User, Frame 1.
Rx1_frame1 = sign(Rx1_frame1);

Rx2_frame1 = sum(rx2_1) / K;            % Second User Frame 1.
Rx2_frame1 = sign(Rx2_frame1);

for i = 1:K                             % Second Time Frame.
    m = i+K;                            % Offset from original for loop.
    rx1_2(1,m-K) = Rx(1,m)*c1(1,m);
    rx2_2(1,m-K) = Rx(1,m)*c2(1,m);
end

Rx1_frame2 = sum(rx1_2) / K;            %  First User, Frame 2.
Rx1_frame2 = sign(Rx1_frame2);

Rx2_frame2 = sum(rx2_2) / K;            % Second User, Frame 2.
Rx2_frame2 = sign(Rx2_frame2);


Rx1(1,1:K) = Rx1_frame1;                % form orginal chirp code.
Rx1(1,K+1:J) = Rx1_frame2;

Rx2(1,1:K) = Rx2_frame1;                % form orthogonal code.
Rx2(1,K+1:J) = Rx2_frame2;

figure(6)
subplot(3,1,1);bar(Rx,1,'b');grid;
title('Input of Receiver');
subplot(3,1,2);bar(Rx1,1,'b');grid;title('Received U1 Code');
subplot(3,1,3);bar(Rx2,1,'b');grid;title('Received U2 Code');


figure(7)
subplot(4,1,1)
bar(u1,1,'b');grid;title('Original U_1');
subplot(4,1,2)
bar(u2,1,'b');grid;title('Original U_2');
subplot(4,1,3)
bar(Rx1,1,'r');grid;title('Received U_1');
subplot(4,1,4)
bar(Rx2,1,'r');grid;title('Received U_2');

%% Channel Imperfections Function (Place at Bottom of Script.)
%
% This function will determine what effect to apply to the channel.
% 'Amplitude' will multiply a coefficient. channel('amplitude',rx1,1) will
% apply the perfect channel scenario. AWGN represents the additive white
% gaussian noise, with "arg" being the noise amplitude. Tau will apply the
% timing offset to each row, based on whether its 1, 2, or 5.

function recv = channel(type,trans,arg)
   if strcmp('awgn',type)                % Additive White Gaussian Noise
       awg = arg*randn(size(trans,2),1); % Arg represents noise level.
       awg = awg.';                      % transpose.
       recv = awg + trans;               % AWGN applied to signal. (ADD)
   elseif strcmp('amplitude',type)       % Amplitude and Perf. Chan. Case.
       recv = arg.*trans;
   elseif strcmp('tau',type)             % Tau timing offset.
       if(arg == 1)                      % Tau = 1.
          recv = circshift(trans,1,2); 
       elseif(arg == 2)                  % Tau = 2.
          recv = circshift(trans,2,2);
       elseif(arg == 5)                  % Tau = 5.
          recv = circshift(trans,5,2);
       else
           recv = 0;                     % sets value to zero.
           disp('Error! Incorrect Tau'); % indicate the actual error.
       end
   else
       recv = 0;                         % zero out the value.
       disp('Error! Incorrect Effect');  % indicates wrong string input.
   end
end