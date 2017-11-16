% qamtimobj.m: draw error surfaces for baseband signal cost functions
m=20; n=1000;                       % n data points, m+1 taus
unp=hamming(m);                     % pulse shape
cp=conv(unp,unp);                   % matched filter
ps=sqrt(m)*cp/sqrt(sum(cp.^2));     % normalize
cost=zeros(m+1,1);
for i=1:m+1                         % for each offset
  s1=pam(n/m,2,1);s2=pam(n/m,2,1);  % create 4-QAM sequence
  mup1=zeros(1,n);mup1(1:m:end)=s1; % zero pad and upsample
  mup2=zeros(1,n);mup2(1:m:end)=s2;
  m1=filter(ps,1,mup1);             % convolve pulse shape&data
  m2=filter(ps,1,mup2);             % convolve pulse shape&data
  sm1=m1((length(ps)-1)/2+i:m:end); % sampled baseband data
  sm2=m2((length(ps)-1)/2+i:m:end); % with timing offset iT/m
  cost(i)=sum(sqrt(sm1.^2+sm2.^2))/length(sm1); % cost function
end

plot((0:m)/m,cost,'--'), hold on      % cost (absolute value)
xlabel('timing offset \tau')
ylabel('value of cost functions')
