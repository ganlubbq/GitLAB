function [r, s]=BigTransmitter(m, frameParams, rfParams, chanParams)

% re-organize m
linesOfText=floor(size(m,2)/frameParams.userDataLength);
numUsers=size(m,1);
m2=zeros(linesOfText,frameParams.userDataLength,numUsers);
for i=1:numUsers
    m2(:,:,i)=reshape(m(i,1:frameParams.userDataLength*linesOfText),frameParams.userDataLength,linesOfText)';
end

% insert training & header
m3=reshape([repmat([frameParams.preamble],linesOfText,1) m2(:,:)]',(length(frameParams.preamble)+frameParams.userDataLength*numUsers)*linesOfText,1);

% encode characters into 4-PAM source vector
if frameParams.bitEncodingFlag
    s=text2bin(m3);  % convert to 7-bit ASCII
    if frameParams.chanCodingFlag  % perform channel coding if necessary
        g=[1 0 1 0 1;   % channel code generator matrix
           0 1 0 1 1];
        s=reshape(mod(reshape(s,2,length(s)/2)'*g,2)',length(s)*5/2,1)';
    end
    s=(4*s(1:2:end)+2*s(2:2:end))-3; % convert from bits to 4-PAM
else
    s=letters2pam(m3);
end

% generate received signal (transmitter RF frontend --> channel --> sampled-IF receiver)
r0=Tx_rf(s, rfParams, chanParams);

% generate adjacent channel interferers with random 4-PAM data
if chanParams.adjacentUser1Power~=-Inf
    chanParamsIntf1=chanParams;
    rfParamsIntf1=rfParams;
    rfParamsIntf1.f_if=chanParams.adjacentUser1f_if;
    chanParamsIntf1.c1=chanParams.adjacentUser1Chan;
    chanParamsIntf1.c2=chanParams.adjacentUser1Chan;
    chanParamsIntf1.randomWalkVariance=0;
    r1=Tx_rf(floor(rand(size(s))*4)*2-3, rfParamsIntf1, chanParamsIntf1);
else
    r1=0;
end
if chanParams.adjacentUser2Power~=-Inf
    chanParamsIntf2=chanParams;
    rfParamsIntf2=rfParams;
    rfParamsIntf2.f_if=chanParams.adjacentUser2f_if;
    chanParamsIntf2.c1=chanParams.adjacentUser2Chan;
    chanParamsIntf2.c2=chanParams.adjacentUser2Chan;
    chanParamsIntf2.randomWalkVariance=0;
    r2=Tx_rf(floor(rand(size(s))*4)*2-3, rfParamsIntf2, chanParamsIntf2);
else
    r2=0;
end

% add interferers and noise
r=r0+cos(2*pi*chanParams.NBIfreq*[1:length(r0)]'/rfParams.f_s)*sqrt(2)*10^(chanParams.NBIPower/20)+randn(size(r0))*10^(-chanParams.SNR/20)*sqrt(rfParams.f_s*rfParams.T_t)...
    +r1*10^(chanParams.adjacentUser1Power/20)+r2*10^(chanParams.adjacentUser2Power/20);

% perform AGC
r=r/norm(r)*sqrt(length(r));

end

function r=Tx_rf(s, rfParams, chanParams);

% introduce error into transmitter IF and baud timing
rfParams.f_if_tx=rfParams.f_if*(1+rfParams.f_if_err/100);
rfParams.T_t_tx=rfParams.T_t*(1+rfParams.T_t_err/100);

% determine suitable oversampling/downsampling factor
[M N]=rat(rfParams.f_s*rfParams.T_t_tx);

% generate pulse-shaped signal
x=conv(srrc(rfParams.SRRCLength,rfParams.SRRCrolloff,M,0)',upsample(s,M))';

% generate phase noise process
p_noise=cumsum(randn(size(x))*sqrt(rfParams.phaseNoiseVariance/N));

% mix signal to RF (well, technically IF)
x_rf=x.*cos(2*pi*rfParams.f_if_tx*[1:length(x)]'*rfParams.T_t_tx/M+p_noise);
clear x p_noise  % free up a little memory by tossing intermediate variables

% pass through time-varying BP channel
if sum(chanParams.c1==chanParams.c2)==length(chanParams.c1) & chanParams.randomWalkVariance==0 % simpler case if user didn't specify a time-varying channel
    x_chanOut=conv(upsample(chanParams.c1,M),x_rf);
else
    upsampledChannelLength=length(chanParams.c1)*M;
    resultLength=length(x_rf)+upsampledChannelLength-1;
    x_rf=[zeros(upsampledChannelLength-1,1); x_rf; zeros(upsampledChannelLength-1,1)];
    x_chanOut=zeros(resultLength,1);
    c=upsample(chanParams.c1,M); c=c(:);
    c_delta=upsample((chanParams.c2-chanParams.c1)/(resultLength-1),M); c_delta=c_delta(:);
    for i=1:resultLength
        c=c+c_delta;
        c(1:M:upsampledChannelLength)=c(1:M:upsampledChannelLength)+randn(size(chanParams.c1))'*chanParams.randomWalkVariance;
        x_chanOut(i)=c'*x_rf(i+upsampledChannelLength-1:-1:i);
    end
end
clear x_rf

% perform downsampling, normalization
r=x_chanOut(1:N:end);
r=r(:)*sqrt(length(r))/norm(r);

end
