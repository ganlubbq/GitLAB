%% A test file to extract one IMF.
% Does it two ways - using hermite and cubic interpolation for the
% envelopes, and compares the results. (They are very similar.)
t = 0:1/1000:1 * pi;
x = sin(10*t) + sin(30*t);
LX = numel(x);


numiter = 10;

tic
d= zeros(numiter+1,LX);
d(1,:) = x;
for n = 1:numiter;
    [imin imax izer] = extr(d(n,:));
    emax = hermite_spline(imax,d(n,imax),1:LX);
    emin = hermite_spline(imin,d(n,imin),1:LX);
    m = mean([emax;emin]);
    d(n+1,:) = d(n,:) - m;
end
toc

tic
q = x;
q= zeros(numiter+1,LX);
q(1,:) = x;
for n = 1:numiter;
    [imin imax izer] = extr(q(n,:));
    emax = spline(imax,q(n,imax),1:LX);
    emin = spline(imin,q(n,imin),1:LX);
    m = mean([emax;emin]);
    q(n+1,:) = q(n,:) - m;
end
toc

close all;
plot(t,d(end,:),t,q(end,:))
legend('hermite','cubic')
