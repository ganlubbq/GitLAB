function [s_out,sq_out,sqh_out, qindex, Delta,SQNR] = sampandquant(sig_in,L,td,ts)

if (rem(ts/td,1)==0)
	nfac = round(ts/td);
	p_zoh = ones(1,nfac);
	s_out = downsample(sig_in,nfac);
	[sq_out, qindex, Delta, SQNR] = uniquant(s_out,L);
	s_out = upsample(s_out,nfac);
	sqh_out = kron(sq_out,p_zoh);
	sq_out = upsample(sq_out,nfac);
	else
		warning('ts/td is not an integer!');
		s_out=[];sq_out=[];sqh_out=[];Delta=[];SQNR=[];
	end
end