% blockcode52.m Part 1: Definition of (5,2) binary linear block code
% the generator and parity check matrices
g=[1 0 1 0 1;
   0 1 0 1 1];
h=[1 0 1 0 0;
   0 1 0 1 0;
   1 1 0 0 1];
% the four code words cw=x*g (mod 2)
x=zeros(4,2); cw=zeros(4,5);
x(1,:)=[0 0]; cw(1,:)=mod(x(1,:)*g,2);
x(2,:)=[0 1]; cw(2,:)=mod(x(2,:)*g,2);
x(3,:)=[1 0]; cw(3,:)=mod(x(3,:)*g,2);
x(4,:)=[1 1]; cw(4,:)=mod(x(4,:)*g,2);
% the syndrome table
syn=[0 0 0 0 0;
     0 0 0 0 1;
     0 0 0 1 0;
     0 1 0 0 0;
     0 0 1 0 0;
     1 0 0 0 0;
     1 1 0 0 0;
     1 0 0 1 0];
% blockcode52.m Part 2: encoding and decoding data
p=.1;                             % probability of bit flip
m=10000;                          % length of message
dat=0.5*(sign(rand(1,m)-0.5)+1);  % m random 0s and 1s
for i=1:2:m
  c=mod([dat(i) dat(i+1)]*g,2);   % build codeword
  for j=1:length(c)
    if rand<p, c(j)=-c(j)+1; end  % flip bits with prob p
  end
  y=c;                            % received signal
  eh=mod(y*h',2);                 % multiply by parity check h'
  ehind=eh(1)*4+eh(2)*2+eh(3)+1;  % turn syndrome into index
  e=syn(ehind,:);                 % error from syndrome table
  y=mod(y-e,2);                   % add e to correct errors
  for j=1:max(size(x))            % recover message from codewords
    if y==cw(j,:), z(i:i+1)=x(j,:); end
  end
end
err=sum(abs(z-dat))               % how many errors occurred

