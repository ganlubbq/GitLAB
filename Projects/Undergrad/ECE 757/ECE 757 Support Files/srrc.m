function s=srrc(syms, beta, P, t_off);

% s=srrc(syms, beta, P, t_off);
% Generate a Square-Root Raised Cosine Pulse
%      'syms' is 1/2 the length of srrc pulse in symbol durations
%      'beta' is the rolloff factor: beta=0 gives the sinc function
%      'P' is the oversampling factor
%      't_off' is the phase (or timing) offset

if nargin==3, t_off=0; end;                       % if unspecified, offset is 0
k=-syms*P+1e-8+t_off:syms*P+1e-8+t_off;           % sampling indices as a multiple of T/P
if (beta==0), beta=1e-8; end;                     % numerical problems if beta=0
s=4*beta/sqrt(P)*(cos((1+beta)*pi*k/P)+...        % calculation of srrc pulse
  sin((1-beta)*pi*k/P)./(4*beta*k/P))./...
  (pi*(1-16*(beta*k/P).^2));

