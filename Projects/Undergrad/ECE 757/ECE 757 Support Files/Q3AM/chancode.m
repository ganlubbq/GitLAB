% Channel Coding for 4QAM
% January 15, 2002
% Sean Leventhal, Katie Orlicki
% chancode.m
%******************************************************************
% input: 
% data - data to be coded in binary form
% G -  matrix to code the data (lookup)
% output: coded - coded data
%******************************************************************

function coded=chancode(data, G)

coded = zeros(1,1);

[k temp] = size(G);
len=length(data);
if(mod(len,k) ~= 0)
    data=[data zeros(1,k-mod(len,k))];
end

for i=1:k:length(data)
    x=data(i:i+k-1);
    M=x*G;
    coded = [coded mod(M,2)];
end

coded = coded(2:end);
