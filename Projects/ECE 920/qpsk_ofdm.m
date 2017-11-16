%% QPSK OFDM
%
% A signal is first QPSK modulated before being subjected to OFDM. The
% signal is then passed through an additive white Gaussian noise channel
% before demultiplexing and demodulation. Utilizes MATLAB System Objects.

M = 4;                  % Modulation alphabet
k = log2(M);            % Bits/symbol
numSC = 128;            % OFDM subcarriers
cpLen = 32;             % OFDM cyclic prefix length
maxBitErrors = 100;     % Maximum number of bit errors
maxNumBits = 1e7;       % Maximum number of bits transmitted

%% Construct OFDM Modems.
%
% This includes QPSK modulator, QPSK demodulator, OFDM modulator, OFDM
% demodulator, AWGN channel, and an error rate calculator.

qpskMod = comm.QPSKModulator('BitInput',true);
qpskDemod = comm.QPSKDemodulator('BitOutput',true);

ofdmMod = comm.OFDMModulator('FFTLength',numSC,'CyclicPrefixLength',cpLen);
ofdmDemod = comm.OFDMDemodulator('FFTLength',numSC,...
    'CyclicPrefixLength',cpLen);

channel = comm.AWGNChannel('NoiseMethod','Variance','VarianceSource',...
    'Input port');

errorRate = comm.ErrorRate('ResetInputPort',true);

ofdmDims = info(ofdmMod)
numDC = ofdmDims.DataInputSize(1)

frameSize = [k*numDC 1];

%% SNR and BER Vectors
%
% Statistic arrays, based on the desired Eb/No range, bits/symbol, and
% ratio of data subcarriers to the total number of subcarriers.

EbNoVec = (0:10)';
snrVec = EbNoVec + 10*log10(k) + 10*log10(numDC/numSC);
berVec = zeros(length(EbNoVec),3);
errorStats = zeros(1,3);

%% Simulation
%
% Simulates over the range of Eb/No values. For each Eb/No value, the
% simulation runs until either maxBitErrors are recorded or the total
% number of transmitted bits exceeds maxNumBits.

for m = 1:length(EbNoVec)
    snr = snrVec(m);
    
    while errorStats(2) <= maxBitErrors && errorStats(3) <= maxNumBits
        dataIn = randi([0 1],frameSize);    % Generate binary data
        qpskTx = qpskMod(dataIn);           % Apply QPSK Modulation
        txSig = ofdmMod(qpskTx);            % OFDM modulation
        powerDB = 10*log10(var(txSig));     % Tx Signal Power
        noiseVar = 10.^(0.1*(powerDB-snr)); % Noise Variance
        rxSig = channel(txSig,noiseVar);    % Pass through channel
        qpskRx = ofdmDemod(rxSig);          % OFDM demodulation
        dataOut = qpskDemod(qpskRx);        % QPSK demodulation
        errorStats = errorRate(dataIn,dataOut,0);
    end
    
    berVec(m,:) = errorStats;                   % Save BER data
    errorStats = errorRate(dataIn,dataOut,1);   % Reset the calculator
end

berTheory = berawgn(EbNoVec,'psk',M,'nodiff');  % Theoretical BER for QPSK

figure(1)
semilogy(EbNoVec,berVec(:,1),'o')
hold on
semilogy(EbNoVec,berTheory)
legend('Simulation','Theory','Location','Best')
xlabel('Eb/No (dB)')
ylabel('Bit Error Rate')
grid on
hold off