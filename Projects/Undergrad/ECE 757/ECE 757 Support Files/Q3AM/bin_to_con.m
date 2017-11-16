function f=bin_to_con(msg,constl)

vals=imag(constl(1:sqrt(length(constl))));
nc=log(sqrt(length(constl)))/log(2);

f=vals(bin2dec(reshape(num2str(msg')',length(msg)/nc,nc))+1)';
