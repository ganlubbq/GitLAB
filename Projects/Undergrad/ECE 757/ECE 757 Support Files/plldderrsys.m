% plldderrsys.m: error surface for decision directed phase tracking

N=1000;                           % average over N symbols,
m=pam(N,4,5);                     % use 4-PAM symbols
phi=-1.0;                         % unknown phase offset phi
theta=-2:.01:6;                   % grid for phase estimates
for k=1:length(theta)             % for each possible theta
  x=m*cos(phi-theta(k));          % find x with this theta
  qx=quantalph(x,[-3,-1,1,3]);    % q(x) for this theta
  jtheta(k)=(qx'-x)*(qx'-x)'/N;   % cost for this theta
end
plot(theta,jtheta)                % plot J(theta) vs theta
xlabel('Phase Estimates \theta')
ylabel('Cost J(\theta)' )

