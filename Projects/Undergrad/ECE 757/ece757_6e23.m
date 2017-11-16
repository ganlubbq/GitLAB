% polyconverge.m find the minimum of J(x)=x^2-4x+4 via steepest descent
N=500;                          % number of iterations


mu1=-.01                          % algorithm stepsize
x=zeros(1,N);                   % initialize x to zero
x(1)=0;                         % starting point x(1)
for k=1:N-1
  x(k+1)=(1-2*mu1)*x(k)+4*mu1;    % update equation
end

figure(1)
hold on
plot(x,'b')

mu2= 0                          % algorithm stepsize
x2=zeros(1,N);                   % initialize x to zero
x2(1)=3;                         % starting point x(1)
for k=1:N-1
  x2(k+1)=(1-2*mu2)*x2(k)+4*mu2;    % update equation
end

plot(x2,'r')

mu3= 0.0001                      % algorithm stepsize
x3=zeros(1,N);                   % initialize x to zero
x3(1)=3;                         % starting point x(1)
for k=1:N-1
  x3(k+1)=(1-2*mu3)*x3(k)+4*mu3;    % update equation
end

plot(x3,'r--')

mu4= 0.02                        % algorithm stepsize
x4=zeros(1,N);                   % initialize x to zero
x4(1)=3;                         % starting point x(1)
for k=1:N-1
  x4(k+1)=(1-2*mu4)*x4(k)+4*mu4;    % update equation
end

plot(x4,'b--')

mu5= .03                          % algorithm stepsize
x5=zeros(1,N);                   % initialize x to zero
x5(1)=3;                         % starting point x(1)
for k=1:N-1
  x5(k+1)=(1-2*mu5)*x5(k)+4*mu5;    % update equation
end

plot(x5,'g')

mu6 = .05                          % algorithm stepsize
x6=zeros(1,N);                   % initialize x to zero
x6(1)=3;                         % starting point x(1)
for k=1:N-1
  x6(k+1)=(1-2*mu6)*x6(k)+4*mu6;    % update equation
end

plot(x6,'r:')
ylim([1.5 3.5]);
legend('mu = -0.01','mu = 0', 'mu = 0.0001', 'mu = 0.02', 'mu = 0.03', ... 
    'mu = 0.05')
xlabel('Iterations')
ylabel('Minimum Value')
title('Exercise 6.23-b N=5000')
hold off

%%

x1=zeros(1,N);                   % initialize x to zero
x1(1)=-5;                        % starting point x(1)
for k=1:N-1
  x1(k+1)=(1-2*mu)*x1(k)+4*mu;    % update equation
end

figure
hold on
plot(x1,'b')

x2=zeros(1,N);                   % initialize x to zero
x2(1)=-1;                       % starting point x(1)
for k=1:N-1
  x2(k+1)=(1-2*mu)*x2(k)+4*mu;    % update equation
end

plot(x2,'r--')

x3=zeros(1,N);                   % initialize x to zero



x3(1)=1;                       % starting point x(1)
for k=1:N-1
  x3(k+1)=(1-2*mu)*x3(k)+4*mu;    % update equation
end

plot(x3,'b--')

x4=zeros(1,N);                   % initialize x to zero
x4(1)=5;                       % starting point x(1)
for k=1:N-1
  x4(k+1)=(1-2*mu)*x4(k)+4*mu;    % update equation
end

plot(x4,'b:')

x5=zeros(1,N);                   % initialize x to zero



x5(1)=30;                       % starting point x(1)
for k=1:N-1
  x5(k+1)=(1-2*mu)*x5(k)+4*mu;    % update equation
end


plot(x5,'r:')
hold off
title('Exercise 6.23-c.')
legend('x(1)=-5','x(1)=-1','x(1)=1','x(1)=5','x(1)=30')