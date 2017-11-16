function f=con_to_bin(msg,constl)

vals=imag(constl(1:sqrt(length(constl))));
nc=log(sqrt(length(constl)))/log(2);
binVals=zeros(sqrt(length(constl)),nc);
for k=0:sqrt(length(constl))-1
  binVals(k+1,:)=dec2base(k,2,nc)-48;
end

m=1;
for k=1:length(msg)
  [y,i]=min(abs(msg(k)-vals));
  for z=1:nc
    f(m+z-1)=binVals(i,z);
  end
  m=m+nc;
end
