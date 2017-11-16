% dlpf.m: differentiation and filtering commute
s=randn(1,100);                % generate random 'data'
h=randn(1,10);                 % an arbitrary impulse response
dlpfs=diff(filter(h,1,s));     % take deriv of filtered input
lpfds=filter(h,1,diff(s));     % filter the deriv of input
dlpfs-lpfds                    % compare the two
