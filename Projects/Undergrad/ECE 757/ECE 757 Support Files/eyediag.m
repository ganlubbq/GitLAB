% eyediag.m plot eye diagrams for pulse shape ps
N=1000; m=pam(N,2,1);            % random signal of length N
M=20; mup=zeros(1,N*M);          % oversampling factor of M
mup(1:M:N*M)=m;                  % oversample by M
ps=hamming(M);                   % hamming pulse of width M
x=filter(ps,1,mup);              % convolve pulse shape
neye=5;                          % size of groups
c=floor(length(x)/(neye*M));     % number of eyes to plot
xp=x(N*M-neye*M*c+1:N*M);        % ignore transients at start
figure(1)
plot(reshape(xp,neye*M,c))       % plot in groups
figure(1)
title('Eye diagram for hamming pulse shape')

figure(2)                      % used to plot figure eyediag3
N=1000; m=pam(N,2,1);          % random +/-1 signal of length N
M=20; mup=zeros(1,N*M); mup(1:M:N*M)=m;  % oversampling by factor of M
ps=ones(1,M);                            % square pulse width M
x=filter(ps,1,mup);            % convolve pulse shape with mup
neye=5;
c=floor(length(x)/(neye*M))
xp=x(N*M-neye*M*c+1:N*M);      % dont plot transients at start
q=reshape(xp,neye*M,c);        % plot in clusters of size 5*Mt=(1:198)/50+1;
subplot(3,1,1), plot(q)
title('Eye diagram for rectangular pulse shape')

N=1000; m=pam(N,2,1);          % random +/-1 signal of length N
M=20; mup=zeros(1,N*M); mup(1:M:N*M)=m;  % oversampling by factor of M
ps=hamming(M);                           % square pulse width M
x=filter(ps,1,mup);            % convolve pulse shape with mup
%x=x+0.15*randn(size(x));
neye=5;
c=floor(length(x)/(neye*M))
xp=x(N*M-neye*M*c+1:N*M);      % dont plot transients at start
q=reshape(xp,neye*M,c);        % plot in clusters of size 5*Mt=(1:198)/50+1;
subplot(3,1,2), plot(q)
title('Eye diagram for hamming pulse shape')

N=1000; m=pam(N,2,1);          % random +/-1 signal of length N
M=20; mup=zeros(1,N*M); mup(1:M:N*M)=m;  % oversampling by factor of M
L=10; ps=srrc(L,0,M,50);
ps=ps/max(ps);         % sinc pulse shape L symbols wide
x=filter(ps,1,mup);    % convolve pulse shape with mup
%x=x+0.15*randn(size(x));
neye=5;
c=floor(length(x)/(neye*M))
xp=x(N*M-neye*M*(c-3)+1:N*M);  % dont plot transients at start
q=reshape(xp,neye*M,c-3);      % plot in clusters of size 5*Mt=(1:198)/50+1;
subplot(3,1,3), plot(q)
axis([0,100,-3,3])
title('Eye diagram for sinc pulse shape')

figure(3)
N=1000; m=pam(N,4,5);          % random +/-1 signal of length N
M=20; mup=zeros(1,N*M); mup(1:M:N*M)=m;  % oversampling by factor of M
ps=hamming(M);                           % square pulse width M
x=filter(ps,1,mup);    % convolve pulse shape with mup
%x=x+0.15*randn(size(x));
neye=5;
c=floor(length(x)/(neye*M))
xp=x(N*M-neye*M*c+1:N*M);   % dont plot transients at start
q=reshape(xp,neye*M,c);     % plot in clusters of size 5*Mt=(1:198)/50+1;
t=(1:neye*M)/M;
subplot(4,1,1), plot(t,q)
hold on
title('Eye diagram for the T-wide hamming pulse shape')

N=1000; m=pam(N,4,5);                    % random signal of length N
M=20; mup=zeros(1,N*M); mup(1:M:N*M)=m;  % oversampling by factor of M
ps=hamming(2*M);                         % hamming pulse of width M
x=filter(ps,1,mup);                      % convolve pulse shape with mup
neye=5; c=floor(length(x)/(neye*M));     % number of eyes to plot
xp=x(N*M-neye*M*(c-3)+1:N*M);            % dont plot transients at start
t=(1:neye*M)/M;
subplot(4,1,2),plot(t,reshape(xp,neye*M,c-3))
title('Eye diagram for the 2T-wide hamming pulse shape')

N=1000; m=pam(N,4,5);                    % random signal of length N
M=20; mup=zeros(1,N*M); mup(1:M:N*M)=m;  % oversampling by factor of M
ps=hamming(3*M);                         % hamming pulse of width M
x=filter(ps,1,mup);                      % convolve pulse shape with mup
neye=5; c=floor(length(x)/(neye*M));     % number of eyes to plot
xp=x(N*M-neye*M*(c-3)+1:N*M);            % dont plot transients at start
subplot(4,1,3),plot(t,3/4*reshape(xp,neye*M,c-3))
title('Eye diagram for the 3T-wide hamming pulse shape')

N=1000; m=pam(N,4,5);                    % random signal of length N
M=20; mup=zeros(1,N*M); mup(1:M:N*M)=m;  % oversampling by factor of M
ps=hamming(5*M);                         % hamming pulse of width M
x=filter(ps,1,mup);                      % convolve pulse shape with mup
neye=5; c=floor(length(x)/(neye*M));     % number of eyes to plot
xp=x(N*M-neye*M*(c-3)+1:N*M);            % dont plot transients at start
subplot(4,1,4),plot(t,3/5*reshape(xp,neye*M,c-3))
title('Eye diagram for the 5T-wide hamming pulse shape')
xlabel('symbols')
hold off

L=10; ps=srrc(L,0,M,0);                 % sinc pulse shape L symbols wide
ps=ones(1,M);                           % square pulse width M
