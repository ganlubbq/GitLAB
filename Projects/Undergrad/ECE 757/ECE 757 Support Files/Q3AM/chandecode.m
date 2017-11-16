% Channel Decoding for 4QAM
% January 15, 2002
% Sean Leventhal, Katie Orlicki
% chandecode.m
%******************************************************************
% input: 
% data - data to be decoded
% H -  matrix to decode the data (lookup)
% syn - syndrome table to look up errors (lookup)
% ginv - pseudo inverse of G matrix used for coding (lookup)
% output: dec - decoded data
%******************************************************************

function dec = chandecode(data, H, syn, ginv)

dec = zeros(1,1);

[temp k] = size(H);
len=length(data);
if(mod(len,k) ~= 0)
    data=data(1:end-mod(len,k));
end

for i=1:k:length(data)
    y=data(i:i+k-1);
    eh=mod(y*H',2);
    ehind=1;
    for n=1:length(eh)
        ehind=ehind+eh(n)*2^(length(eh)-n);
    end
    %ehind=eh(1)*4+eh(2)*2+eh(3)+1; % turn syndrome into index
    e=syn(ehind,:);                % error from syndrome table
    y=mod(y+e,2);                  % add e to correct errors
    z=mod(y*ginv,2);        % decode corrected codeword
    
    dec = [dec z];
end

dec = dec(2:end);
