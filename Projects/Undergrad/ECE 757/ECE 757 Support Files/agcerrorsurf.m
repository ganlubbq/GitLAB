% agcerrorsurf.m: draw error surface
n=10000;                       % number of steps in simulation
r=randn(n,1);                  % generate random inputs
ds=0.15;                       % desired power of output
range=[-0.7:0.02:0.7];         % range specifies range of values of a
Jagc=zeros(size(range));
j=0;
for a=range                    % for each value a
  j=j+1;
  tot=0;
  for i=1:n
    tot=tot+abs(a)*((1/3)*a^2*r(i)^2-ds);  % total cost over all possibilities
  end
  Jagc(j)=tot/n;               % take average value, and save
end
plot(range, Jagc)
ylabel('cost J(a)')
xlabel('adaptive gain a')

% Alternate loop implementation (faster)
%for a=range                        % for each value a
%  j=j+1;
%  Jagc(j)=mean(abs(a)*((1/3)*a^2*r.^2-ds));  % total averaged cost over all possibilities
%end

