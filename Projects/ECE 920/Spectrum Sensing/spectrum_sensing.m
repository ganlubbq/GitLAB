%% Spectrum Sensing Script.
%
% Symbol Definitions.

N = 10e3; Ts = 0.0001; M = 1;
time=Ts*(N*M-1);  t=0:Ts:time;
w = 2*pi;

crg = 0.25;
noise = crg*randn(N*M,1).';

%% Main Operation

%% energy_decision: Decision metric for energy detector.
function M = energy_decision(obv)
	for(i=1:size(obv))
		sum_vec(1,i) =  (abs(obv(1,i)))^2;
	end
	M = sum(sum_vec,2);
end
