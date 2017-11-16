function y=interpsinc(x, t, l, beta)
% y=interpsinc(x, t, l, beta)
% interpolate to find a single point using the direct method
%        x = sampled data
%        t = place at which value desired
%        l = one sided length of data to interpolate
%        beta = rolloff factor for srrc function
%             = 0 is a sinc
if nargin==3, beta=0; end;           % if unspecified, beta is 0
tnow=round(t);                       % create indices tnow=integer part
tau=t-round(t);                      % plus tau=fractional part
s_tau=srrc(l,beta,1,tau);            % interpolating sinc at offset tau
x_tau=conv(x(tnow-l:tnow+l),s_tau);  % interpolate the signal
y=x_tau(2*l+1);                      % the new sample

