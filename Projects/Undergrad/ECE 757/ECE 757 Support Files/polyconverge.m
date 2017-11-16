% polyconverge.m find the minimum of J(x)=x^2-4x+4 via steepest descent
N=500;                          % number of iterations
mu=.01;                         % algorithm stepsize
x=zeros(1,N);                   % initialize x to zero
x(1)=3;                         % starting point x(1)
for k=1:N-1
  x(k+1)=(1-2*mu)*x(k)+4*mu;    % update equation
end
