% f = letters2pam(str)
% encode a string of ASCII text into +/-1, +/-3

function f = letters2pam(str);           % call as Matlab function
N=length(str);                           % length of string
f=zeros(1,4*N);                          % store 4-PAM coding here
for k=0:N-1                              % change to "base 4"
  f(4*k+1:4*k+4)=2*(dec2base(double(str(k+1)),4,4))-99;
end
