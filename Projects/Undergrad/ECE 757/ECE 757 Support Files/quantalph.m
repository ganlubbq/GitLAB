% y=quantalph(x,alphabet)
%
% quantize the input signal x to the alphabet
% using nearest neighbor method
% input x - vector to be quantized
%       alphabet - vector of discrete values that y can take on
%                  sorted in ascending order
% output y - quantized vector
function y=quantalph(x,alphabet)
alphabet=alphabet(:);
x=x(:);
alpha=alphabet(:,ones(size(x)))';
dist=(x(:,ones(size(alphabet)))-alpha).^2;
[v,i]=min(dist,[],2);
y=alphabet(i);

