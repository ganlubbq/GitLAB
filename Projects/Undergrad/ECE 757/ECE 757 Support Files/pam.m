% seq=pam(len,M,Var);
% Create an M-PAM source sequence with
% length 'len'  and variance 'Var'
function seq=pam(len,M,Var);
seq=(2*floor(M*rand(1,len))-M+1)*sqrt(3*Var/(M^2-1));
