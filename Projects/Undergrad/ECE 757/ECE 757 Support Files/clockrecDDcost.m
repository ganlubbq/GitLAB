% clockrecDDcost.m: draw error surfaces for cluster variance performance
% in terms of chosen pulse shape

l=10;                       % 1/2 duration of pulse shape
beta=0.5;                   % rolloff for pulse shape
m=20;                       % evaluate at m different points
ps=srrc(l,beta,m);          % make srrc pulse shape
psrc=conv(ps,ps);           % convolve 2 srrc's to get rc
psrc=psrc(l*m+1:3*l*m+1);   % truncate to same length as ps
cost=zeros(1,m); n=20000;   % experimental performance
x=zeros(1,n);
for i=1:m                   % for each offset
  pt=psrc(i:m:end);         % rc is shifted i/m of a symbol
  for k=1:n                 % do it n times
    rd=pam(length(pt),4,5); % random 4-PAM vector
    x(k)=sum(rd.*pt);       % received data point w/ ISI
  end
  err=quantalph(x,[-3,-1,1,3])-x';  % quantize to alphabet
  cost(i)=sum(err.^2)/length(err);  % DD performance function
end

offset=(0:m-1)/m;
plot(offset,cost)               % DD cost
xlabel('timing offset \tau')
ylabel('value of cost functions')
