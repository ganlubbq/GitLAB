% qamderotate.m: derotate a complex-valued QAM signal
N=1000; j=sqrt(-1);                  % # symbols, time base
s=pam(N,2,1)+j*pam(N,2,1);           % signals of length N
phi=-0.1;                            % angle to rotate
r=s.*exp(-j*phi);                    % rotation
mu=0.01; theta=0; theta=zeros(1,N);  % initialize variables
for i=1:N-1                          % adapt through all data
  x=exp(j*theta(i))*r(i);            % x=rotated(r)
  x1=real(x); x2=imag(x);            % real and imaginary parts
  
  shat1=sign(x1); shat2=sign(x2);    % hard decisions
  %theta(i+1)=theta(i)-mu*(shat1*x2-shat2*x1); % iteration
  
  gamma = 1;
  theta(i+1)=theta(i)-mu*(((real(x))^2)-gamma)*real(x)*imag(x); % iteration
end
